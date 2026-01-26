/obj/effect/proc_holder/spell/self/dawnwalker_bloodheal
	name = "Кроволечение"
	desc = "Потратить витэ, чтобы запечатать слабое кровотечение."
	recharge_time = 30 SECONDS
	cooldown_min = 30 SECONDS
	invocation_type = "whisper"
	var/vitae_cost = 50

/obj/effect/proc_holder/spell/self/dawnwalker_bloodheal/can_cast(mob/user = usr)
	. = ..()
	if(!.)
		return FALSE
	var/datum/component/dawnwalker/component = user?.GetComponent(/datum/component/dawnwalker)
	if(!component || component.dawnwalker_vitae < vitae_cost)
		to_chat(user, span_warning("У меня недостаточно витэ."))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/dawnwalker_bloodheal/cast(list/targets, mob/living/user)
	if(!istype(user))
		return FALSE
	var/datum/component/dawnwalker/component = user.GetComponent(/datum/component/dawnwalker)
	if(!component || component.dawnwalker_vitae < vitae_cost)
		to_chat(user, span_warning("У меня недостаточно витэ."))
		return FALSE
	component.adjust_vitae(user, -vitae_cost)
	var/closed_bleeding = FALSE
	for(var/obj/item/bodypart/BP in user.bodyparts)
		if(!BP)
			continue
		var/bleed_rate = BP.get_bleed_rate()
		if(bleed_rate > 0 && bleed_rate <= 1)
			BP.bleeding = 0
			closed_bleeding = TRUE
	if(user.simple_bleeding > 0 && user.simple_bleeding <= 1)
		user.simple_bleeding = 0
		closed_bleeding = TRUE
	if(closed_bleeding)
		user.update_damage_overlays()
	return TRUE

/obj/effect/proc_holder/spell/self/dawnwalker_deny_the_mother
	name = "Отрицание Матери"
	desc = "Высвободить краткий всплеск украденной ярости."
	recharge_time = 1 MINUTES
	cooldown_min = 1 MINUTES
	invocation_type = "shout"
	var/vitae_cost = 100

/obj/effect/proc_holder/spell/self/dawnwalker_deny_the_mother/can_cast(mob/user = usr)
	. = ..()
	if(!.)
		return FALSE
	var/datum/component/dawnwalker/component = user?.GetComponent(/datum/component/dawnwalker)
	if(!component || component.dawnwalker_vitae < vitae_cost)
		to_chat(user, span_warning("У меня недостаточно витэ."))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/dawnwalker_deny_the_mother/cast(list/targets, mob/living/user)
	if(!istype(user))
		return FALSE
	var/datum/component/dawnwalker/component = user.GetComponent(/datum/component/dawnwalker)
	if(!component || component.dawnwalker_vitae < vitae_cost)
		to_chat(user, span_warning("У меня недостаточно витэ."))
		return FALSE
	component.adjust_vitae(user, -vitae_cost)
	user.apply_status_effect(/datum/status_effect/buff/dawnwalker_rage)
	return TRUE

/obj/effect/proc_holder/spell/self/dawnwalker_bloodlick
	name = "Кроволиз"
	desc = "Слизнуть кровь с земли, чтобы восстановить витэ."
	recharge_time = 8 SECONDS
	cooldown_min = 8 SECONDS
	invocation_type = "whisper"

/obj/effect/proc_holder/spell/self/dawnwalker_bloodlick/cast(list/targets, mob/living/user)
	if(!istype(user))
		return FALSE
	var/turf/T = get_turf(user)
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
		to_chat(user, span_warning("Здесь нет крови, чтобы слизывать."))
		return FALSE
	var/datum/component/dawnwalker/component = user.GetComponent(/datum/component/dawnwalker)
	component?.adjust_vitae(user, consumed)
	user.add_stress(/datum/stressevent/bloodlick)
	to_chat(user, span_notice("Я слизываю кровь с земли."))
	return TRUE
