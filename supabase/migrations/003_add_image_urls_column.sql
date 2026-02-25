-- Add image_urls column to notes table
ALTER TABLE notes ADD COLUMN IF NOT EXISTS image_urls text[] DEFAULT '{}';

-- Re-create the get_user_notes function to include image_urls if you are selecting it directly,
-- though Supabase's auto-generated REST API handles new columns automatically via `select(*)`
