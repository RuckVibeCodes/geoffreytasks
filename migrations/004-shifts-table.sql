-- Night Shifts log: stores Geoffrey's autonomous build sessions
-- Each session is a card in Mission Control's "Night Shifts" tab

CREATE TABLE IF NOT EXISTS geoffrey.shifts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  shift_date DATE NOT NULL,
  summary TEXT NOT NULL,                    -- One-line headline for the shift card
  status TEXT DEFAULT 'done'
    CHECK (status IN ('done', 'pr', 'wip')),
  items JSONB DEFAULT '[]',                 -- Array of {icon, text, meta} objects
  repos TEXT[] DEFAULT '{}',               -- Repos touched this session
  pr_count INT DEFAULT 0,
  tasks_completed INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- RLS: anon can read, service role can write
ALTER TABLE geoffrey.shifts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "shifts_read_all" ON geoffrey.shifts FOR SELECT USING (true);

-- Index for ordering
CREATE INDEX IF NOT EXISTS shifts_date_idx ON geoffrey.shifts (shift_date DESC);

-- Seed with recent sessions so the board has real data immediately
INSERT INTO geoffrey.shifts (shift_date, summary, status, pr_count, tasks_completed, repos, items) VALUES
(
  '2026-02-24',
  'Mission Control v3 + TouchGrass landing page fixes',
  'pr',
  6,
  2,
  ARRAY['geoffreytasks', 'touchgrass-indicator'],
  '[
    {"icon":"✅","text":"TouchGrass landing: fixed dead buy button, removed use-client SSR, FAQ accordion, mobile nav, live stats bar","meta":"PR #1, #2 · touchgrass-indicator"},
    {"icon":"✅","text":"Mission Control: drag-to-move columns, expanded card modal with notes, realtime WebSocket","meta":"PR #7 · geoffreytasks"},
    {"icon":"✅","text":"Mission Control: 5-col kanban, Insights tabs, agent badges, live agent status, Debugger in pipeline","meta":"PR #6, #14 · geoffreytasks"},
    {"icon":"✅","text":"Mission Control: ops feed, dynamic agent cards, Night Shifts tab, pipeline bar","meta":"PR #12 · geoffreytasks"},
    {"icon":"🐛","text":"Fixed loading freeze: JS escape corruption + no fetch timeout","meta":"PR #8, #9 · geoffreytasks"},
    {"icon":"🐛","text":"Fixed Clear Completed no-op: wrong table name in delete call","meta":"PR #13 · geoffreytasks"}
  ]'::jsonb
),
(
  '2026-02-21',
  'IRL Capital Academy Module 2 + TouchGrass signal fixes',
  'done',
  2,
  3,
  ARRAY['touchgrass', 'irl-capital-academy'],
  '[
    {"icon":"✅","text":"IRL Capital Academy Module 2: 5 video scripts covering FICO breakdown, AZEO method, dispute letters, 90-day sprint","meta":"~/clawd/projects/irl-capital-academy/MODULE_2_SCRIPTS.md"},
    {"icon":"✅","text":"TouchGrass: stats caching fix — daily briefing track record showing stale data resolved","meta":"merged · touchgrass"},
    {"icon":"✅","text":"TouchGrass: signal cooldown fix — 60-min minimum between open signal replacements","meta":"merged · touchgrass"}
  ]'::jsonb
),
(
  '2026-02-19',
  'IRL Capital Academy Module 1 + RentCoin site',
  'done',
  1,
  2,
  ARRAY['irl-capital-academy', 'rentcoin'],
  '[
    {"icon":"✅","text":"IRL Capital Academy: full course framework, bank list (25 cards), Module 1 scripts, sales page copy","meta":"~/clawd/projects/irl-capital-academy/"},
    {"icon":"✅","text":"RentCoin website deployed with favicons, OG tags, Twitter cards, SEO","meta":"rentcoin.cash"},
    {"icon":"📋","text":"Research: Motus Investment Group competitor analysis, business credit stacking market sizing","meta":"Research doc"}
  ]'::jsonb
),
(
  '2026-02-17',
  'IRL Capital Atlanta positioning + FB ad copy',
  'done',
  1,
  2,
  ARRAY['irl-capital'],
  '[
    {"icon":"✅","text":"IRL Capital landing: Atlanta badge, updated hero copy, trust bullets","meta":"PR #1 · irl-capital"},
    {"icon":"✅","text":"5 FB ad copy sets ready for $20-30/day test campaign","meta":"~/irl-capital/FB_AD_COPY.md"},
    {"icon":"✅","text":"Timeslot: friendly 404 page + dashboard loading skeleton","meta":"PR · timeslot"}
  ]'::jsonb
);
