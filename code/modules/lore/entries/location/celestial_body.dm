/datum/lore/location/celestial_body
	abstract_type = /datum/lore/location/celestial_body
	/// orbits this body - set to id, auto-linked on init
	var/datum/lore/celestial_body/orbiting
	/// orbiting this body - automatically made
	var/list/datum/lore/celestial_body/orbiters

/datum/lore/location/celestial_body/Generate()
	. = ..()
	if(orbiting)
		var/datum/lore/celestial_body/_orbiting = istype(orbiting)? orbiting : SSloremaster.Fetch(orbiting)
		if(!istype(_orbiting))
			CRASH("Invalid orbit: [orbiting]")
		_orbiting.orbiters += src
		orbiting = _orbiting
		// if it isn't initialized
		if(!istype(_orbiting.loc))
			// it'll PlaceInto later
			return
		else
			PlaceInto(_orbiting.loc)
	// else, we're root.


/datum/lore/location/celestial_body/proc/GetAllOrbiters(include_self = TRUE)
	. = list()
	var/list/processing = list(src)
	while(processing.len)
		var/datum/lore/location/L = processing[processing.len--]
		if(!istype(L))
			continue
		if(L in .)
			CRASH("Loop found: [english_list(.)].")
		. += L
		processing += L.orbiters
	if(!include_self)
		. -= src

/datum/lore/location/celestial_body/PlaceInto(datum/lore/location/container, recurse = TRUE)
	. = ..()
	if(!recurse)
		return
	// we're the root level move; break orbit of whatever we were orbiting
	orbiting?.orbiters -= src
	orbiting = null
	for(var/datum/lore/location/celestial_body/B as anything in GetAllOrbiters(FALSE))
		B.PlaceInto(container, FALSE)
