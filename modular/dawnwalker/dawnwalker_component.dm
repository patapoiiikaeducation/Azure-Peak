/datum/component/dawnwalker
	var/last_blood_heal = 0
	var/last_sun_tick = 0
	var/last_miracle_warning = 0
	var/in_sunlight = FALSE
	var/list/datum/coven/dawnwalker_covens
	var/last_frenzy_check = 0
	var/max_vitae = 250
	var/dawnwalker_vitae = 0
	var/atom/movable/screen/bloodpool/dawnwalker_bloodpool

/datum/component/dawnwalker/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	var/mob/living/carbon/human/H = parent
	if(istype(H))
		initialize_vitae(H)
		initialize_bloodpool_hud(H)
		ensure_powers(H)
	RegisterSignal(parent, COMSIG_HUMAN_LIFE, PROC_REF(handle_life))
	RegisterSignal(parent, COMSIG_LIVING_MIRACLE_HEAL_APPLY, PROC_REF(on_miracle_heal))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_EFFECT, PROC_REF(on_item_attack_effect))
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_item_equipped))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_item_dropped))
	RegisterSignal(parent, COMSIG_LIVING_DRINKED_LIMB_BLOOD, PROC_REF(on_drink_blood))
	return ..()

/datum/component/dawnwalker/Destroy()
	var/mob/living/carbon/human/H = parent
	if(istype(H))
		clear_bloodpool_hud(H)
	if(length(dawnwalker_covens))
		for(var/datum/coven/coven as anything in dawnwalker_covens)
			H.remove_coven(coven, silent = TRUE)
		QDEL_LIST(dawnwalker_covens)
		dawnwalker_covens = null
	return ..()

/datum/component/dawnwalker/proc/initialize_bloodpool_hud(mob/living/carbon/human/H)
	if(!H?.hud_used)
		return
	if(dawnwalker_bloodpool)
		return
	dawnwalker_bloodpool = new /atom/movable/screen/bloodpool(null, H.hud_used)
	dawnwalker_bloodpool.set_fill_color("#510000")
	H.hud_used.infodisplay += dawnwalker_bloodpool
	update_bloodpool_position(H)
	update_bloodpool_display(H)

/datum/component/dawnwalker/proc/initialize_vitae(mob/living/carbon/human/H)
	if(dawnwalker_vitae <= 0)
		dawnwalker_vitae = max_vitae
	update_bloodpool_display(H)

/datum/component/dawnwalker/proc/update_bloodpool_display(mob/living/carbon/human/H)
	if(!H || !dawnwalker_bloodpool)
		return
	dawnwalker_bloodpool.name = "Vitae: [dawnwalker_vitae]"
	dawnwalker_bloodpool.desc = "Vitae: [dawnwalker_vitae]/[max_vitae]"
	if(dawnwalker_vitae <= 0 || max_vitae <= 0)
		dawnwalker_bloodpool.set_value(0, 1 SECONDS)
	else
		dawnwalker_bloodpool.set_value((100 / (max_vitae / dawnwalker_vitae)) / 100, 1 SECONDS)

/datum/component/dawnwalker/proc/update_bloodpool_position(mob/living/carbon/human/H)
	if(!dawnwalker_bloodpool)
		return
	if(H?.devotion)
		dawnwalker_bloodpool.screen_loc = "WEST-6,CENTER+2"
	else
		dawnwalker_bloodpool.screen_loc = rogueui_vitae

/datum/component/dawnwalker/proc/adjust_vitae(mob/living/carbon/human/H, amount)
	dawnwalker_vitae = CLAMP(dawnwalker_vitae + amount, 0, max_vitae)
	update_bloodpool_display(H)

/datum/component/dawnwalker/proc/ensure_powers(mob/living/carbon/human/H)
	if(!should_apply_effects(H))
		return
	if(length(dawnwalker_covens))
		return
	initialize_vitae(H)
	var/datum/coven/dawnwalker_bloodheal/bloodheal = new()
	var/datum/coven/dawnwalker_fear/fear = new()
	var/datum/coven/dawnwalker_bloodlick/bloodlick = new()
	dawnwalker_covens = list(bloodheal, fear, bloodlick)
	for(var/datum/coven/coven as anything in dawnwalker_covens)
		coven.initialize_powers_for_level(coven.max_level)
		H.give_coven(coven)

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
		if(length(dawnwalker_covens))
			for(var/datum/coven/coven as anything in dawnwalker_covens)
				H.remove_coven(coven, silent = TRUE)
			QDEL_LIST(dawnwalker_covens)	
			dawnwalker_covens = null
		clear_bloodpool_hud(H)
		return
	initialize_bloodpool_hud(H)
	ensure_powers(H)
	update_bloodpool_position(H)
	update_bloodpool_display(H)
	handle_low_vitae_frenzy(H)
	handle_blood_heal(H)
	handle_sunlight(H)
	handle_silver_exposure(H)

