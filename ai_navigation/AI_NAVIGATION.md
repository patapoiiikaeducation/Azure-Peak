# FamilyTree Module AI Navigation

Актуально для `C:/Axis/Twilight-Axis/modular_twilight_axis/familytree_module` на 2026-04-19.

Эта инструкция нужна, чтобы быстро входить в подсистему семей без широкого сканирования репозитория. Код остается источником истины: если этот файл расходится с `.dm`/`.tsx`, доверяй исходникам и обнови карту.

## Старт Работы

- Начинай с `familytree_module_config.dm`: это include-root и актуальная карта файлов модуля.
- Не открывай и не правь `.dme`; порядок загрузки не задача агента без явного апрува пользователя.
- Игнорируй `_compile_options.dm`.
- Не запускай компиляцию, debug-сценарии, внешние тестовые скрипты и in-game симуляции без явного запроса пользователя.
- Учитывай грязный worktree и не откатывай чужие изменения.
- Для поиска сначала используй точечные `rg` по `modular_twilight_axis/familytree_module`, потом расширяйся в `tgui/packages/tgui/interfaces` или `code/**`.

Быстрые команды:

```powershell
rg -n "SSfamilytree|family_datum|family_member_datum|familytree_pref|spouse_mob" modular_twilight_axis/familytree_module
rg -n "FAMILY_NEWLYWED|FAMILY_PARTIAL|desired_relative_role|setspouse|viable_spouses" modular_twilight_axis/familytree_module
rg -n "royal hand|FAMILY_OMMER|CreateBranchFamily|GetCurrentMonarch|run_royal_hand" modular_twilight_axis/familytree_module
rg -n "FamilySettingsPanel|FamilyDisplayPanel|FamilyTree" tgui/packages/tgui/interfaces tgui/packages/tgui/styles/interfaces
rg -n "silver wedding ring|/obj/item/clothing/ring/band|special_items" modular_twilight_axis/familytree_module code/modules/clothing code/datums
```

## Быстрый Роутинг

| Задача | Открывать сначала |
|---|---|
| Настройки семьи в префах | `familytree_prefs_ui.dm`, затем `FamilySettingsPanel.tsx`, `FamilySettingsPanel.scss` |
| Очередь назначения семьи | `familytree_subsystem_core.dm`, затем `familytree_subsystem_matching.dm` |
| Создание новой семьи/поиск супруга | `familytree_subsystem_matching.dm`: `find_and_confirm_newlywed()`, `FindNewlyWedMatch()`, `do_execute_newlywed()` |
| Вступление в существующую семью | `familytree_subsystem_matching.dm`, `familytree_rituals.dm`, `familytree_lifecycle.dm` |
| `setspouse`/любимое имя | `TryAssignToFavorite()`, `FindFavoriteMob()`, confirmation procs in `familytree_lifecycle.dm` |
| Королевская семья/десница | `familytree_subsystem_core.dm`, `familytree_subsystem_royal.dm`, `familytree_lifecycle.dm` |
| Социальный статус/low tier | `familytree_social.dm`, затем tooltip in `FamilySettingsPanel.tsx` |
| Дерево родства и relation text | `familytree_heritage_core.dm`, `familytree_member.dm`, `familytree_graph_support.dm`, `familytree_graph_api.dm` |
| Рендер дерева в TGUI | `FamilyDisplayPanel.tsx`, `FamilyDisplayPanel/FamilyTree.tsx`, `FamilyTreeCard.tsx`, `types.ts` |
| Кольца и stash-выдача | `familytree_subsystem_matching.dm` `give_wedding_ring()`, base item in `code/modules/clothing/rogueclothes/rings.dm` |
| Священные обряды | `familytree_holy_verbs.dm`, `familytree_rituals.dm`, `familytree_lifecycle.dm` |
| Debug-сценарии | `familytree_debug.dm`, `familytree_debug_populate.dm`; не запускать без запроса |

## Состав Модуля

