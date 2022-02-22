/datum/lore/faction/religion
	abstract_type = /datum/lore/religion
	/// Deity name
	var/list/deity = "God"

/datum/lore/faction/religion/Generate()
	if(!islist(deity))
		deity = istext(deity)? list(deity) : list()
	. = ..()
	if(isnull(full_name))
		full_name = "The Church of [name]"

/datum/lore/primer/religion
	#warn impl
	section_default = TRUE

