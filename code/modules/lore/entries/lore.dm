/**
 * Master datum for lore entries.
 */
/datum/lore
	/// Default name - Generate() can change this.
	var/name
	/// id - always string. access can be type tho.
	var/id
	/// next number
	var/static/entry_no = 0
	/// abstract type
	var/abstract_type = /datum/lore
	/// Default contents
	var/description = "An unknown lore entry."

/datum/lore/New()
	if(isnull(id))
		id = "[type]"
	if(isnull(name))
		name = "Lore Entry #[++entry_no]"
	Generate()

/**
 * Generate data here if necessary.
 */
/datum/lore/proc/Generate()

/**
 * Get data section/description
 */
/datum/lore/proc/Description()
	return description