- `familytree_module_config.dm` - defines, include-root, reject bitmasks, актуальный file map.
- `familytree_module_deinclude.dm` - очистка макросов после compile-секции.
- `familytree_prefs_ui.dm` - vars на prefs/human, savefile load/save/sanitize, display panel datum, backend TGUI настроек.
- `familytree_mob_procs.dm` - `MarryTo()`, player verbs, known families, UI toggles, spouse/bond display.
- `familytree_heritage_core.dm` - `/datum/heritage`: house, members, marriage, species calculation, family tree data, icons, curses.
- `familytree_member.dm` - `/datum/family_member`: graph-facing accessors, relation terms, `GetRelationshipTo()`.
- `familytree_social.dm` - estates, high/low role tiers, polygamy.
- `familytree_storytellers.dm` - storyteller influence and intimacy tracking.
- `familytree_rituals.dm` - clergy helpers, desired relative role assignment, curses/status effects.
- `familytree_holy_verbs.dm` - holy skill verbs for marriage/adoption/sibling rituals.
- `familytree_lifecycle.dm` - latejoin royal job hooks, Enigma tier integration, noble dynasty, notifications, confirmation sessions.
- `familytree_subsystem_core.dm` - `SSfamilytree`: init, signals, queue, local/royal assignment runners.
- `familytree_subsystem_helpers.dm` - compatibility, job helpers, royal status, age checks, role selection.
- `familytree_subsystem_matching.dm` - local matching, joining houses, forming new families, favorite matching, wedding rings.
- `familytree_subsystem_royal.dm` - royal partner jobs, optional royal hand family offer, royal lineage generation.
- `familytree_graph_support.dm` - graph node/edge datums, cache, validation/debug helpers.
- `familytree_graph_api.dm` - graph facade and legacy hook sync.
- `familytree_debug.dm`, `familytree_debug_populate.dm` - admin/debug tools only.
- `relations.dmi` - relation/adoption/spouse image asset.
- TGUI outside module: `FamilySettingsPanel.tsx`, `FamilyDisplayPanel.tsx`, `FamilyDisplayPanel/*.tsx`, `styles/interfaces/FamilySettingsPanel.scss`.

## Текущая Модель Режимов

В UI должны быть только три режима:

- `FAMILY_NONE` / `none` - без семьи. Обычная локальная семейная система не назначает персонажа.
- `FAMILY_NEWLYWED` / `couple` - создать семью. Игрок ищет супруга для нового дома. Он не должен быть присоединен к уже существующей семье через этот режим.
- `FAMILY_PARTIAL` / `member` - присоединиться к семье. Игрок ищет существующий дом на выбранной роли. Если выбран `RELATIVE_SPOUSE`, он может либо вступить супругом в существующий дом, либо стать супругом игрока из `FAMILY_NEWLYWED`; главой нового дома остается тот, кто выбрал создание семьи.

`FAMILY_FULL` теперь считается legacy-значением: sanitation переводит его в `FAMILY_PARTIAL`, а UI больше не должен показывать отдельную карточку "родитель".

`desired_relative_role` имеет смысл для `FAMILY_PARTIAL` и `FAMILY_NEWLYWED`. Для `FAMILY_PARTIAL` это желаемая роль вступления в дом. Для `FAMILY_NEWLYWED` это роль создателя в новом доме: например, создатель с `RELATIVE_PARENT` остается в поиске супруга, но при последующем присоединении детей/родственников система предпочитает цеплять их к нему как к родителю. Остальные режимы санитайзят роль в `RELATIVE_ANY`.

## Runtime Flow

```text
SSfamilytree.Initialize()
  -> creates ruling_family
  -> builds preset species houses and isolated houses
  -> snapshots and closes royal partner jobs
  -> checks Xylix roulette
  -> loads Enigma tier additions
  -> registers mob-created signal
  -> registers existing humans
  -> schedules holy spell scan
```