/datum/component/dawnwalker/proc/clear_bloodpool_hud(mob/living/carbon/human/H)
	if(!dawnwalker_bloodpool)
		return
	H?.hud_used?.infodisplay -= dawnwalker_bloodpool
	QDEL_NULL(dawnwalker_bloodpool)

/datum/component/dawnwalker/proc/handle_blood_heal(mob/living/carbon/human/H)
	if(world.time < last_blood_heal + 8 SECONDS)
		return
	last_blood_heal = world.time
	if(dawnwalker_vitae <= 0)
		return
	var/total_damage = H.getBruteLoss() + H.getFireLoss()
	if(total_damage <= 0)
		return
	H.heal_overall_damage(1, 1)
	adjust_vitae(H, -1)

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
	if(dawnwalker_vitae >= 100)
		in_sunlight = FALSE
		return
	if(!in_sunlight)
		to_chat(H, span_danger("Hunger boils in my veins as the sun sears me!"))
		in_sunlight = TRUE
	H.apply_status_effect(/datum/status_effect/buff/dawnwalker_rage)
	if(H.has_status_effect(/datum/status_effect/buff/dawnwalker_rage))
		H.fire_act(6, 10)
		H.adjustFireLoss(15, 0)
		if(prob(20))
			H.adjustFireLoss(60, 0)
			to_chat(H, span_userdanger("The sun rends my raging flesh apart!"))
	else
		H.fire_act(1, 2)
	if(dawnwalker_vitae > 0)
		adjust_vitae(H, -1)

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

/datum/component/dawnwalker/proc/handle_low_vitae_frenzy(mob/living/carbon/human/H)
	if(dawnwalker_vitae >= 50)
		return
	if(last_frenzy_check + 5 MINUTES > world.time)
		return
	if(prob(9))
		last_frenzy_check = world.time
		H.rollfrenzy()

/datum/component/dawnwalker/proc/on_drink_blood(datum/source, mob/living/carbon/victim)
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return
	if(!should_apply_effects(H))
		return
	return

/datum/component/dawnwalker/proc/on_examine(datum/source, mob/user, list/examine_list)
	if(!isliving(user))
		return
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return
	if(HAS_TRAIT(H, TRAIT_DAWNWALKER) && user != H)
		if(!HAS_TRAIT(user, TRAIT_DAWNWALKER))
			user.add_stress(/datum/stressevent/dawnwalker_disgust)
		var/mob/living/carbon/human/examiner = user
		if(istype(examiner) && examiner.mind?.has_antag_datum(/datum/antagonist/vampire))
			examiner.add_stress(/datum/stressevent/dawnwalker_vampire_disgust)
			examine_list += span_boldnotice("A filthy wretch.")
			addtimer(CALLBACK(src, PROC_REF(handle_vampire_examine_reaction), examiner, H), 1)

/datum/component/dawnwalker/proc/handle_vampire_examine_reaction(mob/living/carbon/human/examiner, mob/living/carbon/human/target)
	if(!istype(examiner) || !istype(target))
		return
	if(prob(95))
		examiner.say("[target.name], you filthy wretch!!!")
		examiner.emote("scream", forced = TRUE)
		examiner.playsound_local(examiner, pick('sound/vo/male/gen/scream (1).ogg','sound/vo/male/gen/scream (2).ogg'), 125, TRUE)

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
	handle_silver_exposure(H)

/datum/component/dawnwalker/proc/on_item_dropped(datum/source, obj/item/item)
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return
	handle_silver_exposure(H)

/datum/component/dawnwalker/proc/handle_silver_exposure(mob/living/carbon/human/H)
	if(!H)
		return
	if(has_silver_equipped(H))
		try_apply_silver_debuff(H)
	else
		return

/datum/component/dawnwalker/proc/has_silver_equipped(mob/living/carbon/human/H)
	for(var/obj/item/I in H.get_equipped_items(TRUE))
		if(I?.is_silver)
			return TRUE
	for(var/obj/item/I in H.held_items)
		if(I?.is_silver)
			return TRUE
	return FALSE
