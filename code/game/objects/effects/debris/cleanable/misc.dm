/obj/effect/debris/cleanable/generic
	name = "clutter"
	desc = "Someone should clean that up."
	gender = PLURAL
	density = 0
	anchored = 1
	icon = 'icons/obj/objects.dmi'
	icon_state = "shards"

/obj/effect/debris/cleanable/ash
	name = "ashes"
	desc = "Ashes to ashes, dust to dust, and into space."
	gender = PLURAL
	icon = 'icons/obj/objects.dmi'
	icon_state = "ash"
	anchored = 1

/obj/effect/debris/cleanable/ash/attack_hand(mob/user as mob)
	to_chat(user, "<span class='notice'>[src] sifts through your fingers.</span>")
	var/turf/simulated/floor/F = get_turf(src)
	if (istype(F))
		F.dirt += 4
	qdel(src)


/obj/effect/debris/cleanable/greenglow/New()
	..()
	spawn(1200)// 2 minutes
		qdel(src)

/obj/effect/debris/cleanable/dirt
	name = "dirt"
	desc = "Someone should clean that up."
	gender = PLURAL
	density = 0
	anchored = 1
	icon = 'icons/effects/effects.dmi'
	icon_state = "dirt"
	mouse_opacity = 0

/obj/effect/debris/cleanable/flour
	name = "flour"
	desc = "It's still good. Four second rule!"
	gender = PLURAL
	density = 0
	anchored = 1
	icon = 'icons/effects/effects.dmi'
	icon_state = "flour"

/obj/effect/debris/cleanable/greenglow
	name = "glowing goo"
	desc = "Jeez. I hope that's not for lunch."
	gender = PLURAL
	density = 0
	anchored = 1
	light_range = 1
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenglow"

/obj/effect/debris/cleanable/cobweb
	name = "cobweb"
	desc = "Somebody should remove that."
	density = 0
	anchored = 1
	plane = OBJ_PLANE
	icon = 'icons/effects/effects.dmi'
	icon_state = "cobweb1"

/obj/effect/debris/cleanable/molten_item
	name = "gooey grey mass"
	desc = "It looks like a melted... something."
	density = 0
	anchored = 1
	plane = OBJ_PLANE
	icon = 'icons/obj/chemical.dmi'
	icon_state = "molten"

/obj/effect/debris/cleanable/cobweb2
	name = "cobweb"
	desc = "Somebody should remove that."
	density = 0
	anchored = 1
	plane = OBJ_PLANE
	icon = 'icons/effects/effects.dmi'
	icon_state = "cobweb2"

//Vomit (sorry)
/obj/effect/debris/cleanable/vomit
	name = "vomit"
	desc = "Gosh, how unpleasant."
	gender = PLURAL
	density = 0
	anchored = 1
	icon = 'icons/effects/blood.dmi'
	icon_state = "vomit_1"
	random_icon_states = list("vomit_1", "vomit_2", "vomit_3", "vomit_4")
	var/list/datum/disease2/disease/virus2 = list()

/obj/effect/debris/cleanable/tomato_smudge
	name = "tomato smudge"
	desc = "It's red."
	density = 0
	anchored = 1
	icon = 'icons/effects/tomatodecal.dmi'
	random_icon_states = list("tomato_floor1", "tomato_floor2", "tomato_floor3")

/obj/effect/debris/cleanable/egg_smudge
	name = "smashed egg"
	desc = "Seems like this one won't hatch."
	density = 0
	anchored = 1
	icon = 'icons/effects/tomatodecal.dmi'
	random_icon_states = list("smashed_egg1", "smashed_egg2", "smashed_egg3")

/obj/effect/debris/cleanable/pie_smudge //honk
	name = "smashed pie"
	desc = "It's pie cream from a cream pie."
	density = 0
	anchored = 1
	icon = 'icons/effects/tomatodecal.dmi'
	random_icon_states = list("smashed_pie")

/obj/effect/debris/cleanable/fruit_smudge
	name = "smudge"
	desc = "Some kind of fruit smear."
	density = 0
	anchored = 1
	icon = 'icons/effects/blood.dmi'
	icon_state = "mfloor1"
	random_icon_states = list("mfloor1", "mfloor2", "mfloor3", "mfloor4", "mfloor5", "mfloor6", "mfloor7")