```text
try_queue_assignment(H)
  -> unsubscribe guards: dummy/npc/invalid species/banned antag/wildshape
  -> dead/no-client/already-assigned/already-scheduled/already-viable guards
  -> load prefs and copy runtime fields to H
  -> royal suitor bypasses normal family assignment
  -> royal hand:
       if monarch exists -> schedule optional royal family offer
       else -> fall back to normal family prefs
  -> other royal status -> schedule AddRoyal()
  -> FAMILY_NONE -> stop tracking
  -> other family pref -> schedule run_local_assignment()
```

`run_local_assignment()` and `run_royal_assignment()` re-check runtime block reasons before mutation. Death pauses; no client defers; hard invalid reasons unsubscribe.

## Local Matching

```text
AddLocal(H, status)
  -> runtime guards
  -> non-hand royal jobs and royal suitor are skipped
  -> setspouse path uses confirmation before mutation
  -> noble dynasty only for FAMILY_PARTIAL + RELATIVE_ANY
  -> selected relative role is honored for FAMILY_PARTIAL and stored for FAMILY_NEWLYWED
  -> FAMILY_PARTIAL:
       RELATIVE_SPOUSE -> find existing family spouse; if none, wait for FAMILY_NEWLYWED founder
       other selected role -> wait for a suitable house, solo confirmation, then AssignWithDesiredRole()
       auto role -> solo confirmation before AssignToHouse(); if no house exists, keep waiting
  -> FAMILY_NEWLYWED:
       find_and_confirm_newlywed() -> mutual confirmation -> do_execute_newlywed(); created house stays open to relatives unless the leader preference closes it
```

Important spouse matching rules:

- `FAMILY_NEWLYWED` may match another `FAMILY_NEWLYWED`.
- `FAMILY_NEWLYWED` may match `FAMILY_PARTIAL + RELATIVE_SPOUSE`.
- Two `FAMILY_PARTIAL + RELATIVE_SPOUSE` players do not create a new family by themselves.
- New-family matching rejects candidates who already have `family_datum`.
- `do_execute_newlywed()` chooses the `FAMILY_NEWLYWED` player as founder when the other side is a join-family spouse.
- `AssignToHouse()` accepts a forced role (`"child"`, `"parent"`, `"sibling"`) for selected relative roles. Forced-role house selection skips the broad age-conflict filter and checks the actual target relationship instead.
- `pick_weighted_house()` prefers smaller/open houses for forced relative roles, so a newly created random pair can collect join-family relatives before large houses absorb everyone.

`TryAssignToFavorite()` must not directly mutate marriage/family state. For spouse/family paths it routes through mutual or solo confirmation. In `FAMILY_NEWLYWED`, a favorite who already belongs to a family is not joined; the seeker waits instead.

## Confirmation System

Solo confirmation:

```text
request_family_confirmation(H, callback, type)
  -> no client: callback immediately
  -> client: tgui_alert, timeout counts as no
  -> accept: callback
  -> reject/timeout: familytree_opted_out + unsubscribe
```

Mutual confirmation:

```text
request_mutual_confirmation(A, B, callback, type)
  -> no clients: callback immediately
  -> one client: solo confirmation on client side
  -> two clients: /datum/family_confirm_session
  -> both accept: callback
  -> reject/timeout: refuser opts out; other side is rescheduled if still eligible
```

Use `confirm_type = "spouse"` for pair creation text, and `"family"`/`"house"` for family joining text.

## Royal Assignment

Royal status is job-based:

- `/datum/job/roguetown/lord` and `/datum/job/roguetown/lady` -> parent/monarch branch.
- `/datum/job/roguetown/prince` -> child of current monarch.
- `/datum/job/roguetown/hand` -> optional royal hand branch.
- `/datum/job/roguetown/suitor` bypasses normal assignment.

Royal hand behavior:

- If no current monarch exists, the hand falls back to normal family prefs.
- If a monarch exists, the hand gets a TGUI question about joining the ducal family.
- Accepting calls `AddRoyal(H, FAMILY_OMMER)`.
- Declining falls back to normal local prefs; if prefs are `FAMILY_NONE`, tracking stops.
- `CreateBranchFamily()` no longer creates a dummy/random spouse for the hand.

