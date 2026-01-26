-- Migration 002: Things 3-Inspired Features
-- Run this in Supabase SQL Editor: SQL → New Query → Paste → Run

-- 1. Add scheduled_date column for "Today" view
ALTER TABLE geoffrey.tasks ADD COLUMN IF NOT EXISTS scheduled_date DATE;

-- 2. Add subtasks JSONB column for checklists
ALTER TABLE geoffrey.tasks ADD COLUMN IF NOT EXISTS subtasks JSONB DEFAULT '[]'::jsonb;

-- 3. Update status constraint to allow 'someday'
ALTER TABLE geoffrey.tasks DROP CONSTRAINT IF EXISTS tasks_status_check;
ALTER TABLE geoffrey.tasks ADD CONSTRAINT tasks_status_check
  CHECK (status IN ('todo', 'in-progress', 'done', 'someday'));

-- Create index on scheduled_date for fast Today view queries
CREATE INDEX IF NOT EXISTS idx_tasks_scheduled_date ON geoffrey.tasks (scheduled_date);

-- Create index on project for project view queries
CREATE INDEX IF NOT EXISTS idx_tasks_project ON geoffrey.tasks (project);

SELECT 'Things 3 features migration complete! 🎩' as status;
