/datum/polar_coordinates
	var/angle	// deg clockwise from 0
	var/dist	// number

/datum/polar_coordinates/proc/Dist(datum/polar_coordinates/other)
	return sqrt((dist*dist) + (other.dist * other.dist) - 2*dist*other.dist * cos(other.angle - angle))

/datum/typed_scalar
	/// float
	var/value = 0
	/// units
	var/unit

/datum/typed_scalar/New(value, unit)
	src.value = value
	src.unit = unit

/datum/typed_scalar/proc/Render(short = TRUE)
	return "[value] [short? unit_to_short(unit) : unit]"