Royal partner jobs are still controlled by the monarch's family prefs through `refresh_royal_partner_jobs()`, `get_royal_partner_mode_from_preferences()`, and latejoin `royal_partner_candidate_allowed()`.

## Family Graph And Display

Use helper procs instead of direct list edits:

```text
/datum/heritage.CreateFamilyMember(person)
/datum/heritage.RemovePersonFromFamily(person)
/datum/heritage.AddToFamily(person, parent1, parent2, adopt)
/datum/heritage.MarryMembers(member1, member2)
/datum/family_member.AddParent(parent)
/datum/family_member.RemoveParent(parent)
/datum/family_member.AddSpouse(spouse)
/datum/family_member.RemoveSpouse(spouse, divorce)
```

The graph layer mirrors legacy family members:

- `graph_on_member_created()` creates/reuses `/datum/family_node`.
- `graph_on_parent_added()` and `graph_on_spouse_added()` create edges.
- `graph_sync_adoption_status()` retypes biological/adoptive edges.
- `get_display_tree_for()` caches `BuildFamilyTreeRoots(checker)`.

Family tree rendering lives in `FamilyDisplayPanel/FamilyTree.tsx`. It computes a simple node/edge layout, fits to viewport, supports pan/zoom, and uses `ResizeObserver` to refit when the panel size changes.

## Species And Child Assignment

`SpeciesCalculation()` covers same species, tieberian, northern human, elf/halfelf, orc/halforc. `SingleParentSpeciesCalculation()` is used for one-parent compatibility.

Auto role selection in `DetermineAppropriateRole()` should only choose `"child"` when at least one compatible parent exists through `SingleParentSpeciesCalculation()`. Forced child assignment may still create adoption if the species pair is incompatible.

## Social Status

Central filters:

```text
familytree_estates_compatible(A, B)
familytree_get_role_tier(H)
familytree_role_tiers_compatible(A, B)
```

Low tier currently includes wretch, bandit, assassin, lunatic, vagabond, bathworker, plus title fallbacks such as Beggar, Excommunicado, Thug, and Doomsayer. The UI checkbox tooltip in `FamilySettingsPanel.tsx` must describe this in player-facing language.

## Wedding Ring

Family-created marriage grants `/obj/item/clothing/ring/band`, named `silver wedding ring`.

`give_wedding_ring()` should add it to `H.mind.special_items["Silver wedding ring"]` instead of equipping it to `SLOT_RING`. Only no-mind fallback may spawn the item at the turf.

## Known Risk Points

- `desired_relative_role` is intentional in `FAMILY_NEWLYWED`; do not reset it there. It must still be reset outside `FAMILY_PARTIAL`/`FAMILY_NEWLYWED`, and create-family matching must keep `FAMILY_NEWLYWED` players in the new-house spouse flow instead of joining existing houses through that preference.
- `setspouse` is player-directed and can bypass broad matching if handled carelessly. Keep confirmations before any mutation.
- `ruling_family` is separate from `families`; normal family scans can miss royal members unless explicitly checking `ruling_family`.
- `spouse_mob` is a legacy single pointer. Use `family_member_datum.get_spouse_members()` for complete spouse lists.
- `RemoveSpouse()` clears legacy pointers only for the removed pair. Check callers that dissolve marriage.
- New normal houses should be registered with `SSfamilytree.register_family()`.
- Debug files spawn mobs and mutate subsystem state. Do not run without explicit request.

## Minimal Search Before Editing

Before editing a family behavior, run only the route-specific search:

```powershell
rg -n "FunctionName|RelatedVar|RelatedConstant" modular_twilight_axis/familytree_module
```

Expand only if needed:

```powershell
rg -n "familytree_module_open_preferences|FamilySettingsPanel|FamilyDisplayPanel" code/modules/client/preferences.dm tgui/packages/tgui/interfaces tgui/packages/tgui/styles/interfaces modular_twilight_axis/familytree_module
rg -n "special_check_latejoin|GetJob|assigned_role|display_title|f_title" code/modules/jobs code/modules/mob modular_twilight_axis/familytree_module
```

Avoid full-tree scans unless the module route proves insufficient.
