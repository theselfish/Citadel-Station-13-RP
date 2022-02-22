/datum/lore/religion
	abstract_type = /datum/lore/religion
	/// full name
	var/full_name
	/// Deity name
	var/list/deity = "God"

/datum/lore/religion/Generate()
	if(!islist(deity))
		deity = istext(deity)? list(deity) : list()
	. = ..()
	if(isnull(full_name))
		full_name = "The Church of [name]"
