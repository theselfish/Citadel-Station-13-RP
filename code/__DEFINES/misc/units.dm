#define METERS			"meters"
#define LIGHTYEARS		"lightyears"
#define LIGHTSECONDS	"light-seconds"
#define WATTS			"watts"

#define KILO			"k"
#define MEGA			"M"
#define GIGA			"G"

/proc/unit_to_short(unit)
	switch(unit)
		if(METERS)
			return "m"
		if(LIGHTYEARS)
			return "ly"
		if(LIGHTSECONDS)
			return "ls"
		if(WATTS)
			return "W"
		else
			return "\[UNIT_TO_SHORT CONVERT ERROR: [unit]]"
