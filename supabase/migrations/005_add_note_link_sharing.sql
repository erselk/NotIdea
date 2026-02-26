-- 1. Not Paylaşımları Tablosu Oluşturma
CREATE TABLE IF NOT EXISTS public.note_shares (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    note_id UUID NOT NULL REFERENCES public.notes(id) ON DELETE CASCADE,
    shared_by_user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    shared_with_user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE, -- Belirli bir kullanıcı için
    shared_with_group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE, -- Belirli bir grup için
    share_token TEXT, -- Link ile paylaşım için (benzersiz token)
    permission TEXT NOT NULL DEFAULT 'read_only' CHECK (permission IN ('read_only', 'read_write')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Indexler
CREATE INDEX IF NOT EXISTS idx_note_shares_note_id ON public.note_shares(note_id);
CREATE INDEX IF NOT EXISTS idx_note_shares_shared_with_user ON public.note_shares(shared_with_user_id);
CREATE INDEX IF NOT EXISTS idx_note_shares_share_token ON public.note_shares(share_token);

-- 3. RLS Aktifleştirme
ALTER TABLE public.note_shares ENABLE ROW LEVEL SECURITY;

-- 4. Note Shares Politikaları
CREATE POLICY "Users can view shares for their notes or shares sent to them"
ON public.note_shares FOR SELECT
USING (
    auth.uid() = shared_by_user_id 
    OR auth.uid() = shared_with_user_id
    OR EXISTS (
        SELECT 1 FROM public.notes WHERE id = note_id AND user_id = auth.uid()
    )
);

CREATE POLICY "Users can create shares for their own notes"
ON public.note_shares FOR INSERT
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.notes WHERE id = note_id AND user_id = auth.uid()
    )
);

CREATE POLICY "Users can delete their own note shares"
ON public.note_shares FOR DELETE
USING (
    auth.uid() = shared_by_user_id 
    OR EXISTS (
        SELECT 1 FROM public.notes WHERE id = note_id AND user_id = auth.uid()
    )
);

-- 5. Notes Politikalarını Güncelleme (Read/Write İzni İçin)

-- Önce eski politikaları temizleyelim
DROP POLICY IF EXISTS "Notes are viewable by owner, public, or friends" ON public.notes;
DROP POLICY IF EXISTS "Users can update their own notes" ON public.notes;

-- Gelişmiş Okuma İzni (note_shares tablosuna bakarak)
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

-- Gelişmiş Güncelleme İzni (read_write yetkisi varsa)
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
