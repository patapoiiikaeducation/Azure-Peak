/mob/living/carbon/human
	var/last_bloodlick_use = 0

/mob/living/carbon/human/Stat()
	..()
	if(mind && HAS_TRAIT(src, TRAIT_DAWNWALKER))
		if(statpanel("Stats"))
			stat("Vitae:", bloodpool)
	return

/mob/living/carbon/human/verb/lick_blood()
	set name = "Lick Blood"
	set desc = "Lick blood from the ground to steady your hunger."
	set category = "Skills"
	if(!HAS_TRAIT(src, TRAIT_DAWNWALKER))
		to_chat(src, span_warning("I have no need to stoop to this."))
		return
	if(world.time < last_bloodlick_use + 8 SECONDS)
		return
	last_bloodlick_use = world.time
	var/turf/T = get_turf(src)
	if(!istype(T))
		return
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
		to_chat(src, span_warning("There's no blood here to lick."))
		return
	adjust_bloodpool(consumed)
	add_stress(/datum/stressevent/bloodlick)
	to_chat(src, span_notice("I lick the blood from the ground."))
