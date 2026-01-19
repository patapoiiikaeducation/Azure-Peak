/datum/action/dawnwalker_power
	name = "Dawnwalker Power"
	desc = "A bloodbound trick."
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUN|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	button_icon = 'icons/mob/actions/vampspells.dmi'
	icon_icon = 'icons/mob/actions/vampspells.dmi'
	background_icon_state = "spell"

	var/cooldown_length = 0
	var/vitae_cost = 0
	var/cooldown_end = 0
	var/base_bloodpool = 3000

/datum/action/dawnwalker_power/proc/can_activate()
	if(!owner)
		return FALSE
	if(!HAS_TRAIT(owner, TRAIT_DAWNWALKER))
		return FALSE
	if(cooldown_end > world.time)
		var/time_left = round((cooldown_end - world.time) / 1 SECONDS, 1)
		to_chat(owner, span_warning("[name] is not ready for another [time_left] seconds."))
		return FALSE
	var/usable_vitae = owner.bloodpool - base_bloodpool
	if(vitae_cost > 0 && usable_vitae < vitae_cost)
		to_chat(owner, span_warning("I lack the vitae to use [name]."))
		return FALSE
	return TRUE

/datum/action/dawnwalker_power/Trigger()
	if(!..())
		return FALSE
	if(!can_activate())
		return FALSE
	if(!activate())
		return FALSE
	if(vitae_cost > 0)
		owner.adjust_bloodpool(-vitae_cost, FALSE)
	if(cooldown_length)
		cooldown_end = world.time + cooldown_length
		button?.update_maptext(round(cooldown_length))
		owner?.update_action_buttons()
	return TRUE

/datum/action/dawnwalker_power/proc/activate()
	return TRUE

/datum/action/dawnwalker_power/IsAvailable()
	if(!..())
		return FALSE
	if(cooldown_end > world.time)
		return FALSE
	if(!HAS_TRAIT(owner, TRAIT_DAWNWALKER))
		return FALSE
	return TRUE

/datum/action/dawnwalker_power/UpdateButtonIcon(status_only = FALSE, force = FALSE)
	. = ..()
	if(cooldown_end > world.time)
		button?.update_maptext(round(cooldown_end - world.time))

/datum/action/dawnwalker_power/bloodheal
	name = "Bloodheal"
	desc = "Spend vitae to mend minor wounds."
	button_icon_state = "bloodheal"
	cooldown_length = 30 SECONDS
	vitae_cost = 10

/datum/action/dawnwalker_power/bloodheal/activate()
	owner.adjustBruteLoss(-3.8, 0)
	owner.adjustFireLoss(-3.8, 0)
	owner.adjustOxyLoss(-3.8, 0)
	owner.adjustToxLoss(-3.8, 0)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -3.8)
	owner.adjustCloneLoss(-3.8, 0)
	owner.heal_wounds(5)
	to_chat(owner, span_notice("My vitae knits my flesh back together."))
	return TRUE

/datum/action/dawnwalker_power/rage
	name = "Fear of the Void"
	desc = "Ignite a brief, burning frenzy."
	button_icon_state = "daimonion"
	cooldown_length = 1 MINUTES
	vitae_cost = 100
	var/duration_length = 30 SECONDS

/datum/action/dawnwalker_power/rage/can_activate()
	if(!..())
		return FALSE
	if(owner.has_status_effect(/datum/status_effect/buff/fotv))
		to_chat(owner, span_warning("My rage already burns hot."))
		return FALSE
	return TRUE

/datum/action/dawnwalker_power/rage/activate()
	owner.add_movespeed_modifier(MOVESPEED_ID_FOTV, multiplicative_slowdown = -0.2)
	owner.apply_status_effect(/datum/status_effect/buff/fotv)
	playsound(owner, 'sound/misc/portal_op.ogg', 40, TRUE)
	addtimer(CALLBACK(src, PROC_REF(end_rage), owner), duration_length)
	return TRUE

/datum/action/dawnwalker_power/rage/proc/end_rage(mob/living/carbon/human/target)
	if(!istype(target))
		return
	target.remove_movespeed_modifier(MOVESPEED_ID_FOTV)
	target.remove_status_effect(/datum/status_effect/buff/fotv)
	playsound(target, 'sound/misc/portalactivate.ogg', 40, TRUE)
