/datum/component/dawnwalker
	var/last_blood_heal = 0
	var/last_sun_tick = 0
	var/last_miracle_warning = 0
	var/in_sunlight = FALSE

/datum/component/dawnwalker/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	var/mob/living/carbon/human/H = parent
	if(istype(H))
		initialize_bloodpool_hud(H)
	RegisterSignal(parent, COMSIG_HUMAN_LIFE, PROC_REF(handle_life))
	RegisterSignal(parent, COMSIG_LIVING_MIRACLE_HEAL_APPLY, PROC_REF(on_miracle_heal))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_EFFECT, PROC_REF(on_item_attack_effect))
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_item_equipped))
	return ..()

/datum/component/dawnwalker/Destroy()
	var/mob/living/carbon/human/H = parent
	if(istype(H) && H.hud_used?.bloodpool)
		if(!H.clan && !H.mind?.has_antag_datum(/datum/antagonist/vampire) && !H.devotion)
			H.hud_used.shutdown_bloodpool()
	return ..()

/datum/component/dawnwalker/proc/initialize_bloodpool_hud(mob/living/carbon/human/H)
	if(!H?.hud_used)
		return
	if(H.hud_used.bloodpool)
		return
	H.hud_used.initialize_bloodpool()
	H.hud_used.bloodpool.set_fill_color("#510000")
	H.set_bloodpool(H.bloodpool)

/datum/component/dawnwalker/proc/should_apply_effects(mob/living/carbon/human/H)
	if(!HAS_TRAIT(H, TRAIT_DAWNWALKER))
		return FALSE
	if(H.clan)
		return FALSE
	if(H.mind?.has_antag_datum(/datum/antagonist/vampire))
		return FALSE
	return TRUE

/datum/component/dawnwalker/proc/handle_life(mob/living/source)
	var/mob/living/carbon/human/H = source
	if(!istype(H) || H.stat == DEAD || H.advsetup)
		return
	if(!should_apply_effects(H))
		return
	initialize_bloodpool_hud(H)
	H.handle_bloodpool_effects()
	handle_blood_heal(H)
	handle_sunlight(H)

/datum/component/dawnwalker/proc/handle_blood_heal(mob/living/carbon/human/H)
	if(world.time < last_blood_heal + 8 SECONDS)
		return
	last_blood_heal = world.time
	if(H.bloodpool <= 0)
		return
	var/total_damage = H.getBruteLoss() + H.getFireLoss()
	if(total_damage <= 0)
		return
	H.heal_overall_damage(1, 1)
	H.adjust_bloodpool(-1, FALSE)

/datum/component/dawnwalker/proc/handle_sunlight(mob/living/carbon/human/H)
	if(world.time < last_sun_tick + 2 SECONDS)
		return
	last_sun_tick = world.time
	if(!isturf(H.loc))
		in_sunlight = FALSE
		return
	var/turf/T = H.loc
	if(!T.can_see_sky())
		if(in_sunlight)
			to_chat(H, span_notice("The sun's gaze fades from my skin."))
		in_sunlight = FALSE
		return
	var/hour = FLOOR(station_time() / 36000, 1)
	if(hour < 8 || hour > 16)
		in_sunlight = FALSE
		return
	if(H.bloodpool >= 100)
		in_sunlight = FALSE
		return
	if(!in_sunlight)
		to_chat(H, span_danger("Hunger boils in my veins as the sun sears me!"))
		in_sunlight = TRUE
	H.apply_status_effect(/datum/status_effect/buff/dawnwalker_rage)
	H.fire_act(1, 2)
	H.adjust_bloodpool(-1, FALSE)

/datum/component/dawnwalker/proc/on_miracle_heal(datum/source, healing_on_tick, healing_datum)
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return
	if(!should_apply_effects(H))
		return
	H.adjustFireLoss(max(1, round(healing_on_tick * 0.5)), 0)
	if(last_miracle_warning + 10 SECONDS < world.time)
		last_miracle_warning = world.time
		to_chat(H, span_warning("The miracle stings, turning my flesh to ash."))

/datum/component/dawnwalker/proc/on_examine(datum/source, mob/user, list/examine_list)
	if(!isliving(user))
		return
	if(HAS_TRAIT(parent, TRAIT_DAWNWALKER) && user != parent)
		if(!HAS_TRAIT(user, TRAIT_DAWNWALKER))
			user.add_stress(/datum/stressevent/dawnwalker_disgust)

/datum/component/dawnwalker/proc/should_apply_silver_debuff(mob/living/carbon/human/H)
	if(!should_apply_effects(H))
		return FALSE
	if(H.has_status_effect(STATUS_EFFECT_ANTIMAGIC))
		return FALSE
	return TRUE

/datum/component/dawnwalker/proc/try_apply_silver_debuff(mob/living/carbon/human/H)
	if(!should_apply_silver_debuff(H))
		return
	H.apply_status_effect(/datum/status_effect/debuff/dawnwalker_silver)

/datum/component/dawnwalker/proc/on_item_attack_effect(datum/source, mob/user, obj/item/bodypart/affecting, intent, selzone, obj/item/weapon)
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return
	if(istype(weapon) && weapon?.is_silver)
		try_apply_silver_debuff(H)

/datum/component/dawnwalker/proc/on_item_equipped(datum/source, obj/item/item, slot)
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return
	if(istype(item) && item?.is_silver)
		try_apply_silver_debuff(H)
