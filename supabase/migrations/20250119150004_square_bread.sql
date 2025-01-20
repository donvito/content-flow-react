/*
  # Add image support to content table

  1. Changes
    - Add image_url column to content table
    - Create storage bucket for content images
    - Add storage policies for authenticated users
*/

-- Add image_url column to content table
ALTER TABLE content ADD COLUMN image_url text;

-- Enable storage
INSERT INTO storage.buckets (id, name, public) 
VALUES ('content-images', 'content-images', true);

-- Set up storage policies
CREATE POLICY "Content images are publicly accessible"
ON storage.objects FOR SELECT
USING (bucket_id = 'content-images');

CREATE POLICY "Users can upload content images"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'content-images' 
  AND auth.role() = 'authenticated'
);

CREATE POLICY "Users can update their own content images"
ON storage.objects FOR UPDATE
USING (
  bucket_id = 'content-images' 
  AND auth.uid() = owner
);

CREATE POLICY "Users can delete their own content images"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'content-images' 
  AND auth.uid() = owner
);