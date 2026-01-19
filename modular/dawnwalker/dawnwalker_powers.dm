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
