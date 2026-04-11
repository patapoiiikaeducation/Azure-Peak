# Entrypoints

Generated for Azure-Peak. Use this file before the larger maps when the goal can be matched to a known system quickly.

## Minimal Route

1. Match the task to one row below.
2. Open only the listed directories/files first.
3. Escalate only if needed:
   - symptom-first debugging -> `ai_navigation/debug_routes.md`
   - handoff between systems unclear -> `ai_navigation/system_dependencies.md`
   - execution order/lifecycle unclear -> `ai_navigation/runtime_flow.md`
   - ownership unclear -> `ai_navigation/subsystem_map.md`
   - system unclear -> `ai_navigation/system_map.md`
   - branch/root unclear for a type path -> `ai_navigation/type_index.md`
   - deep inheritance unclear -> `ai_navigation/type_tree.md`
   - architecture/layer question -> `ai_navigation/architecture.md`

## Fast Index

| Task or keyword | Open first | Then check | Runtime owner |
|---|---|---|---|
| `vampire`, `werewolf`, `antag`, `thrall`, `villain` | `code/modules/antagonists/**` | `code/modules/events/antagonist/**`, `code/datums/storytellers/**`, `code/datums/migrants/**` | `SSgamemode`, `SSevents`, `SSticker` |
| `job`, `role`, `latejoin`, `spawn role`, `migrant`, `class` | `code/modules/jobs/**`, `code/datums/migrants/**` | `modular/code/modules/jobs/**`, `code/modules/mob/**` | `SSjob`, `SSmigrants`, `SSrole_class_handler` |
| `spell`, `ability`, `action`, `miracle`, `rituos`, `projectile`, `aoe`, `cone`, `touch` | `code/modules/spells/**`, `ai_navigation/spell_signal_map.md` | `code/datums/actions/**`, `code/datums/status_effects/**`, `code/datums/components/**`, `code/datums/elements/**` | `SSskills`, `SSmood`, direct action/spell code; `[DEPRECATED/NOT FOUND: SSmagic]`, `[DEPRECATED/NOT FOUND: SSstatusprocess]` |
| `combat`, `melee`, `attack`, `hit`, `weapon`, `disarm`, `parry`, `block`, `shield`, `projectile` | `ai_navigation/combat_signal_map.md`, `code/_onclick/item_attack.dm` | `code/_onclick/other_mobs.dm`, `code/modules/mob/living/combat/**`, `code/modules/projectiles/projectile.dm`, defense/species files | `SSdcs`, mob/projectile paths, AI combat listeners |
| `sex`, `lewd`, `arousal`, `erp`, `kink` | `code/datums/sexcon2/**`, `code/modules/sexcon/**`, `code/modules/sexcon/components/arousal.dm` | `modular/code/controllers/subsystem/processing/sex.dm`, `modular/code/game/objects/items/lewd/**`, `code/modules/mob/**`, `ai_navigation/signal_map.md`; `[DEPRECATED/NOT FOUND: code/datums/sex/**]` | `SSsex`, `SSdcs`, mob/chat paths |
| `ai`, `npc`, `behavior`, `controller`, `hostile mob` | `code/datums/ai/**`, `code/modules/mob/**` | `code/controllers/subsystem/ai_controller.dm`, `code/controllers/subsystem/processing/ai_behaviours.dm`, `code/controllers/subsystem/processing/ai_movement.dm` | `SSai_controllers`, `SSai_behaviors`, `SSai_movement` |
| `movement`, `move`, `collision`, `pull`, `buckle`, `throw`, `glide`, `moveloop`, `pathing` | `ai_navigation/movement_signal_map.md`, `code/modules/mob/mob_movement.dm`, `code/game/atoms_movable.dm` | `code/modules/mob/living/living_movement.dm`, `code/game/objects/buckling.dm`, `code/controllers/subsystem/movement/**` | `SSmovement`, `SSmove_manager`, `SSthrowing`, `SSdcs` |
| `quest`, `questing`, `contract`, `bounty`, `courier`, `retrieval`, `scroll`, `compass`, `quest_object`, `contractledger` | `code/modules/roguetown/roguemachine/questing/**` | `code/modules/roguetown/roguemachine/questing/contract_ledger.dm`, `code/modules/roguetown/roguemachine/questing/questing_components.dm`, `code/modules/roguetown/roguemachine/questing/types/**`, `code/modules/roguetown/roguemachine/questing/items/**`, `code/__DEFINES/questing.dm`; `[DEPRECATED/NOT FOUND: code/modules/questing/**]`, `[DEPRECATED/NOT FOUND: tgui/packages/tgui/interfaces/ContractLedger.tsx]` | `SSdcs`, `SSroguemachine`, player/ledger flow |
| `quest map config`, `quest difficulty`, `quest reward modifier`, `quest distance bonus` | `code/__DEFINES/questing.dm`, `code/modules/roguetown/roguemachine/questing/**` | `modular/ambush/ambush_config/**`, `code/controllers/subsystem/rogue/regional_threat/**`; `[DEPRECATED/NOT FOUND: code/modules/questing/quest_map_config.dm]` | no dedicated SS; quest generation/ledger flow |
| `quest ambush`, `ambush payload`, `ambush_config`, `regional threat`, `signal horn` | `modular/ambush/ambush_config/**`, `code/controllers/subsystem/rogue/regional_threat/**` | `code/game/objects/structures/roguetown/rogueflora.dm`, `code/game/objects/items/signal_horn.dm`, `code/__DEFINES/questing.dm`; `[DEPRECATED/NOT FOUND: code/modules/ambush/**]` | `SSregionthreat`, direct component/proc flow |
| `map`, `dungeon`, `worldgen`, `template`, `spawn landmark` | `_maps/**`, `code/modules/mapping/**`, `code/modules/procedural_mapping/**` | `code/controllers/subsystem/mapping.dm`, `minor_mapping.dm`, `dungeon_generator.dm`, `code/controllers/subsystem/processing/mapgen.dm`, `modular/Mapping/**` | `SSmapping`, `SSminor_mapping`, `SSdungeon_generator`, `SSmapgen`, `SSpathfinder`; `[DEPRECATED/NOT FOUND: SSterrain_generation]` |
| `economy`, `merchant`, `treasury`, `property`, `housing`, `faction` | `code/modules/economy/**`, `code/controllers/subsystem/economy.dm`, `code/controllers/subsystem/rogue/treasury.dm` | `code/datums/world_factions/**`, `code/controllers/subsystem/merchant.dm`; `[DEPRECATED/NOT FOUND: code/controllers/subsystem/property_management.dm]` | `SSeconomy`, `SStreasury`, `SSmerchant`; `[DEPRECATED/NOT FOUND: SShousing]` |
| `craft`, `recipe`, `material`, `runeword`, `anvil`, `fishing`, `farming` | `code/modules/crafting/**`, `code/modules/farming/**`, `modular/code/modules/crafting/**` | `code/modules/roguetown/roguejobs/fisher/**`, `modular/Neu_Farming/**`, `code/datums/brewing_recipes/**`; `[DEPRECATED/NOT FOUND: code/datums/materials/**]`, `[DEPRECATED/NOT FOUND: code/datums/runeword/**]` | `SSskills`, `SSfarming`; `[DEPRECATED/NOT FOUND: SSanvil]`, `[DEPRECATED/NOT FOUND: SSfishing]`, `[DEPRECATED/NOT FOUND: SSenchantment]` |
| `faith`, `god`, `patron`, `mana`, `quirk`, `wound`, `stress`, `mood` | `code/datums/gods/**`, `code/datums/stress/**`, `code/datums/wounds/**`, `code/datums/status_effects/**` | `code/datums/special_traits/**`, `code/datums/usurpation_rite/**`; `[DEPRECATED/NOT FOUND: code/datums/faith/**]`, `[DEPRECATED/NOT FOUND: code/datums/mana/**]`, `[DEPRECATED/NOT FOUND: code/datums/quirks/**]` | `SSskills`, `SSmood`, direct datums |
| `skill`, `skill level`, `dream`, `xp`, `experience`, `skill_holder` | `code/datums/skills/**`, `code/datums/skill_holder.dm` | `code/modules/jobs/**`, `modular/code/modules/jobs/**` for spawn grants | `SSskills` |
| `special_intent`, `aoe intent`, `clash`, `riposte`, `guard`, `stamina cost` | `code/modules/mob/living/combat/**` | `code/modules/mob/living/combat/special_intents.dm`, `code/modules/mob/living/combat/azure_combat.dm`, `ai_navigation/combat_signal_map.md`; `[DEPRECATED/NOT FOUND: code/modules/combat/**]` | `SSdcs`, combat chain |
| `culture`, `character background`, `species culture`, `on_after_spawn` | `[DEPRECATED/NOT FOUND: code/datums/culture/**]` | Use `code/datums/mob_descriptors/**`, `code/datums/special_traits/**`, species/job spawn code depending on actual feature. | no dedicated SS |
| `cooking`, `food`, `recipe`, `raw food`, `NeuFood`, `brew`, `tea` | `modular/Neu_Food/code/**`, `code/modules/food_and_drinks/**` | `modular/Neu_Food/code/NeuFood.dm`, `modular/Neu_Food/code/cooked/**`, `modular/Neu_Food/code/raw/**`, `modular/Neu_Food/code/recipes/**`, `code/modules/reagents/**` | `SSskills`, direct crafting/reagent paths |
| `rage`, `rage meter`, `rage tier`, `bloodpool`, `werewolf rage` | `[DEPRECATED/NOT FOUND: code/datums/rage/**]` | Check `code/modules/antagonists/roguetown/villain/werewolf/**`, `code/modules/vampire_neu/**`, status effects, and `ai_navigation/signal_map.md`. | no dedicated SS found |
| `greyscale`, `GAGS`, `recolor`, `greyscale_config`, `greyscale_colors`, `sprite layers` | `[DEPRECATED/NOT FOUND: code/datums/greyscale/**]`, `ai_navigation/visuals_guide.md` | Use icon/appearance code directly; `[DEPRECATED/NOT FOUND: SSgreyscale]` is not present in Azure-Peak. | `[DEPRECATED/NOT FOUND: SSgreyscale]` |
| `icon smoothing`, `smooth_icon`, `smoothing_flags`, `smoothing_groups`, `SMOOTH_BITMASK`, `bitmask wall`, `tile junction` | `ai_navigation/icon_rendering.md`, `code/__HELPERS/icon_smoothing.dm` | `code/controllers/subsystem/icon_smooth.dm`; `[DEPRECATED/NOT FOUND: code/__DEFINES/icon_smoothing.dm]` | `SSicon_smooth` |
| `iconstate2appearance`, `icon2appearance`, `appearance cache`, `vis_contents cache` | `ai_navigation/icon_rendering.md`, `code/controllers/subsystem/overlays.dm` | `code/controllers/subsystem/vis_overlays.dm`, `code/__DEFINES/layers.dm` | `SSoverlays`, `SSvis_overlays`, `SSdamoverlays` |
| `liquid`, `fluid`, `weather`, `fire`, `overlay`, `lighting` | `code/controllers/subsystem/processing/fluids.dm`, `code/datums/particle_weathers/**`, `code/datums/weather/**`, `ai_navigation/visuals_guide.md` | `code/controllers/subsystem/weather.dm`, `particle_weather.dm`, `particle_weather_outdoors.dm`, fire/overlay subsystems | `SSfluids`, `SSParticleWeather`, `SSoutdoor_effects`, `SSweather`, `SSfire_burning`, `SSfire_spread`, `SSlighting`; `[DEPRECATED/NOT FOUND: SSliquids]` |
| `tgui`, `ui`, `browser`, `hud`, `interface` | `code/modules/tgui/**`, `code/modules/tgui_input/**`, `code/modules/tgui_panel/**`, `interface/**` | `tgui/packages/**`, `html/**`; `[DEPRECATED/NOT FOUND: code/modules/visual_ui/**]` | `SStgui`, `SSchat`, `SSstatpanel`; `[DEPRECATED/NOT FOUND: SSvisual_ui]` |
| `lag`, `runtime`, `processing`, `tick`, `scheduler`, `master`, `startup` | `ai_navigation/subsystem_map.md`, `code/world.dm`, `code/controllers/master.dm`, `code/controllers/subsystem.dm` | `code/controllers/subsystem/**`, `rg` for the relevant `SS*` | `Master`, target `SS*` |
| exact BYOND type path like `/datum/...`, `/mob/...`, `/obj/...` | `ai_navigation/type_index.md` | matching DM branch in `code/**` and `modular/**`, then `ai_navigation/type_tree.md` if needed | depends on branch |

## Escalation Rules

- If a keyword row matches, do not open `ai_navigation/system_map.md` immediately.
- If the user gives a symptom instead of a feature name, switch to `ai_navigation/debug_routes.md`.
- If the first branch is wrong, switch rows once before doing a broad repository search.
- After locating a core path in `code/`, always check whether `modular` extends the same branch.
