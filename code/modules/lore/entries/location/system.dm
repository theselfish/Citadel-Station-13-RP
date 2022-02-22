/**
 * Represents a singular star system.
 */
/datum/lore/location/system
	abstract_type = /datum/lore/location/system
	/// root level celestial bodies - usually stars - automatically generated from celestial body defs
	var/list/datum/lore/celestial_body/core_bodies
	/// all bodies in system - automatically generated from celestial body defs
	var/list/datum/lore/celestial_body/all_bodies
	/// location relative to galactic center; angle & lightyears
	var/datum/polar_coordinates/location

// /datum/lore/location/system/DistanceTo(datum/lore/location/other)
// 	return (location && other.location)? location.Dist(other.location) : -1

// /datum/lore/system/proc/DistanceText(datum/lore/system/other)
// 	. = DistanceTo(other)
// 	return . == -1? "unknown" : "[.] ly"
