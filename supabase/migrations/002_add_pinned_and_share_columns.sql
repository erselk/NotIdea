-- ============================================================================
-- NotIdea - Add pinned and share columns
-- Supabase Migration: 002_add_pinned_and_share_columns.sql
-- ============================================================================

-- ============================================================================
-- 1. notes: pin alanları
-- ============================================================================

ALTER TABLE public.notes
  ADD COLUMN IF NOT EXISTS is_pinned boolean NOT NULL DEFAULT false;

ALTER TABLE public.notes
  ADD COLUMN IF NOT EXISTS pinned_at timestamptz;

-- Pinli notları hızlı sıralamak için index
CREATE INDEX IF NOT EXISTS idx_notes_is_pinned_pinned_at
  ON public.notes (is_pinned DESC, pinned_at DESC NULLS LAST);

-- ============================================================================
-- 2. note_shares: paylaşım linki ve yetki
-- ============================================================================

ALTER TABLE public.note_shares
  ADD COLUMN IF NOT EXISTS share_token text;

ALTER TABLE public.note_shares
  ADD COLUMN IF NOT EXISTS permission text NOT NULL DEFAULT 'read_only';

-- Her share_token benzersiz olsun (sadece token dolu satırlar için)
CREATE UNIQUE INDEX IF NOT EXISTS idx_note_shares_share_token
  ON public.note_shares (share_token)
  WHERE share_token IS NOT NULL;

