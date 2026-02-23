-- ============================================================================
-- NotIdea - Initial Database Schema
-- Supabase Migration: 001_initial_schema.sql
-- ============================================================================

-- ============================================================================
-- 1. EXTENSIONS
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "moddatetime";

-- ============================================================================
-- 2. TABLES
-- ============================================================================

-- --------------------------------------------------------------------------
-- profiles: public user info, auto-created on auth.users signup
-- --------------------------------------------------------------------------
CREATE TABLE public.profiles (
    id          UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    username    TEXT UNIQUE NOT NULL
                    CONSTRAINT username_format CHECK (
                        username ~ '^[a-zA-Z0-9_]{3,20}$'
                    ),
    display_name TEXT,
    avatar_url  TEXT,
    bio         TEXT CONSTRAINT bio_max_length CHECK (char_length(bio) <= 500),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.profiles IS 'Public profile for each authenticated user.';

-- --------------------------------------------------------------------------
-- notes: markdown notes with visibility control and soft delete
-- --------------------------------------------------------------------------
CREATE TABLE public.notes (
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id     UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    title       TEXT NOT NULL
                    CONSTRAINT title_max_length CHECK (char_length(title) <= 200),
    content     TEXT NOT NULL DEFAULT '',
    color       TEXT,
    visibility  TEXT NOT NULL DEFAULT 'private'
                    CONSTRAINT visibility_values CHECK (
                        visibility IN ('public', 'private', 'friends')
                    ),
    is_favorite BOOLEAN NOT NULL DEFAULT false,
    is_deleted  BOOLEAN NOT NULL DEFAULT false,
    deleted_at  TIMESTAMPTZ,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    tags        TEXT[] NOT NULL DEFAULT '{}'
);

COMMENT ON TABLE public.notes IS 'User notes stored as markdown. Supports soft delete and visibility levels.';

-- --------------------------------------------------------------------------
-- note_images: images attached to notes, stored in Supabase Storage
-- --------------------------------------------------------------------------
CREATE TABLE public.note_images (
    id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    note_id      UUID NOT NULL REFERENCES public.notes(id) ON DELETE CASCADE,
    image_url    TEXT NOT NULL,
    storage_path TEXT NOT NULL,
    width        INTEGER,
    height       INTEGER,
    size_bytes   INTEGER,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.note_images IS 'Metadata for images embedded in notes. Actual files live in Supabase Storage.';

-- --------------------------------------------------------------------------
-- friendships: bidirectional friend requests with status workflow
-- --------------------------------------------------------------------------
CREATE TABLE public.friendships (
    id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    requester_id  UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    addressee_id  UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    status        TEXT NOT NULL DEFAULT 'pending'
                      CONSTRAINT friendship_status_values CHECK (
                          status IN ('pending', 'accepted', 'rejected', 'blocked')
                      ),
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT no_self_friendship CHECK (requester_id != addressee_id),
    CONSTRAINT unique_friendship  UNIQUE (requester_id, addressee_id)
);

COMMENT ON TABLE public.friendships IS 'Friend requests and relationships between users.';

-- --------------------------------------------------------------------------
-- groups: user-created groups for sharing notes
-- --------------------------------------------------------------------------
CREATE TABLE public.groups (
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name        TEXT NOT NULL
                    CONSTRAINT group_name_max_length CHECK (char_length(name) <= 100),
    description TEXT CONSTRAINT group_desc_max_length CHECK (char_length(description) <= 500),
    owner_id    UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    avatar_url  TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.groups IS 'Groups that users can create and share notes with.';

-- --------------------------------------------------------------------------
-- group_members: membership and roles within groups
-- --------------------------------------------------------------------------
CREATE TABLE public.group_members (
    id        UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    group_id  UUID NOT NULL REFERENCES public.groups(id) ON DELETE CASCADE,
    user_id   UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    role      TEXT NOT NULL DEFAULT 'member'
                  CONSTRAINT member_role_values CHECK (
                      role IN ('owner', 'admin', 'member')
                  ),
    joined_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT unique_group_member UNIQUE (group_id, user_id)
);

COMMENT ON TABLE public.group_members IS 'Tracks which users belong to which groups and their role.';

-- --------------------------------------------------------------------------
-- note_shares: sharing notes with specific users or groups
-- --------------------------------------------------------------------------
CREATE TABLE public.note_shares (
    id                   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    note_id              UUID NOT NULL REFERENCES public.notes(id) ON DELETE CASCADE,
    shared_by_user_id    UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    shared_with_user_id  UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    shared_with_group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT share_target_required CHECK (
        shared_with_user_id IS NOT NULL OR shared_with_group_id IS NOT NULL
    )
);

COMMENT ON TABLE public.note_shares IS 'Explicit note shares to individual users or groups.';

-- ============================================================================
-- 3. INDEXES
-- ============================================================================

-- profiles
CREATE INDEX idx_profiles_username ON public.profiles (username);

-- notes
CREATE INDEX idx_notes_user_id    ON public.notes (user_id);
CREATE INDEX idx_notes_visibility ON public.notes (visibility);
CREATE INDEX idx_notes_is_deleted ON public.notes (is_deleted);
CREATE INDEX idx_notes_is_fav     ON public.notes (is_favorite);
CREATE INDEX idx_notes_created_at ON public.notes (created_at DESC);
CREATE INDEX idx_notes_user_active ON public.notes (user_id, is_deleted, created_at DESC);
CREATE INDEX idx_notes_public     ON public.notes (visibility, is_deleted)
    WHERE visibility = 'public' AND is_deleted = false;

-- full-text search index on notes
CREATE INDEX idx_notes_fts ON public.notes
    USING GIN (to_tsvector('english', coalesce(title, '') || ' ' || coalesce(content, '')));

-- friendships
CREATE INDEX idx_friendships_requester ON public.friendships (requester_id, status);
CREATE INDEX idx_friendships_addressee ON public.friendships (addressee_id, status);

-- group_members
CREATE INDEX idx_group_members_group ON public.group_members (group_id);
CREATE INDEX idx_group_members_user  ON public.group_members (user_id);

-- note_shares
CREATE INDEX idx_note_shares_note       ON public.note_shares (note_id);
CREATE INDEX idx_note_shares_with_user  ON public.note_shares (shared_with_user_id);
CREATE INDEX idx_note_shares_with_group ON public.note_shares (shared_with_group_id);

-- note_images
CREATE INDEX idx_note_images_note ON public.note_images (note_id);

-- ============================================================================
-- 4. TRIGGERS
-- ============================================================================

-- Auto-update updated_at via moddatetime
CREATE TRIGGER trg_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION moddatetime(updated_at);

CREATE TRIGGER trg_notes_updated_at
    BEFORE UPDATE ON public.notes
    FOR EACH ROW EXECUTE FUNCTION moddatetime(updated_at);

CREATE TRIGGER trg_friendships_updated_at
    BEFORE UPDATE ON public.friendships
    FOR EACH ROW EXECUTE FUNCTION moddatetime(updated_at);

CREATE TRIGGER trg_groups_updated_at
    BEFORE UPDATE ON public.groups
    FOR EACH ROW EXECUTE FUNCTION moddatetime(updated_at);

-- --------------------------------------------------------------------------
-- Auto-create profile when a new user signs up
-- --------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    INSERT INTO public.profiles (id, username, display_name, avatar_url)
    VALUES (
        NEW.id,
        COALESCE(
            NEW.raw_user_meta_data ->> 'username',
            'user_' || substr(NEW.id::text, 1, 8)
        ),
        COALESCE(
            NEW.raw_user_meta_data ->> 'display_name',
            NEW.raw_user_meta_data ->> 'full_name',
            NEW.raw_user_meta_data ->> 'name',
            ''
        ),
        NEW.raw_user_meta_data ->> 'avatar_url'
    );
    RETURN NEW;
END;
$$;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- --------------------------------------------------------------------------
-- Auto-add group owner as a member with 'owner' role
-- --------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.handle_new_group()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    INSERT INTO public.group_members (group_id, user_id, role)
    VALUES (NEW.id, NEW.owner_id, 'owner');
    RETURN NEW;
END;
$$;

CREATE TRIGGER on_group_created
    AFTER INSERT ON public.groups
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_group();

-- --------------------------------------------------------------------------
-- Auto-set deleted_at when note is soft-deleted
-- --------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.handle_note_soft_delete()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    IF NEW.is_deleted = true AND OLD.is_deleted = false THEN
        NEW.deleted_at = now();
    ELSIF NEW.is_deleted = false AND OLD.is_deleted = true THEN
        NEW.deleted_at = NULL;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER on_note_soft_delete
    BEFORE UPDATE ON public.notes
    FOR EACH ROW
    WHEN (OLD.is_deleted IS DISTINCT FROM NEW.is_deleted)
    EXECUTE FUNCTION public.handle_note_soft_delete();

-- ============================================================================
-- 5. RLS POLICIES
-- ============================================================================

-- Enable RLS on ALL tables
ALTER TABLE public.profiles      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notes         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.note_images   ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.friendships   ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.groups        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.group_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.note_shares   ENABLE ROW LEVEL SECURITY;

-- ==========================================================================
-- Helper: check if two users are accepted friends
-- ==========================================================================
CREATE OR REPLACE FUNCTION public.are_friends(uid1 UUID, uid2 UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.friendships
        WHERE status = 'accepted'
          AND (
              (requester_id = uid1 AND addressee_id = uid2)
              OR
              (requester_id = uid2 AND addressee_id = uid1)
          )
    );
$$;

-- ==========================================================================
-- Helper: check if user is a member of a specific group
-- ==========================================================================
CREATE OR REPLACE FUNCTION public.is_group_member(uid UUID, gid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.group_members
        WHERE group_id = gid AND user_id = uid
    );
$$;

-- ==========================================================================
-- Helper: check if user has note access via note_shares
-- ==========================================================================
CREATE OR REPLACE FUNCTION public.has_note_share_access(uid UUID, nid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.note_shares ns
        WHERE ns.note_id = nid
          AND (
              ns.shared_with_user_id = uid
              OR EXISTS (
                  SELECT 1 FROM public.group_members gm
                  WHERE gm.group_id = ns.shared_with_group_id
                    AND gm.user_id = uid
              )
          )
    );
$$;

-- --------------------------------------------------------------------------
-- PROFILES policies
-- --------------------------------------------------------------------------

-- Anyone can view profiles (public info)
CREATE POLICY profiles_select ON public.profiles
    FOR SELECT USING (true);

-- Users can only insert their own profile (normally handled by trigger)
CREATE POLICY profiles_insert ON public.profiles
    FOR INSERT WITH CHECK (auth.uid() = id);

-- Users can only update their own profile
CREATE POLICY profiles_update ON public.profiles
    FOR UPDATE USING (auth.uid() = id)
    WITH CHECK (auth.uid() = id);

-- Users can only delete their own profile
CREATE POLICY profiles_delete ON public.profiles
    FOR DELETE USING (auth.uid() = id);

-- --------------------------------------------------------------------------
-- NOTES policies
-- --------------------------------------------------------------------------

-- Owner sees all own notes.
-- Others see: public (not deleted), friends-only (not deleted, if friend),
-- or explicitly shared (not deleted).
CREATE POLICY notes_select ON public.notes
    FOR SELECT USING (
        user_id = auth.uid()
        OR (
            is_deleted = false
            AND (
                visibility = 'public'
                OR (visibility = 'friends' AND public.are_friends(auth.uid(), user_id))
                OR public.has_note_share_access(auth.uid(), id)
            )
        )
    );

-- Authenticated users can create notes under their own user_id
CREATE POLICY notes_insert ON public.notes
    FOR INSERT WITH CHECK (
        auth.uid() = user_id
    );

-- Only note owner can update
CREATE POLICY notes_update ON public.notes
    FOR UPDATE USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Only note owner can delete
CREATE POLICY notes_delete ON public.notes
    FOR DELETE USING (auth.uid() = user_id);

-- --------------------------------------------------------------------------
-- NOTE_IMAGES policies
-- --------------------------------------------------------------------------

-- Visibility follows the parent note
CREATE POLICY note_images_select ON public.note_images
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.notes n
            WHERE n.id = note_id
              AND (
                  n.user_id = auth.uid()
                  OR (
                      n.is_deleted = false
                      AND (
                          n.visibility = 'public'
                          OR (n.visibility = 'friends' AND public.are_friends(auth.uid(), n.user_id))
                          OR public.has_note_share_access(auth.uid(), n.id)
                      )
                  )
              )
        )
    );

-- Only note owner can insert images
CREATE POLICY note_images_insert ON public.note_images
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.notes n
            WHERE n.id = note_id AND n.user_id = auth.uid()
        )
    );

