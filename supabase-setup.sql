-- Geoffrey's Task Board Schema Setup
-- Run this in your Supabase SQL Editor (SQL → New Query → paste → Run)

-- Create dedicated schema
CREATE SCHEMA IF NOT EXISTS geoffrey;

-- Tasks table
CREATE TABLE geoffrey.tasks (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  category TEXT DEFAULT 'work' CHECK (category IN ('work', 'hustle', 'personal', 'urgent')),
  priority TEXT DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high')),
  status TEXT DEFAULT 'todo' CHECK (status IN ('todo', 'in-progress', 'done')),
  due_date TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  source TEXT DEFAULT 'web' -- 'web', 'telegram', 'api'
);

-- Activity log for tracking changes
CREATE TABLE geoffrey.activity_log (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  task_id UUID REFERENCES geoffrey.tasks(id) ON DELETE CASCADE,
  action TEXT NOT NULL, -- 'created', 'updated', 'moved', 'completed', 'deleted'
  old_value JSONB,
  new_value JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User preferences/settings
CREATE TABLE geoffrey.settings (
  key TEXT PRIMARY KEY,
  value JSONB NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert default settings
INSERT INTO geoffrey.settings (key, value) VALUES
  ('streak', '{"current": 0, "last_completion_date": null}'::jsonb),
  ('preferences', '{"theme": "dark", "notifications": true}'::jsonb);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION geoffrey.update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply trigger to tasks
CREATE TRIGGER tasks_updated_at
  BEFORE UPDATE ON geoffrey.tasks
  FOR EACH ROW
  EXECUTE FUNCTION geoffrey.update_updated_at();

-- Enable RLS (Row Level Security)
ALTER TABLE geoffrey.tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE geoffrey.activity_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE geoffrey.settings ENABLE ROW LEVEL SECURITY;

-- Create policies (allow all for anon since this is a personal board)
-- In production, you'd scope these to authenticated users
CREATE POLICY "Allow all on tasks" ON geoffrey.tasks FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all on activity_log" ON geoffrey.activity_log FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all on settings" ON geoffrey.settings FOR ALL USING (true) WITH CHECK (true);

-- Expose schema to PostgREST (Supabase API)
GRANT USAGE ON SCHEMA geoffrey TO anon, authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA geoffrey TO anon, authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA geoffrey TO anon, authenticated;

-- Add to exposed schemas (required for API access)
-- Note: You may need to add 'geoffrey' to your API exposed schemas in Supabase Dashboard
-- Settings → API → Exposed schemas → Add 'geoffrey'

-- Ideas table (Idea Pipeline)
CREATE TABLE geoffrey.ideas (
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

-- Apply trigger to ideas
CREATE TRIGGER ideas_updated_at
  BEFORE UPDATE ON geoffrey.ideas
  FOR EACH ROW
  EXECUTE FUNCTION geoffrey.update_updated_at();

-- Enable RLS for ideas
ALTER TABLE geoffrey.ideas ENABLE ROW LEVEL SECURITY;

-- Create policy for ideas
CREATE POLICY "Allow all on ideas" ON geoffrey.ideas FOR ALL USING (true) WITH CHECK (true);

-- Grant permissions for ideas
GRANT ALL ON geoffrey.ideas TO anon, authenticated;

-- Success message
SELECT 'Geoffrey schema created successfully! 🎩' as status;
