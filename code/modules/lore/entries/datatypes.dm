/datum/polar_coordinates
	var/angle	// deg clockwise from 0
	var/dist	// number

/datum/polar_coordinates/proc/Dist(datum/polar_coordinates/other)
	return sqrt((dist*dist) + (other.dist * other.dist) - 2*dist*other.dist * cos(other.angle - angle))
