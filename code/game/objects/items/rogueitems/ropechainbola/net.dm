/obj/item/net
	name = "net"
	desc = "A weighed net used to entrap foes. Can be thrown to ensnare a target's legs and slow them down. Victims can struggle out of it and it will fall off after a short time."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "net"
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_WRISTS
	force = 10
	throwforce = 5
	w_class = WEIGHT_CLASS_SMALL
	slipouttime = 5 SECONDS
	gender = NEUTER
	throw_speed = 2

	var/knockdown = 0
	var/ensnare_applied = FALSE
	var/broken_by_force = FALSE


/obj/item/net/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))


/obj/item/net/throw_at(atom/target, range, speed, mob/thrower, spin = 1, diagonals_first = 0, datum/callback/callback)
	if(!..())
		return
	playsound(src.loc, 'sound/blank.ogg', 75, TRUE)


/obj/item/net/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	// 1) Предметная защита: блок, ловля, дефлект
	if(..())
		return

	if(!iscarbon(hit_atom))
		return

	// Защита от повторного применения
	if(ensnare_applied)
		return

	// 2) Интентная защита: парирование, додж
	var/mob/living/carbon/target = hit_atom
	var/mob/living/user = istype(throwingdatum?.thrower, /mob/living) ? throwingdatum.thrower : null
	var/datum/intent/intenty = user?.used_intent

	if(user && intenty && target.checkdefense(intenty, user))
		return

	ensnare(target)

	// Естественное спадание по таймеру
	addtimer(
		CALLBACK(src, PROC_REF(remove_effect)),
		30 SECONDS,
		TIMER_OVERRIDE | TIMER_UNIQUE
	)


/obj/item/net/proc/ensnare(mob/living/carbon/C)
	if(ensnare_applied)
		return
	if(C.legcuffed || C.get_num_legs(FALSE) < 2)
		return

	ensnare_applied = TRUE

	visible_message(span_danger("\The [src] ensnares [C]!"))
	to_chat(C, span_danger("\The [src] entraps you!"))

	C.legcuffed = src
	forceMove(C)
	C.update_inv_legcuffed()
	SSblackbox.record_feedback("tally", "handcuffs", 1, type)
	C.Knockdown(knockdown)
	C.apply_status_effect(/datum/status_effect/debuff/netted)
	playsound(src, 'sound/blank.ogg', 50, TRUE)


/obj/item/net/proc/remove_effect()
	if(!iscarbon(loc))
		return

	var/mob/living/carbon/M = loc
	if(M.legcuffed != src)
		return

	M.legcuffed = null
	M.remove_movespeed_modifier(MOVESPEED_ID_NET_SLOWDOWN, TRUE)
	M.update_inv_legcuffed()
	if(M.has_status_effect(/datum/status_effect/debuff/netted))
		M.remove_status_effect(/datum/status_effect/debuff/netted)

	// Сообщение ТОЛЬКО при естественном спадании
	for(var/mob/V in viewers(M))
		to_chat(V, span_warning("The net slips off [M]."))

	ensnare_applied = FALSE
	forceMove(get_turf(M))


/obj/item/net/proc/on_drop()
	SIGNAL_HANDLER
	// Если система cuffs пометила предмет как сломанный — уничтожаем
	if(broken_by_force)
		qdel(src)
