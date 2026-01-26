/datum/special_trait/dawnwalker
	name = "Рассветный ходок"
	greet_text = span_warning("Я иду как рассветный ходок, живой и проклятый. Кровь поддерживает меня, серебро ослабляет, а чудеса обжигают мою плоть.")
	req_text = "Только живые расы."
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
		var/list/blocked_jobs = list(
			/datum/job/roguetown/lord,
			/datum/job/roguetown/prince,
			/datum/job/roguetown/lady,
			/datum/job/roguetown/priest,
			/datum/job/roguetown/inquisitor,
		)
		if(is_type_in_list(assigned_role, blocked_jobs))
			return FALSE
	return TRUE

/datum/special_trait/dawnwalker/on_apply(mob/living/carbon/human/character, silent)
	ADD_TRAIT(character, TRAIT_DAWNWALKER, "[type]")
	character.AddComponent(/datum/component/dawnwalker)
