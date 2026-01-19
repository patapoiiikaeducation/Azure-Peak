/datum/virtue/utility/dawnwalker
	name = "Dawnwalker"
	desc = "A living dhampir, shunned and feared. Blood sustains me, silver weakens me, and miracles scald my flesh."
	custom_text = "Living races only. Grants a small bloodpool and blood-linked survival."
	added_traits = list(TRAIT_DAWNWALKER, TRAIT_SILVER_WEAK)

/datum/virtue/utility/dawnwalker/apply_to_human(mob/living/carbon/human/recipient)
	if(!recipient?.dna?.species)
		return
	if(NOBLOOD in recipient.dna.species.species_traits)
		to_chat(recipient, span_warning("My bloodless body cannot take this curse."))
		return
	recipient.maxbloodpool = 3250
	recipient.set_bloodpool(3250)
	recipient.AddComponent(/datum/component/dawnwalker)

/datum/virtue/utility/dawnwalker/handle_traits(mob/living/carbon/human/recipient)
	if(!recipient?.dna?.species)
		return
	if(NOBLOOD in recipient.dna.species.species_traits)
		return
	..()
