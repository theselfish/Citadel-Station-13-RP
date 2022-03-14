/datum/lore/celestial_body
	/// orbits this obdy - set to id, auto-linked on init
	var/datum/lore/celestial_body/orbiting
	/// orbiting this body - automatically made
	var/list/datum/lore/celestial_body/orbiters
	/// system this belongs to - set this only for core bodies, or for non orbiting bodies, or it'll be overwritten
	var/datum/lore/system/system
	/// polar coordinates in system - angle and light-seconds. only set manually if it isn't orbiting, or it'll be overwritten
	var/datum/polar_coordinates/location
