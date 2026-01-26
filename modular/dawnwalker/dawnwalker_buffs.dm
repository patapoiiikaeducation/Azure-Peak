#define DAWNWALKER_RAGE_FILTER "dawnwalker_rage"

/atom/movable/screen/alert/status_effect/buff/dawnwalker_rage
	name = "HUNGERFIRE"
	desc = "Hunger and sunlight drive me into a burning frenzy."
	icon_state = "bloodrage"

/datum/status_effect/buff/dawnwalker_rage
	id = "dawnwalker_rage"
	alert_type = /atom/movable/screen/alert/status_effect/buff/dawnwalker_rage
	effectedstats = list(STATKEY_STR = 1, STATKEY_SPD = 1)
	duration = 20 SECONDS
	var/outline_color = "#c23b2a"

/datum/status_effect/buff/dawnwalker_rage/on_apply()
	. = ..()
	var/filter = owner.get_filter(DAWNWALKER_RAGE_FILTER)
	if(!filter)
		owner.add_filter(DAWNWALKER_RAGE_FILTER, 2, list("type" = "outline", "color" = outline_color, "alpha" = 60, "size" = 2))
	return TRUE

/datum/status_effect/buff/dawnwalker_rage/on_remove()
	. = ..()
	owner.remove_filter(DAWNWALKER_RAGE_FILTER)

#undef DAWNWALKER_RAGE_FILTER
