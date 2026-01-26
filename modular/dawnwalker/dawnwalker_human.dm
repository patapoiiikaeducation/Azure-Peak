/mob/living/carbon/human

/mob/living/carbon/human/Stat()
	..()
	if(mind && HAS_TRAIT(src, TRAIT_DAWNWALKER))
		if(statpanel("Stats"))
			var/datum/component/dawnwalker/component = GetComponent(/datum/component/dawnwalker)
			stat("Витэ:", "[component?.dawnwalker_vitae]/[component?.max_vitae]")
	return