-- Only note owner can delete images
CREATE POLICY note_images_delete ON public.note_images
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM public.notes n
            WHERE n.id = note_id AND n.user_id = auth.uid()
        )
    );

-- --------------------------------------------------------------------------
-- FRIENDSHIPS policies
-- --------------------------------------------------------------------------

-- Users can see friendships they are part of
CREATE POLICY friendships_select ON public.friendships
    FOR SELECT USING (
        auth.uid() = requester_id OR auth.uid() = addressee_id
    );

-- Authenticated users can create friend requests (as requester)
CREATE POLICY friendships_insert ON public.friendships
    FOR INSERT WITH CHECK (
        auth.uid() = requester_id
    );

-- Addressee can accept/reject; either party can block
CREATE POLICY friendships_update ON public.friendships
    FOR UPDATE USING (
        auth.uid() = addressee_id
        OR auth.uid() = requester_id
    )
    WITH CHECK (
        CASE
            WHEN auth.uid() = addressee_id THEN
                status IN ('accepted', 'rejected', 'blocked')
            WHEN auth.uid() = requester_id THEN
                status = 'blocked'
            ELSE false
        END
    );

-- Either party can delete the friendship
CREATE POLICY friendships_delete ON public.friendships
    FOR DELETE USING (
        auth.uid() = requester_id OR auth.uid() = addressee_id
    );

