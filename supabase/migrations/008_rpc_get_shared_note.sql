CREATE OR REPLACE FUNCTION public.get_shared_note(p_note_id UUID, p_token TEXT)
RETURNS SETOF public.notes
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Check if there is a matching token for this note in note_shares
    IF EXISTS (
        SELECT 1 FROM public.note_shares
        WHERE note_id = p_note_id AND share_token = p_token
    ) THEN
        RETURN QUERY SELECT * FROM public.notes WHERE id = p_note_id LIMIT 1;
    ELSE
        RETURN;
    END IF;
END;
$$;
