/* I AM THE LORE MASTER, ARE YOU THE GATEKEEPER? */

/**
 * Holds master copy of all world lore.
 */
SUBSYSTEM_DEF(loremaster)
	name = "Lore"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_LOREMASTER

	/// all entries
	var/static/list/datum/lore/hardcoded = list()
	/// custom entries - not made by path prototype
	var/static/list/datum/lore/custom = list()
	/// entries by id
	var/list/entry_by_id = list()

/datum/controller/subsystem/loremaster/Recover()
	. = ..()
	ReconstructEntries()

/datum/controller/subsystem/loremaster/Initialize()
	InitializeEntries()
	return ..()

/datum/controller/subsystem/loremaster/proc/Fetch(id)
	RETURN_TYPE(/datum/lore)
	if(ispath(id, /datum/lore))
		var/existing = entry_by_id["[id]"]
		if(existing)
			return existing
		else
			var/datum/lore/L = id
			if(initial(L.abstract_type) == id)
				CRASH("Attempted to fetch abstract lore path [id].")
			LAZYINITLIST(hardcoded)
			LAZYINITLIST(entry_by_type)
			. = entry_by_id["[id]"] = new id
			hardcoded += .
	else
		return entry_by_id[id]

/datum/controller/subsystem/loremaster/proc/InitializeEntries()
	var/list/generated = list()
	var/existing_len = islist(hardcoded)? hardcoded.len : 0
	for(var/path in subtypesof(/datum/lore))
		var/datum/lore/L = path
		if(initial(L.abstract_type) == path)
			continue
		if(entry_by_id["[path]"])
			continue
		L = new path(null, FALSE)
		generated += L
	if(existing_len != (islist(hardcoded)? hardcoded.len : 0))
		stack_trace("existing != current in initialization; a lore entry is not using Generate()/New() separation properly.")
	for(var/datum/lore/entry as anything in generated)
		entry_by_id["[entry]"] = entry
		hardcoded += entry
		var/old = entry.id
		entry.Generate()
		if(old != entry.id)
			stack_trace("[entry] ([type]) changed IDs in Generate(); this is illegal.")

/datum/controller/subsystem/loremaster/proc/CreateCustom(type, id, generate = TRUE)
	if(id && entry_by_id["[id]"])
		CRASH("Attempted to create duplicate ID [id]")
	if(!ispath(type, /datum/lore))
		CRASH("Attempted to create invalid custom lore entry of path [type]")
	// no id? gen one
	var/datum/lore/L = new type(id, generate)
	// id will always be unique (random id is always unique/incrementing)
	ASSERT(!entry_by_id[L.id])
	entry_by_id[L.id] += L
	custom += L

/datum/controller/subsystem/loremaster/proc/ReconstructEntries()
	subsystem_log("Reconstructing...")
	for(var/datum/lore/entry in lore | custom)
		if(!istype(entry))
			hardcoded -= entry
			custom -= entry
			subsystem_log("Discarded invalid entry [entry]")
			qdel(entry)
			continue
		if(entry_by_id[entry.id])
			subsystem_log("Ignoring duplicate entry [entry] ([entry.id])")
			hardcoded -= entry
			custom -= entry
			qdel(entry)
			continue
		entry_by_id[entry.id] = entry
