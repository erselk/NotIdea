-- Hesap silme: Giriş yapmış kullanıcı kendi auth.users kaydını silebilir.
-- İstemci önce notes ve profiles'ı sildikten sonra bu RPC'yi çağırır.
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
  'Mevcut kullanıcının auth.users kaydını siler. Hesap silme akışında notes ve profiles silindikten sonra çağrılmalı.';
