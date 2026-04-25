🚀 Overview

This project demonstrates a production-oriented offline-first architecture in Flutter.

It supports:

📦 Local-first data access
✍️ Offline writes (add, like, delete notes)
🔄 Persistent sync queue with retries
🔐 Idempotent operations
⚔️ Conflict handling strategy

The app ensures users can interact seamlessly even without internet, while maintaining data consistency after reconnection.

🧠 Architecture & Approach
1. Local-First UX
   Notes are always fetched from Hive (local DB) first
   UI renders instantly without waiting for network
   Background sync updates data when online

✅ Result: Fast + resilient user experience

2. Offline Writes (Queue-Based)

All write actions:

Add Note
Like Note
Delete Note

Follow this flow:

Save immediately to local DB
Add action to Sync Queue
UI updates instantly

Queue is persisted in Hive → survives app restarts

🔄 Sync System Design
📦 Queue Structure

Each action contains:

id → UUID (idempotency key)
type → add / like / delete
payload → note data
retryCount
🔁 Sync Flow
Detect network restoration
Process queue sequentially
Call backend (Firebase / mock API)

On Success:

Remove item from queue

On Failure:

Retry once (with delay)
Mark as failed if retry exhausted
⏱ Retry Strategy
Retry limit: 1
Backoff: simple delay (2–5 sec)

💡 Chosen for simplicity and predictability within assignment scope

🔐 Idempotency
Each action uses a UUID
Backend ensures duplicate requests are ignored

✅ Prevents:

Duplicate notes
Repeated likes
Duplicate deletes
⚔️ Conflict Handling
Strategy: Last Write Wins (LWW)
Latest action (based on timestamp) overrides older ones

Why this approach?

Simple and predictable
Suitable for note-based apps
Avoids complex merge logic
📊 Observability (Important)

The system logs key sync events:

📦 Queue size
✅ Sync success
❌ Sync failure
🔁 Retry attempts
Example Logs
[SYNC] Queue Size: 2
[SYNC] Processing: ADD_NOTE (id: abc123)
[SYNC] Success: abc123
[SYNC] Queue Size: 1
🧪 Verification Scenarios

✅ Scenario 1: Offline Add Note
Disable internet
Add note
Restart app → note persists (Hive)
Enable internet → sync completes
✅ Scenario 2: Offline Like Note
Like a note offline
UI updates instantly
Sync happens after reconnect

🔁 Scenario 3: Retry Handling
Simulate API failure
First attempt fails
Retry succeeds

✅ Verified:

Retry triggered
No duplicate created (idempotency works)

📦 Queue Persistence
Queue remains intact after app restart
Sync resumes automatically

📦 Tech Stack
Flutter
Riverpod (state management)
Hive (local persistence)
Firebase / Mock API (backend)

⚖️ Tradeoffs
Decision	Tradeoff
Hive over SQLite	Easier setup, less relational capability
LWW conflict strategy	May overwrite concurrent updates
Single retry	Simpler but less robust

⚠️ Limitations
No exponential backoff
No batching of sync requests
Basic conflict handling
No real-time sync (only trigger-based)

🤖 AI Prompt Log
1) Prompt

"How to design offline-first sync queue in Flutter?"

Suggested queue + local DB + retry pattern
Decision: Accepted
Why: Matches real-world architecture
2) Prompt

"How to implement idempotency in offline sync?"

Suggested UUID-based idempotency
Decision: Accepted
Why: Simple and effective
3) Prompt (Iteration)

"Retry strategy for sync queue?"

Suggested exponential backoff
Decision: Modified
Why: Used single retry due to scope constraints
🧪 Verification Artifacts

Include in submission:

📸 Screenshots:
Offline add note
Queue logs
Sync success
📜 Logs:
Queue size changes
Retry attempts
🧪 (Optional):
Unit test results