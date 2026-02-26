-- ============================================================================
-- NotIdea - Add member_count to groups table
-- Supabase Migration: 010_add_member_count_to_groups.sql
-- ============================================================================
-- groups tablosunda member_count sütunu yok; uygulama insert/select/update
-- yapıyor. Sütunu ekleyip mevcut gruplar için group_members sayısına göre
-- dolduruyoruz.
-- ============================================================================

ALTER TABLE public.groups
  ADD COLUMN IF NOT EXISTS member_count integer NOT NULL DEFAULT 0;

-- Mevcut gruplar için member_count'u group_members sayısına güncelle
UPDATE public.groups g
SET member_count = (
  SELECT count(*)::integer
  FROM public.group_members gm
  WHERE gm.group_id = g.id
);

-- group_members eklenip silindiğinde member_count'u güncelleyen trigger
CREATE OR REPLACE FUNCTION public.sync_group_member_count()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE public.groups
    SET member_count = member_count + 1
    WHERE id = NEW.group_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE public.groups
    SET member_count = GREATEST(0, member_count - 1)
    WHERE id = OLD.group_id;
  END IF;
  RETURN COALESCE(NEW, OLD);
END;
$$;

DROP TRIGGER IF EXISTS trg_sync_group_member_count_ins ON public.group_members;
CREATE TRIGGER trg_sync_group_member_count_ins
  AFTER INSERT ON public.group_members
  FOR EACH ROW EXECUTE FUNCTION public.sync_group_member_count();

DROP TRIGGER IF EXISTS trg_sync_group_member_count_del ON public.group_members;
CREATE TRIGGER trg_sync_group_member_count_del
  AFTER DELETE ON public.group_members
  FOR EACH ROW EXECUTE FUNCTION public.sync_group_member_count();

COMMENT ON COLUMN public.groups.member_count IS 'Number of members in the group; kept in sync by trigger.';
