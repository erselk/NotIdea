-- 1. Notes Tablosu İçin RLS'i Aktif Et
ALTER TABLE public.notes ENABLE ROW LEVEL SECURITY;

-- 2. Mevcut İlkeli (Varsa) Temizle (Böylece çakışma yaşamazsın)
DROP POLICY IF EXISTS "Users can insert their own notes" ON public.notes;
DROP POLICY IF EXISTS "Users can update their own notes" ON public.notes;
DROP POLICY IF EXISTS "Users can delete their own notes" ON public.notes;
DROP POLICY IF EXISTS "Notes are viewable by owner, public, or friends" ON public.notes;

-- 3. INSERT (Yeni Not Ekleme) İzni: Sadece kişi kendi ID'siyle ekleyebilir.
CREATE POLICY "Users can insert their own notes" 
ON public.notes FOR INSERT 
WITH CHECK (auth.uid() = user_id);

-- 4. UPDATE (Not Düzenleme) İzni: Sadece kişi kendi notlarını güncelleyebilir.
CREATE POLICY "Users can update their own notes" 
ON public.notes FOR UPDATE 
USING (auth.uid() = user_id);

-- 5. DELETE (Not Silme) İzni: Sadece kişi kendi notlarını silebilir.
CREATE POLICY "Users can delete their own notes" 
ON public.notes FOR DELETE 
USING (auth.uid() = user_id);

-- 6. SELECT (Okuma/Görüntüleme) İzni: Kişinin kendisi, "public" olarak işaretli notlar veya "friends_only" iken aktif arkadaşlığı olanlar okuyabilir.
CREATE POLICY "Notes are viewable by owner, public, or friends" 
ON public.notes FOR SELECT 
USING (
  auth.uid() = user_id 
  OR visibility = 'public' 
  OR (visibility = 'friends_only' AND EXISTS (
      SELECT 1 FROM friendships 
      WHERE (
        (requester_id = auth.uid() AND addressee_id = notes.user_id AND status = 'accepted')
        OR 
        (addressee_id = auth.uid() AND requester_id = notes.user_id AND status = 'accepted')
      )
  ))
);
