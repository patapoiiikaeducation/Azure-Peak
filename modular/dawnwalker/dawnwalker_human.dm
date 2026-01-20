/mob/living/carbon/human

/mob/living/carbon/human/Stat()
	..()
	if(mind && HAS_TRAIT(src, TRAIT_DAWNWALKER))
		if(statpanel("Stats"))
			var/datum/component/dawnwalker/component = GetComponent(/datum/component/dawnwalker)
			stat("Vitae:", component?.dawnwalker_vitae)
	return
