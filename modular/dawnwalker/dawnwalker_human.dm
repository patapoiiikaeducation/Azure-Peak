/mob/living/carbon/human
	var/last_bloodlick_use = 0
	var/last_dawnwalker_rage = 0
	var/last_dawnwalker_bloodheal = 0

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

/mob/living/carbon/human/verb/dawnwalker_rage()
	set name = "Enter Rage"
	set desc = "Push my vitae to ignite a brief, burning frenzy."
	set category = "Skills"
	if(!HAS_TRAIT(src, TRAIT_DAWNWALKER))
		to_chat(src, span_warning("I have no such fury to call upon."))
		return
	if(world.time < last_dawnwalker_rage + 20 SECONDS)
		return
	if(bloodpool < 25)
		to_chat(src, span_warning("I lack the vitae to fuel my rage."))
		return
	if(has_status_effect(/datum/status_effect/buff/dawnwalker_rage))
		return
	last_dawnwalker_rage = world.time
	adjust_bloodpool(-25, FALSE)
	apply_status_effect(/datum/status_effect/buff/dawnwalker_rage)
	to_chat(src, span_warning("My veins blaze as I fall into a hunger-fueled rage!"))

/mob/living/carbon/human/verb/dawnwalker_bloodheal()
	set name = "Bloodheal"
	set desc = "Spend vitae to mend minor wounds."
	set category = "Skills"
	if(!HAS_TRAIT(src, TRAIT_DAWNWALKER))
		to_chat(src, span_warning("I have no blood-bound gifts to draw upon."))
		return
	if(world.time < last_dawnwalker_bloodheal + 30 SECONDS)
		return
	if(bloodpool < 5)
		to_chat(src, span_warning("I lack the vitae to heal."))
		return
	last_dawnwalker_bloodheal = world.time
	adjust_bloodpool(-5, FALSE)
	adjustBruteLoss(-3.8, 0)
	adjustFireLoss(-3.8, 0)
	adjustOxyLoss(-3.8, 0)
	adjustToxLoss(-3.8, 0)
	adjustOrganLoss(ORGAN_SLOT_BRAIN, -3.8)
	adjustCloneLoss(-3.8, 0)
	heal_wounds(5)
	to_chat(src, span_notice("My vitae knits my flesh back together."))
