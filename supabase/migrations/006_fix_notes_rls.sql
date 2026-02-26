-- 1. note_shares Tablosundaki Eksikleri ALTER ile Ekleyelim (Zaten varsa bile hata vermez)
ALTER TABLE public.note_shares 
ADD COLUMN IF NOT EXISTS share_token TEXT,
ADD COLUMN IF NOT EXISTS permission TEXT NOT NULL DEFAULT 'read_only' CHECK (permission IN ('read_only', 'read_write'));

-- Mevcut CONSTRAINT'i link paylaşımına da izin verecek şekilde güncelleyelim
ALTER TABLE public.note_shares DROP CONSTRAINT IF EXISTS share_target_required;
ALTER TABLE public.note_shares ADD CONSTRAINT share_target_required CHECK (
    shared_with_user_id IS NOT NULL OR shared_with_group_id IS NOT NULL OR share_token IS NOT NULL
);

-- Indexleri garantileyelim
CREATE INDEX IF NOT EXISTS idx_note_shares_note_id ON public.note_shares(note_id);
CREATE INDEX IF NOT EXISTS idx_note_shares_shared_with_user ON public.note_shares(shared_with_user_id);
CREATE INDEX IF NOT EXISTS idx_note_shares_share_token ON public.note_shares(share_token);

-- 2. Notes Politikalarını Onaralım (Hata çıkartan profile_id'leri user_id yaptık)

-- Önce eski veya hatalı politikaları temizleyelim (isimlere dikkat ederek)
DROP POLICY IF EXISTS "Notes are viewable by owner, public, friends, or shared users" ON public.notes;
DROP POLICY IF EXISTS "Users can update their own notes or shared with write access" ON public.notes;
DROP POLICY IF EXISTS "Notes are viewable by owner, public, or friends" ON public.notes;
DROP POLICY IF EXISTS "Users can update their own notes" ON public.notes;


-- Düzeltilmiş Okuma İzni (group_members içindeki user_id hatasız kullanıldı)
CREATE POLICY "Notes are viewable by owner, public, friends, or shared users" 
ON public.notes FOR SELECT 
USING (
  auth.uid() = user_id 
  OR visibility = 'public' 
  OR (visibility = 'friends' AND EXISTS (
      SELECT 1 FROM friendships 
      WHERE status = 'accepted' AND (
        (requester_id = auth.uid() AND addressee_id = notes.user_id)
        OR 
        (addressee_id = auth.uid() AND requester_id = notes.user_id)
      )
  ))
  OR EXISTS (
      SELECT 1 FROM note_shares 
      WHERE note_id = notes.id AND (
          shared_with_user_id = auth.uid()
          OR (shared_with_group_id IS NOT NULL AND EXISTS (
              SELECT 1 FROM group_members 
              WHERE group_id = shared_with_group_id AND user_id = auth.uid()
          ))
      )
  )
);

-- Düzeltilmiş Güncelleme İzni
CREATE POLICY "Users can update their own notes or shared with write access" 
ON public.notes FOR UPDATE 
USING (
  auth.uid() = user_id 
  OR EXISTS (
    SELECT 1 FROM note_shares 
    WHERE note_id = public.notes.id 
    AND (
        shared_with_user_id = auth.uid() 
        OR (shared_with_group_id IS NOT NULL AND EXISTS (
            SELECT 1 FROM group_members 
            WHERE group_id = shared_with_group_id AND user_id = auth.uid()
        ))
    )
    AND permission = 'read_write'
  )
);
