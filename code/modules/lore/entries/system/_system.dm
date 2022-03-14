/**
 * Represents a singular star system.
 */
/datum/lore/system
	/// root level celestial bodies - usually stars - automatically generated from celestial body defs
	var/list/datum/lore/celestial_body/core_bodies
	/// all bodies in system - automatically generated from celestial body defs
	var/list/datum/lore/celestial_body/all_bodies
	/// faction presence - defined on this datum
	var/list/datum/lore/faction/faction_presence = list()
	/// full name, if any
	var/full_name
	/// location relative to galactic center; angle & lightyears
	var/datum/polar_coordinates/location
	/// distance between each core body if multiple, in light seconds
	var/multi_core_dist = 30

/datum/lore/system/FullName()
	return full_name || Name()

/datum/lore/system/proc/DistanceTo(datum/lore/system/other)
	return (location && other.location)? location.Dist(other.location) : -1

/datum/lore/system/proc/DistanceText(datum/lore/system/other)
	. = DistanceTo(other)
	return . == -1? "unknown" : "[.] ly"
