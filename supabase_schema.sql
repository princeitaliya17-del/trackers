-- Supabase SQL Schema for Exam Prep Tracker

-- 1. Create App State table to store topics, lectures, problems and notes
CREATE TABLE IF NOT EXISTS public.exam_prep_state (
  id TEXT PRIMARY KEY DEFAULT 'primary_state',
  data JSONB NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable Row Level Security (RLS)
ALTER TABLE public.exam_prep_state ENABLE ROW LEVEL SECURITY;

-- Allow public read and write (for personal tracker use)
CREATE POLICY "Allow public all access on exam_prep_state"
ON public.exam_prep_state
FOR ALL
USING (true)
WITH CHECK (true);

-- 2. Create Storage Bucket for Short Notes (PDFs, Images)
INSERT INTO storage.buckets (id, name, public)
VALUES ('exam_notes', 'exam_notes', true)
ON CONFLICT (id) DO NOTHING;

-- Storage policies to allow uploading and reading files
CREATE POLICY "Public Access to exam_notes"
ON storage.objects FOR SELECT
USING ( bucket_id = 'exam_notes' );

CREATE POLICY "Public Upload to exam_notes"
ON storage.objects FOR INSERT
WITH CHECK ( bucket_id = 'exam_notes' );

CREATE POLICY "Public Delete on exam_notes"
ON storage.objects FOR DELETE
USING ( bucket_id = 'exam_notes' );
