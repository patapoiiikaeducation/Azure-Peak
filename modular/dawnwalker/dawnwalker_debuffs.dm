/datum/status_effect/debuff/dawnwalker_silver
	id = "dawnwalker_silver"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/dawnwalker_silver
	effectedstats = list(STATKEY_STR = -2, STATKEY_CON = -2, STATKEY_SPD = -1)
	duration = 30 SECONDS

/datum/status_effect/debuff/dawnwalker_silver/on_apply()
	. = ..()
	if(!owner)
		return FALSE
	if(owner.has_status_effect(/datum/status_effect/buff/dawnwalker_rage))
		owner.remove_status_effect(/datum/status_effect/buff/dawnwalker_rage)
		owner.visible_message(span_warning("[owner] выглядит гораздо слабее."), span_warning("Серебро гасит мою ярость. Я выгляжу гораздо слабее."))
	else
		owner.visible_message(span_warning("[owner] выглядит гораздо слабее."), span_warning("Я выгляжу гораздо слабее."))
	return TRUE

/atom/movable/screen/alert/status_effect/debuff/dawnwalker_silver
	name = "Опаляющее серебро"
	desc = "Серебро вытягивает мою силу."
	icon_state = "bleed2"
