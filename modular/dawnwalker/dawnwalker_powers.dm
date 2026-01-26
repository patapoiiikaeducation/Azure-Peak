/datum/coven/dawnwalker_bloodheal
	name = "Dawnwalker Bloodheal"
	desc = "Bloodbound mending."
	icon_state = "bloodheal"
	power_type = /datum/coven_power/dawnwalker_bloodheal
	max_level = 1
	clan_restricted = FALSE
	all_powers = list(/datum/coven_power/dawnwalker_bloodheal)

/datum/coven/dawnwalker_fear
	name = "Dawnwalker Rage"
	desc = "A surge of dread and speed."
	icon_state = "daimonion"
	power_type = /datum/coven_power/dawnwalker_deny_the_mother
	max_level = 1
	clan_restricted = FALSE
	all_powers = list(/datum/coven_power/dawnwalker_deny_the_mother)

/datum/coven/dawnwalker_bloodlick
	name = "Dawnwalker Bloodlick"
	desc = "Lick blood from the ground to steady your hunger."
	icon_state = "bloodheal"
	power_type = /datum/coven_power/dawnwalker_bloodlick
	max_level = 1
	clan_restricted = FALSE
	all_powers = list(/datum/coven_power/dawnwalker_bloodlick)

/datum/coven_power/dawnwalker_bloodheal
	name = "Bloodheal"
	desc = "Spend vitae to seal weak bleeding."
	check_flags = COVEN_CHECK_TORPORED
	vitae_cost = 50
	cooldown_length = 30 SECONDS

/datum/coven_power/dawnwalker_bloodheal/can_afford()
	var/datum/component/dawnwalker/component = owner?.GetComponent(/datum/component/dawnwalker)
	return component?.dawnwalker_vitae >= vitae_cost

/datum/coven_power/dawnwalker_bloodheal/spend_resources()
	if(!can_afford())
		return FALSE
	var/datum/component/dawnwalker/component = owner?.GetComponent(/datum/component/dawnwalker)
	component?.adjust_vitae(owner, -vitae_cost)
	return TRUE

/datum/coven_power/dawnwalker_bloodheal/activate()
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/closed_bleeding = FALSE
	for(var/obj/item/bodypart/BP in H.bodyparts)
		if(!BP)
			continue
		var/bleed_rate = BP.get_bleed_rate()
		if(bleed_rate > 0 && bleed_rate <= 1)
			BP.bleeding = 0
			closed_bleeding = TRUE
	if(H.simple_bleeding > 0 && H.simple_bleeding <= 1)
		H.simple_bleeding = 0
		closed_bleeding = TRUE
	if(closed_bleeding)
		H.update_damage_overlays()
	return TRUE

/datum/coven_power/dawnwalker_deny_the_mother
	name = "Deny the Mother"
	desc = "Tap into stolen vitae to unleash a vicious rage."
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE
	vitae_cost = 100
	cancelable = TRUE
	duration_length = 30 SECONDS
	cooldown_length = 1 MINUTES

/datum/coven_power/dawnwalker_deny_the_mother/can_afford()
	var/datum/component/dawnwalker/component = owner?.GetComponent(/datum/component/dawnwalker)
	return component?.dawnwalker_vitae >= vitae_cost

/datum/coven_power/dawnwalker_deny_the_mother/spend_resources()
	if(!can_afford())
		return FALSE
	var/datum/component/dawnwalker/component = owner?.GetComponent(/datum/component/dawnwalker)
	component?.adjust_vitae(owner, -vitae_cost)
	return TRUE

/datum/coven_power/dawnwalker_deny_the_mother/activate()
	. = ..()
	if(!.)
		return
	owner.apply_status_effect(/datum/status_effect/buff/dawnwalker_rage)

/datum/coven_power/dawnwalker_deny_the_mother/deactivate()
	. = ..()
	owner.remove_status_effect(/datum/status_effect/buff/dawnwalker_rage)

/datum/coven_power/dawnwalker_bloodlick
	name = "Bloodlick"
	desc = "Lick blood from the ground to steady your hunger."
	cooldown_length = 8 SECONDS

/datum/coven_power/dawnwalker_bloodlick/activate()
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/turf/T = get_turf(H)
	if(!istype(T))
		return FALSE
	var/consumed = 0
	var/obj/effect/decal/cleanable/blood/puddle/P = locate() in T
	if(P)
		consumed = min(10, P.blood_vol)
		P.blood_vol -= consumed
		if(P.blood_vol <= 0)
			qdel(P)
		else
			P.update_icon()
	else
		var/obj/effect/decal/cleanable/blood/drip/D = locate() in T
		if(D)
			consumed = 1
			qdel(D)
		else
			var/obj/effect/decal/cleanable/blood/B = locate() in T
			if(B)
				consumed = 1
				qdel(B)
	if(!consumed)
		to_chat(H, span_warning("There's no blood here to lick."))
		return FALSE
	var/datum/component/dawnwalker/component = H.GetComponent(/datum/component/dawnwalker)
	component?.adjust_vitae(H, consumed)
	H.add_stress(/datum/stressevent/bloodlick)
	to_chat(H, span_notice("I lick the blood from the ground."))
	return TRUE
