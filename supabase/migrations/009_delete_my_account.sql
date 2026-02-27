-- Hesap silme: Giriş yapmış kullanıcı kendi auth.users kaydını silebilir.
-- auth.users CASCADE ile bağlı profiles ve notes otomatik silinir.
-- SECURITY DEFINER ile auth schema üzerinde silme yetkisi kullanılır.

CREATE OR REPLACE FUNCTION public.delete_my_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
    DELETE FROM auth.users WHERE id = auth.uid();
END;
$$;

-- Sadece giriş yapmış kullanıcılar çağırabilsin
GRANT EXECUTE ON FUNCTION public.delete_my_account() TO authenticated;
GRANT EXECUTE ON FUNCTION public.delete_my_account() TO service_role;

COMMENT ON FUNCTION public.delete_my_account() IS
  'Mevcut kullanıcının auth.users kaydını siler. CASCADE ile tüm veriler otomatik temizlenir.';