-- --------------------------------------------------------------------------
-- GROUPS policies
-- --------------------------------------------------------------------------

-- Members can see their groups; basic info visible to all authenticated users
CREATE POLICY groups_select ON public.groups
    FOR SELECT USING (
        public.is_group_member(auth.uid(), id)
        OR owner_id = auth.uid()
    );

-- Authenticated users can create groups
CREATE POLICY groups_insert ON public.groups
    FOR INSERT WITH CHECK (
        auth.uid() = owner_id
    );

-- Only owner or admin can update group info
CREATE POLICY groups_update ON public.groups
    FOR UPDATE USING (
        owner_id = auth.uid()
        OR EXISTS (
            SELECT 1 FROM public.group_members gm
            WHERE gm.group_id = id
              AND gm.user_id = auth.uid()
              AND gm.role = 'admin'
        )
    )
    WITH CHECK (
        owner_id = auth.uid()
        OR EXISTS (
            SELECT 1 FROM public.group_members gm
            WHERE gm.group_id = id
              AND gm.user_id = auth.uid()
              AND gm.role = 'admin'
        )
    );

-- Only owner can delete the group
CREATE POLICY groups_delete ON public.groups
    FOR DELETE USING (auth.uid() = owner_id);

-- --------------------------------------------------------------------------
-- GROUP_MEMBERS policies
-- --------------------------------------------------------------------------

