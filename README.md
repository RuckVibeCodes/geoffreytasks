# 🎩 Geoffrey's Task Board

> *"A task delayed is a task that haunts one's afternoon tea."* — Geoffrey

⚡ **TL;DR:** Open index.html or visit geoffrey-task-board.vercel.app → add tasks → drag to done

---

Butler-themed task management for Master Matt. Built with Claude Code.

## Features

- **Kanban Board** — Todo, In Progress, Done columns with drag & drop
- **Categories** — Work, Side Hustle, Personal, Urgent
- **Priority Levels** — Low, Medium, High with visual indicators
- **Due Dates** — With overdue and "due soon" warnings
- **Day Streak** — Track your productivity momentum
- **Celebration System** — Confetti and snarky congratulations on completion
- **Keyboard Shortcuts** — `N` for new task, `R` for refresh, `?` for help
- **Offline Support** — Works offline with localStorage backup
- **PWA Ready** — Install on mobile as an app

## Tech Stack

- Vanilla HTML/CSS/JS (no frameworks, just vibes)
- Supabase for backend persistence
- Vercel for hosting

## Telegram Integration

Add tasks via Telegram by messaging Geoffrey:
- "Add task: Review landing page copy"
- "Geoffrey, remind me to ship the feature"

## 🚀 Quick Start

```bash
# Just open index.html in browser
# Or deploy to Vercel (drag & drop or git)
```

## Database Setup

Run `supabase-setup.sql` in your Supabase SQL Editor to create the `geoffrey` schema.

Then add `geoffrey` to your API exposed schemas:
Settings → API → Exposed schemas → Add `geoffrey`

---

*Crafted with reluctant excellence by Geoffrey 🎩*
