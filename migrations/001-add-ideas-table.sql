-- Migration: Add Ideas Table
-- Run this in Supabase SQL Editor: SQL → New Query → Paste → Run

-- Ideas table (Idea Pipeline)
CREATE TABLE IF NOT EXISTS geoffrey.ideas (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  category TEXT DEFAULT 'app' CHECK (category IN ('app', 'content', 'business', 'feature', 'other')),
  status TEXT DEFAULT 'new' CHECK (status IN ('new', 'exploring', 'planned', 'archived')),
  notes TEXT, -- Extended documentation/notes
  links TEXT[], -- Array of relevant URLs
  priority TEXT DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  archived_at TIMESTAMPTZ,
  source TEXT DEFAULT 'web' -- 'web', 'telegram', 'api'
);

-- Apply updated_at trigger to ideas
DROP TRIGGER IF EXISTS ideas_updated_at ON geoffrey.ideas;
CREATE TRIGGER ideas_updated_at
  BEFORE UPDATE ON geoffrey.ideas
  FOR EACH ROW
  EXECUTE FUNCTION geoffrey.update_updated_at();

-- Enable RLS for ideas
ALTER TABLE geoffrey.ideas ENABLE ROW LEVEL SECURITY;

-- Create policy for ideas (allow all for personal board)
DROP POLICY IF EXISTS "Allow all on ideas" ON geoffrey.ideas;
CREATE POLICY "Allow all on ideas" ON geoffrey.ideas FOR ALL USING (true) WITH CHECK (true);

-- Grant permissions for ideas
GRANT ALL ON geoffrey.ideas TO anon, authenticated;

SELECT 'Ideas table created successfully! 💡' as status;
