-- Sonsuz döngü oluşturan eski politikaları siliyoruz
DROP POLICY IF EXISTS "Users can view shares for their notes or shares sent to them" ON public.note_shares;
DROP POLICY IF EXISTS "Users can delete their own note shares" ON public.note_shares;

-- Daha temiz okuma izni (artık notes tablosunu tekrar çağırmadığı için sonsuz loopa girmiyor)
CREATE POLICY "Users can view shares for their notes or shares sent to them"
ON public.note_shares FOR SELECT
USING (
    auth.uid() = shared_by_user_id 
    OR auth.uid() = shared_with_user_id
);

-- Daha temiz silme izni (notes tablosunu tekrar çağırmadığı için sonsuz loopa girmiyor)
CREATE POLICY "Users can delete their own note shares"
ON public.note_shares FOR DELETE
USING (
    auth.uid() = shared_by_user_id
);
