/datum/virtue/utility/dawnwalker
	name = "Рассветный ходок"
	desc = "Живой дампир, которого сторонятся и боятся. Кровь поддерживает меня, серебро ослабляет, а чудеса обжигают мою плоть."
	custom_text = "Только живые расы. Даёт небольшой запас витэ и выживание, зависящее от крови."
	added_traits = list(TRAIT_DAWNWALKER)

/datum/virtue/utility/dawnwalker/apply_to_human(mob/living/carbon/human/recipient)
	if(!recipient?.dna?.species)
		return
	if(NOBLOOD in recipient.dna.species.species_traits)
		to_chat(recipient, span_warning("Моё бескровное тело не может вынести это проклятие."))
		return
	recipient.AddComponent(/datum/component/dawnwalker)

/datum/virtue/utility/dawnwalker/handle_traits(mob/living/carbon/human/recipient)
	if(!recipient?.dna?.species)
		return
	if(NOBLOOD in recipient.dna.species.species_traits)
		return
	..()