-- Members can see other members in their groups
CREATE POLICY group_members_select ON public.group_members
    FOR SELECT USING (
        public.is_group_member(auth.uid(), group_id)
    );

-- Owner or admin can add members
CREATE POLICY group_members_insert ON public.group_members
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.group_members gm
            WHERE gm.group_id = group_id
              AND gm.user_id = auth.uid()
              AND gm.role IN ('owner', 'admin')
        )
        -- Also allow the trigger-inserted owner row
        OR EXISTS (
            SELECT 1 FROM public.groups g
            WHERE g.id = group_id AND g.owner_id = auth.uid()
        )
    );

-- Owner can change member roles
CREATE POLICY group_members_update ON public.group_members
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.groups g
            WHERE g.id = group_id AND g.owner_id = auth.uid()
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.groups g
            WHERE g.id = group_id AND g.owner_id = auth.uid()
        )
    );

-- Owner/admin can remove members; members can leave (remove themselves)
CREATE POLICY group_members_delete ON public.group_members
    FOR DELETE USING (
        user_id = auth.uid()
        OR EXISTS (
            SELECT 1 FROM public.group_members gm
            WHERE gm.group_id = group_id
              AND gm.user_id = auth.uid()
              AND gm.role IN ('owner', 'admin')
        )
    );

