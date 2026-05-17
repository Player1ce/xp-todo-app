I’ll map every quest mutation path (create, complete toggle, edit, transfer, delete) to see whether each path recomputes game aggregates, then I can quantify actual self-heal coverage and what’s missing.

Searched for multiple regex patterns in Dart files
I’ve located the key mutation callsites; next I’m reading those flows to see whether each one triggers a cache recompute for one or both games after success.

Reviewed 4 files
I can already see strong recompute coverage for completion and transfer; I’m now checking delete/create quest paths specifically, since those are the common remaining drift points.

Searched for regex patterns and reviewed 2 files
I found a likely gap around create/delete, so I’m doing a targeted search for actual delete quest callsites and any background reconciliation trigger to confirm whether drift is eventually corrected automatically.

Searched for multiple regex patterns and reviewed game_detail_page.dart
Short answer: the app has partial self-healing, but not complete self-healing yet. I recommend implementing at least one more reconciliation path.

Current self-heal capacity

Strong for completion toggles in list/detail flows.
Quest list flow toggles completion then recomputes and writes full game cache in quest_list_panel.dart:240 and quest_list_panel.dart:270.
Game detail flow does the same in game_detail_page.dart:323 and game_detail_page.dart:353.
Repository-level completion update is transactional and adjusts completed count in quest_repository.dart:126.
Strong for transfer flow.
Transfer recomputes both source and target game caches in quest_preview_dialog.dart:383 and quest_preview_dialog.dart:384.
Moderate for quest preview edits.
Preview uses full refresh on some updates (for example completion and xp paths) via quest_preview_dialog.dart:309 and quest_preview_dialog.dart:326.
Weak/missing for create/delete lifecycle consistency.
Create quest currently writes the quest and closes dialog in quest_creation_dialog.dart:88 with no explicit cache recompute afterward.
Delete quest exists in repository/notifier (quest_providers.dart:229) but there is no visible UI call path that recomputes cache afterward.
Do errors/edge cases still risk accumulation?
Yes, possible. Today’s design can self-correct when users pass through the flows above, but there is no universal always-on reconciler. So drift can persist until one of those recompute paths runs.

Performance of current approach

Completion transaction path: good.
Small constant-cost transaction (few docs), suitable for normal app scale.
Full recompute path: acceptable for small-to-medium quest counts, but O(n) per refresh.
Each refresh reads all quests in a game and folds totals (see quest_preview_dialog.dart:326).
Fine at current scale; can become chatty if toggles are frequent and quest lists are large.
Do you need to implement anything?
Yes, I would implement one required item and one optional hardening item.

Required: recompute game cache immediately after quest creation and after any delete flow.
This closes the largest current integrity gap.
Optional but recommended: add a centralized reconciliation trigger (for example on game open, pull-to-refresh, or backend job) that recalculates game aggregates from quests and overwrites cache fields.
This gives eventual consistency even if future edge cases slip into mutation code.
If you want, I can map the exact lowest-risk insertion points for create/delete recompute in your current widgets/providers next.
