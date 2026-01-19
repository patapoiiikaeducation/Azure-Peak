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
	return TRUE

/datum/special_trait/dawnwalker/on_apply(mob/living/carbon/human/character, silent)
	ADD_TRAIT(character, TRAIT_DAWNWALKER, "[type]")
	character.maxbloodpool = 250
	character.set_bloodpool(250)
	character.AddComponent(/datum/component/dawnwalker)
