/**
 * Master datum for lore entries.
 */
/datum/lore
	/// Default name - Generate() can change this.
	var/name
	/// Default full name - Generate() can change this, defaults to name.
	var/full_name
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
	/// lore codex category - if null, this won't appear in codex
	var/codex_category
	/// lore codex section - if null, this will appear in "Misc"
	var/codex_section = "Misc"
	/// lore codex entry type
	var/codex_style = LORE_STYLE_NORMAL
	/// ids of other lore entries to offer as quick jumps
	var/list/quick_jumps

/datum/lore/New(id, generate = TRUE)
	if(id)
		src.id = id
	if(isnull(src.id))
		src.id = "[type]"
	if(isnull(name))
		name = "Lore Entry #[++entry_no]"
	if(generate)
		var/old = src.id
		Generate()
		if(old != src.id)
			stack_trace("[type] [src] changed its id during Generate(); This is illegal.")

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
	return full_name

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
