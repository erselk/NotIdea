-- NotIdea - app_versions tablosu
-- Uygulama sürümlerini ve güncelleme kurallarını yönetmek için kullanılır.

create table if not exists public.app_versions (
  id uuid primary key default gen_random_uuid(),
  platform text not null check (platform in ('android', 'web')),
  version text not null,
  min_supported_version text not null,
  download_url text not null,
  force_update boolean not null default false,
  changelog_tr text,
  changelog_en text,
  created_at timestamptz not null default now()
);

-- RLS: herkes (anon dahil) sadece okuyabilsin; yazma sadece servis rolü / panelden.
alter table public.app_versions enable row level security;

do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'public'
      and tablename = 'app_versions'
      and policyname = 'app_versions_select_public'
  ) then
    create policy app_versions_select_public
      on public.app_versions
      for select
      using (true);
  end if;
end
$$;

