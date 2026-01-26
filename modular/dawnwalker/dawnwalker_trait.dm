/datum/special_trait/dawnwalker
	name = "Dawnwalker"
	greet_text = span_warning("I walk as a dawnwalker, living yet cursed. Blood steadies me, silver weakens me, and miracles scald my flesh.")
	req_text = "Living races only."
	weight = 20

/datum/special_trait/dawnwalker/can_apply(mob/living/carbon/human/character)
	if(!character?.dna?.species)
		return FALSE
	if(NOBLOOD in character.dna.species.species_traits)
		return FALSE
	var/datum/advclass/advclass = SSrole_class_handler.get_advclass_by_name(character.advjob)
	if(istype(advclass, /datum/advclass/wretch/licker))
		return FALSE
	var/datum/job/assigned_role = character.mind?.assigned_role
	if(assigned_role)
		if(istype(assigned_role, /datum/job/roguetown/lord))
			return FALSE
		if(istype(assigned_role, /datum/job/roguetown/prince))
			return FALSE
		if(istype(assigned_role, /datum/job/roguetown/lady))
			return FALSE
		if(istype(assigned_role, /datum/job/roguetown/priest))
			return FALSE
		if(istype(assigned_role, /datum/job/roguetown/inquisitor))
			return FALSE
	return TRUE

/datum/special_trait/dawnwalker/on_apply(mob/living/carbon/human/character, silent)
	ADD_TRAIT(character, TRAIT_DAWNWALKER, "[type]")
	character.AddComponent(/datum/component/dawnwalker)
