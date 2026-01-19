/obj/item/bodypart/proc/bodypart_attacked_by(bclass = BCLASS_BLUNT, dam, mob/living/user, zone_precise = src.body_zone, silent = FALSE, crit_message = FALSE, armor, obj/item/weapon)
	var/datum/wound/dynwound = ..()
	if(HAS_TRAIT(owner, TRAIT_DAWNWALKER) && istype(weapon) && weapon?.is_silver)
		owner.apply_status_effect(/datum/status_effect/debuff/dawnwalker_silver)
	return dynwound
