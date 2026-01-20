/datum/coven/dawnwalker_bloodheal
	name = "Dawnwalker Bloodheal"
	desc = "Bloodbound mending."
	icon_state = "bloodheal"
	power_type = /datum/coven_power/bloodheal
	max_level = 1
	clan_restricted = FALSE
	all_powers = list(/datum/coven_power/bloodheal/dawnwalker)

/datum/coven/dawnwalker_fear
	name = "Dawnwalker Rage"
	desc = "A surge of dread and speed."
	icon_state = "daimonion"
	power_type = /datum/coven_power/demonic
	max_level = 1
	clan_restricted = FALSE
	all_powers = list(/datum/coven_power/demonic/fear_of_the_void_below/dawnwalker)

/datum/coven/dawnwalker_bloodlick
	name = "Dawnwalker Bloodlick"
	desc = "Lick blood from the ground to steady your hunger."
	icon_state = "bloodheal"
	power_type = /datum/coven_power/dawnwalker_bloodlick
	max_level = 1
	clan_restricted = FALSE
	all_powers = list(/datum/coven_power/dawnwalker_bloodlick)

/datum/coven_power/bloodheal/dawnwalker
	parent_type = /datum/coven_power/bloodheal/one
	name = "Bloodheal"
	desc = "Spend vitae to mend minor wounds."
	vitae_cost = 15

/datum/coven_power/bloodheal/dawnwalker/can_afford()
	var/datum/component/dawnwalker/component = owner?.GetComponent(/datum/component/dawnwalker)
	return component?.dawnwalker_vitae >= vitae_cost

/datum/coven_power/bloodheal/dawnwalker/spend_resources()
	if(!can_afford())
		return FALSE
	var/datum/component/dawnwalker/component = owner?.GetComponent(/datum/component/dawnwalker)
	component?.adjust_vitae(owner, -vitae_cost)
	return TRUE

/datum/coven_power/demonic/fear_of_the_void_below/dawnwalker
	parent_type = /datum/coven_power/demonic/fear_of_the_void_below
	name = "Fear of the Void"
	desc = "Short burst of speed and resilience."
	vitae_cost = 100

/datum/coven_power/demonic/fear_of_the_void_below/dawnwalker/can_afford()
	var/datum/component/dawnwalker/component = owner?.GetComponent(/datum/component/dawnwalker)
	return component?.dawnwalker_vitae >= vitae_cost

/datum/coven_power/demonic/fear_of_the_void_below/dawnwalker/spend_resources()
	if(!can_afford())
		return FALSE
	var/datum/component/dawnwalker/component = owner?.GetComponent(/datum/component/dawnwalker)
	component?.adjust_vitae(owner, -vitae_cost)
	return TRUE

/datum/coven_power/demonic/fear_of_the_void_below/dawnwalker/activate()
	. = ..()
	if(!.)
		return
	owner.remove_movespeed_modifier(MOVESPEED_ID_FOTV)
	owner.remove_status_effect(/datum/status_effect/buff/fotv)
	owner.apply_status_effect(/datum/status_effect/buff/dawnwalker_rage)

/datum/coven_power/demonic/fear_of_the_void_below/dawnwalker/deactivate()
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
