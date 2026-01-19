/datum/coven/dawnwalker_bloodheal
	name = "Dawnwalker Bloodheal"
	desc = "Bloodbound mending."
	icon_state = "bloodheal"
	power_type = /datum/coven_power/dawnwalker_bloodheal
	max_level = 1
	clan_restricted = FALSE

/datum/coven/dawnwalker_fear
	name = "Dawnwalker Rage"
	desc = "A surge of dread and speed."
	icon_state = "daimonion"
	power_type = /datum/coven_power/dawnwalker_fear
	max_level = 1
	clan_restricted = FALSE

/datum/coven_power/dawnwalker_bloodheal
	parent_type = /datum/coven_power/bloodheal/one
	name = "Bloodheal"
	desc = "Spend vitae to mend minor wounds."
	vitae_cost = 15

/datum/coven_power/dawnwalker_bloodheal/can_afford()
	var/usable_vitae = owner?.bloodpool - 3000
	return usable_vitae >= vitae_cost

/datum/coven_power/dawnwalker_fear
	parent_type = /datum/coven_power/demonic/fear_of_the_void_below
	name = "Fear of the Void"
	desc = "Short burst of speed and resilience."
	vitae_cost = 100

/datum/coven_power/dawnwalker_fear/can_afford()
	var/usable_vitae = owner?.bloodpool - 3000
	return usable_vitae >= vitae_cost

/datum/action/dawnwalker_power
	name = "Dawnwalker Power"
	desc = "A bloodbound trick."
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUN|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	button_icon = 'icons/mob/actions/vampspells.dmi'
	icon_icon = 'icons/mob/actions/vampspells.dmi'
	background_icon_state = "spell"
	var/datum/coven/discipline
	var/datum/coven_power/power
	var/discipline_type = /datum/coven

/datum/action/dawnwalker_power/New(Target)
	. = ..()
	discipline = new discipline_type(1)
	power = discipline.current_power
	name = power?.name || name
	desc = power?.desc || desc
	button_icon_state = discipline?.icon_state

/datum/action/dawnwalker_power/Destroy()
	QDEL_NULL(discipline)
	power = null
	return ..()

/datum/action/dawnwalker_power/Grant(mob/M)
	. = ..()
	if(!power || !discipline)
		return
	discipline.owner = M
	power.set_owner(M)

/datum/action/dawnwalker_power/Trigger()
	if(!..())
		return FALSE
	if(!power || !HAS_TRAIT(owner, TRAIT_DAWNWALKER))
		return FALSE
	if(!power.try_activate())
		return FALSE
	UpdateButtonIcon(TRUE)
	return TRUE

/datum/action/dawnwalker_power/IsAvailable()
	if(!..())
		return FALSE
	if(!power || !HAS_TRAIT(owner, TRAIT_DAWNWALKER))
		return FALSE
	return power.can_activate_untargeted()

/datum/action/dawnwalker_power/UpdateButtonIcon(status_only = FALSE, force = FALSE)
	name = power?.name || name
	desc = power?.desc || desc
	button_icon_state = discipline?.icon_state || button_icon_state
	. = ..()
	var/cooldown_left = power?.get_cooldown()
	if(cooldown_left)
		button?.update_maptext(round(cooldown_left))

/datum/action/dawnwalker_power/bloodheal
	discipline_type = /datum/coven/dawnwalker_bloodheal

/datum/action/dawnwalker_power/rage
	discipline_type = /datum/coven/dawnwalker_fear