-- --------------------------------------------------------------------------
-- NOTE_SHARES policies
-- --------------------------------------------------------------------------

-- Note owner sees all shares; shared-with users see their own shares
CREATE POLICY note_shares_select ON public.note_shares
    FOR SELECT USING (
        shared_by_user_id = auth.uid()
        OR shared_with_user_id = auth.uid()
        OR (
            shared_with_group_id IS NOT NULL
            AND public.is_group_member(auth.uid(), shared_with_group_id)
        )
    );

-- Only note owner can create shares
CREATE POLICY note_shares_insert ON public.note_shares
    FOR INSERT WITH CHECK (
        auth.uid() = shared_by_user_id
        AND EXISTS (
            SELECT 1 FROM public.notes n
            WHERE n.id = note_id AND n.user_id = auth.uid()
        )
    );

-- Only note owner can remove shares
CREATE POLICY note_shares_delete ON public.note_shares
    FOR DELETE USING (
        auth.uid() = shared_by_user_id
    );

-- ============================================================================
-- 6. STORAGE BUCKETS & POLICIES
-- ============================================================================

-- Create buckets
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES
    ('avatars', 'avatars', true, 2097152, -- 2 MB
        ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif']),
    ('note-images', 'note-images', false, 5242880, -- 5 MB
        ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif']);

-- --------------------------------------------------------------------------
-- avatars bucket: public read, owner upload/update/delete
-- Path convention: {user_id}/{filename}
-- --------------------------------------------------------------------------

-- Anyone can view avatars (public bucket)
CREATE POLICY avatars_select ON storage.objects
    FOR SELECT
    USING (bucket_id = 'avatars');

-- Users can upload their own avatar
CREATE POLICY avatars_insert ON storage.objects
    FOR INSERT
    WITH CHECK (
        bucket_id = 'avatars'
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

-- Users can update their own avatar
CREATE POLICY avatars_update ON storage.objects
    FOR UPDATE
    USING (
        bucket_id = 'avatars'
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

-- Users can delete their own avatar
CREATE POLICY avatars_delete ON storage.objects
    FOR DELETE
    USING (
        bucket_id = 'avatars'
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

-- --------------------------------------------------------------------------
-- note-images bucket: read follows note visibility, owner upload/delete
-- Path convention: {user_id}/{note_id}/{filename}
-- --------------------------------------------------------------------------

-- Read access follows note visibility via note_images table
CREATE POLICY note_images_storage_select ON storage.objects
    FOR SELECT
    USING (
        bucket_id = 'note-images'
        AND (
            -- Owner can always read their own images
            auth.uid()::text = (storage.foldername(name))[1]
            OR EXISTS (
                SELECT 1 FROM public.note_images ni
                JOIN public.notes n ON n.id = ni.note_id
                WHERE ni.storage_path = name
                  AND n.is_deleted = false
                  AND (
                      n.visibility = 'public'
                      OR (n.visibility = 'friends' AND public.are_friends(auth.uid(), n.user_id))
                      OR public.has_note_share_access(auth.uid(), n.id)
                  )
            )
        )
    );

-- Users can upload images to their own folder
CREATE POLICY note_images_storage_insert ON storage.objects
    FOR INSERT
    WITH CHECK (
        bucket_id = 'note-images'
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

-- Users can update their own images
CREATE POLICY note_images_storage_update ON storage.objects
    FOR UPDATE
    USING (
        bucket_id = 'note-images'
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

-- Users can delete their own images
CREATE POLICY note_images_storage_delete ON storage.objects
    FOR DELETE
    USING (
        bucket_id = 'note-images'
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

-- ============================================================================
-- 7. UTILITY FUNCTIONS
-- ============================================================================

-- --------------------------------------------------------------------------
-- Get accepted friends for a user
-- --------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_user_friends(target_user_id UUID)
RETURNS TABLE (
    friend_id    UUID,
    username     TEXT,
    display_name TEXT,
    avatar_url   TEXT,
    since        TIMESTAMPTZ
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT
        p.id,
        p.username,
        p.display_name,
        p.avatar_url,
        f.updated_at AS since
    FROM public.friendships f
    JOIN public.profiles p ON p.id = CASE
        WHEN f.requester_id = target_user_id THEN f.addressee_id
        ELSE f.requester_id
    END
    WHERE f.status = 'accepted'
      AND (f.requester_id = target_user_id OR f.addressee_id = target_user_id);
$$;

-- --------------------------------------------------------------------------
-- Check if two users are friends (public wrapper)
-- --------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.is_friend_with(uid UUID, other_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT public.are_friends(uid, other_id);
$$;

-- --------------------------------------------------------------------------
-- Full-text search on public notes
-- --------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.search_public_notes(query TEXT, result_limit INTEGER DEFAULT 20)
RETURNS TABLE (
    id         UUID,
    user_id    UUID,
    title      TEXT,
    content    TEXT,
    color      TEXT,
    tags       TEXT[],
    created_at TIMESTAMPTZ,
    username   TEXT,
    avatar_url TEXT,
    rank       REAL
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT
        n.id,
        n.user_id,
        n.title,
        n.content,
        n.color,
        n.tags,
        n.created_at,
        p.username,
        p.avatar_url,
        ts_rank(
            to_tsvector('english', coalesce(n.title, '') || ' ' || coalesce(n.content, '')),
            plainto_tsquery('english', query)
        ) AS rank
    FROM public.notes n
    JOIN public.profiles p ON p.id = n.user_id
    WHERE n.visibility = 'public'
      AND n.is_deleted = false
      AND to_tsvector('english', coalesce(n.title, '') || ' ' || coalesce(n.content, ''))
          @@ plainto_tsquery('english', query)
    ORDER BY rank DESC
    LIMIT result_limit;
$$;

-- --------------------------------------------------------------------------
-- Search users by username or display_name
-- --------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.search_users(query TEXT, result_limit INTEGER DEFAULT 20)
RETURNS TABLE (
    id           UUID,
    username     TEXT,
    display_name TEXT,
    avatar_url   TEXT
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT
        p.id,
        p.username,
        p.display_name,
        p.avatar_url
    FROM public.profiles p
    WHERE p.username   ILIKE '%' || query || '%'
       OR p.display_name ILIKE '%' || query || '%'
    ORDER BY
        CASE WHEN p.username ILIKE query || '%' THEN 0 ELSE 1 END,
        p.username
    LIMIT result_limit;
$$;

-- --------------------------------------------------------------------------
-- Get all notes shared with a specific user (direct + via groups)
-- --------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_shared_notes_for_user(target_user_id UUID)
RETURNS TABLE (
    id              UUID,
    user_id         UUID,
    title           TEXT,
    content         TEXT,
    color           TEXT,
    tags            TEXT[],
    created_at      TIMESTAMPTZ,
    shared_by       TEXT,
    shared_by_avatar TEXT
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT DISTINCT ON (n.id)
        n.id,
        n.user_id,
        n.title,
        n.content,
        n.color,
        n.tags,
        n.created_at,
        p.username   AS shared_by,
        p.avatar_url AS shared_by_avatar
    FROM public.note_shares ns
    JOIN public.notes n    ON n.id = ns.note_id
    JOIN public.profiles p ON p.id = ns.shared_by_user_id
    WHERE n.is_deleted = false
      AND (
          ns.shared_with_user_id = target_user_id
          OR EXISTS (
              SELECT 1 FROM public.group_members gm
              WHERE gm.group_id = ns.shared_with_group_id
                AND gm.user_id = target_user_id
          )
      )
    ORDER BY n.id, n.created_at DESC;
$$;

-- --------------------------------------------------------------------------
-- Permanently delete notes that have been in trash for over 30 days.
-- Call via pg_cron or Supabase Edge Function on a schedule.
-- Example cron: SELECT cron.schedule('cleanup-trash', '0 3 * * *',
--   $$SELECT public.permanently_delete_old_trash()$$);
-- --------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.permanently_delete_old_trash()
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    WITH deleted AS (
        DELETE FROM public.notes
        WHERE is_deleted = true
          AND deleted_at IS NOT NULL
          AND deleted_at < now() - INTERVAL '30 days'
        RETURNING id
    )
    SELECT count(*) INTO deleted_count FROM deleted;

    RETURN deleted_count;
END;
$$;
