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
	/// wiki page name, if any
	var/wiki_page
	/// lore codex category
	var/codex_category = LORE_CATEGORY_MISC
	/// lore codex entry type
	var/codex_style = LORE_STYLE_NORMAL

/datum/lore/New(id)
	if(id)
		src.id = id
	if(isnull(src.id))
		src.id = "[type]"
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

/**
 * Get short name
 */
/datum/lore/proc/Name()
	return name

/**
 * Get full name
 */
/datum/lore/proc/FullName()
	return name

/**
 * Get wiki path
 */
/datum/lore/proc/GetWikiLink()
	return HasWikiLink() && (CONFIG_GET(url/wiki_page_root) + wiki_page)

/**
 * Has wiki link?
 */
/datum/lore/proc/HasWikiLink()
	return !!wiki_page

/**
 * Return tgui datastructure
 */
/datum/lore/proc/DataList()
	#warn impl
