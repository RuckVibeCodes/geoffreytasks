-- Second Brain Documents Table
-- Run this in Supabase SQL Editor (dashboard.supabase.com)
-- Cannot run DDL with anon key

CREATE TABLE IF NOT EXISTS geoffrey.documents (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  folder TEXT NOT NULL,              -- e.g., "Projects/KLASS"
  project TEXT,                      -- e.g., "KLASS" (extracted from folder)
  file_path TEXT UNIQUE NOT NULL,    -- relative path from Second Brain root
  file_hash TEXT,                    -- MD5 of content for change detection
  category TEXT DEFAULT 'project',   -- project, journal, resource, area, idea, content
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  synced_at TIMESTAMPTZ DEFAULT now()
);

-- RLS
ALTER TABLE geoffrey.documents ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow anon read documents" ON geoffrey.documents
  FOR SELECT TO anon USING (true);

CREATE POLICY "Allow anon insert documents" ON geoffrey.documents
  FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "Allow anon update documents" ON geoffrey.documents
  FOR UPDATE TO anon USING (true);

CREATE POLICY "Allow anon delete documents" ON geoffrey.documents
  FOR DELETE TO anon USING (true);
