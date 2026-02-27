-- Migration 011: Production fixes
-- Make note-images bucket public so image URLs are accessible without auth

UPDATE storage.buckets
SET public = true
WHERE id = 'note-images';
