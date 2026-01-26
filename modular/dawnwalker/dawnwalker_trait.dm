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
	if(character.advjob == "Licker")
		return FALSE
	var/assigned_role = character.mind?.assigned_role
	if(assigned_role)
		if(assigned_role in GLOB.noble_positions)
			return FALSE
		if(assigned_role == "Bishop")
			return FALSE
		if(assigned_role == "Inquisitor")
			return FALSE
	return TRUE

/datum/special_trait/dawnwalker/on_apply(mob/living/carbon/human/character, silent)
	ADD_TRAIT(character, TRAIT_DAWNWALKER, "[type]")
	character.AddComponent(/datum/component/dawnwalker)
