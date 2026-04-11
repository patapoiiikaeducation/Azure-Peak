# Azure Modular Guide

`modular/` is a late-included overlay and content-pack layer for Azure-Peak. `[DEPRECATED/NOT FOUND: modular_rmh/]` is not present here.

## What Late-Included Means

`modular/` is included by `roguetown.dme` after most core `code/**` includes. This means:

- it can add descendants under existing core type paths;
- it can override behavior when a late file defines the same proc path;
- it cannot change the master controller architecture by being in a separate tree;
- core singletons (`SS*`, `Master`) are owned by the core subsystem framework unless a modular file explicitly declares an additional subsystem.

**Agent rule:** locate the core type first in `code/`, then search `modular/` for descendants, overrides, or content that hooks into the same subsystem.

## Directory Map

| Path | What lives here |
|---|---|
| `modular/ambush/**` | Ambush config datums. |
| `modular/code/controllers/configuration/**` | Modular config entries. |
| `modular/code/controllers/subsystem/processing/sex.dm` | `SSsex` processing subsystem. |
| `modular/code/game/objects/**` | Modular objects and items, including lewd/tent/pillory/gallows content. |
| `modular/code/modules/admin/**` | Admin additions. |
| `modular/code/modules/crafting/**` | Modular crafting additions. |
| `modular/code/modules/jobs/**` | Job/role extensions. |
| `modular/code/modules/living/**` | Living speech/emote hooks. |
| `modular/code/modules/maturity-prompt/**` | Maturity prompt code and `SSmaturity_guard`. |
| `modular/Creechers/**` | Creature/content pack. |
| `modular/icons/**` | Modular icon assets. |
| `modular/Mapping/**` | Modular mapping content. |
| `modular/Neu_Farming/**` | Farming content. |
| `modular/Neu_Food/code/**` | Food, cookware, raw/cooked food, drinks, and recipes. |
| `modular/piercing/**` | Piercing content. |
| `modular/ze_genesis_call/**` | Genesis call content. |

## Imported Paths Not Present

| Imported path | Status |
|---|---|
| `modular_rmh/**` | `[DEPRECATED/NOT FOUND]`; use `modular/**` only after verifying an equivalent path exists. |
| `modular/code/datums/**` | `[DEPRECATED/NOT FOUND]` in current tree. Datums mostly live in core `code/datums/**`. |
| `modular/code/modules/spells/**` | `[DEPRECATED/NOT FOUND]` in current tree. Use `code/modules/spells/**`. |
| `modular/code/modules/mob/**` | `[DEPRECATED/NOT FOUND]` in current tree. Use `code/modules/mob/**`, plus `modular/code/modules/living/**` for speech/emote hooks. |
| `modular/code/modules/clothing/**` | `[DEPRECATED/NOT FOUND]` in current tree. Use `code/modules/clothing/**`. |
| `modular/code/modules/mapping/**` | `[DEPRECATED/NOT FOUND]` in current tree. Use `modular/Mapping/**` and core mapping paths. |
| `modular/code/modules/client/**` | `[DEPRECATED/NOT FOUND]` in current tree. Use core `code/modules/client/**`. |
| `modular/fluids/**`, `modular/comfy/**`, `modular/ceramics/**`, `modular/loot/**`, `modular/bush/**`, `modular/helpers/**`, `modular/resurrection_rune/**`, `modular/selectable_moanpacks/**` | `[DEPRECATED/NOT FOUND]` in current tree. |

## Where New Code Belongs

| Adding... | Put it in |
|---|---|
| New core gameplay behavior | Prefer the owning core path under `code/**`. |
| New modular job extension | `modular/code/modules/jobs/**` if it is genuinely modular; otherwise `code/modules/jobs/**`. |
| New modular crafting addition | `modular/code/modules/crafting/**` or core `code/modules/crafting/**` depending on ownership. |
| New food/cooking item | `modular/Neu_Food/code/**` or `code/modules/food_and_drinks/**`. |
| New ambush config | `modular/ambush/ambush_config/**` or the owning core ambush/threat path if it is not modular content. |
| New modular object/item | `modular/code/game/objects/**`. |
| New subsystem | Avoid unless explicitly approved; add it in the owner layer and update `ai_navigation/subsystem_map.md`. |

## Key Rules

- Do not assume old `[DEPRECATED/NOT FOUND: modular_rmh/**]` paths exist. Verify with `rg` or `Test-Path`.
- Do not blindly map `[DEPRECATED/NOT FOUND: modular_rmh/modular/code/...]` to `modular/code/...`; most of those branches do not exist here.
- For overlays/appearance changes, read `ai_navigation/performance_gotchas.md` first; per-tick `overlays +=` changes are expensive.
- After locating a core path, search `modular/` for the same type branch before editing behavior that may be extended late.
