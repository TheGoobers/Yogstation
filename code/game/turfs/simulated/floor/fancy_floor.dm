/* In this file:
 * Wood floor
 * Grass floor
 * Fake Basalt
 * Carpet floor
 * Fake pits
 * Fake space
 */

/turf/open/floor/wood
	desc = "Stylish dark wood."
	icon_state = "wood"
	floor_tile = /obj/item/stack/tile/wood
	broken_states = list("wood-broken", "wood-broken2", "wood-broken3", "wood-broken4", "wood-broken5", "wood-broken6", "wood-broken7")
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_WOOD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	flags_1 = NO_RUST | CAN_BE_DIRTY_1
	flammability = 3 // yikes, better put that out quick

/turf/open/floor/wood/examine(mob/user)
	. = ..()
	. += span_notice("There's a few <b>screws</b> and a <b>small crack</b> visible.")

/turf/open/floor/wood/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	return pry_tile(I, user)

/turf/open/floor/wood/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	if(T.turf_type == type)
		return
	var/obj/item/tool = user.is_holding_item_of_type(/obj/item/screwdriver)
	if(!tool)
		tool = user.is_holding_item_of_type(/obj/item/crowbar)
	if(!tool)
		return
	var/turf/open/floor/plating/P = pry_tile(tool, user, TRUE)
	if(!istype(P))
		return
	P.attackby(T, user, params)

/turf/open/floor/wood/pry_tile(obj/item/C, mob/user, silent = FALSE)
	C.play_tool_sound(src, 80)
	return remove_tile(user, silent, (C.tool_behaviour == TOOL_SCREWDRIVER))

/turf/open/floor/wood/remove_tile(mob/user, silent = FALSE, make_tile = TRUE)
	if(broken || burnt)
		broken = 0
		burnt = 0
		if(user && !silent)
			to_chat(user, span_notice("You remove the broken planks."))
	else
		if(make_tile)
			if(user && !silent)
				to_chat(user, span_notice("You unscrew the planks."))
			if(floor_tile)
				new floor_tile(src)
		else
			if(user && !silent)
				to_chat(user, span_notice("You forcefully pry off the planks, destroying them in the process."))
	return make_plating()

/turf/open/floor/wood/cold
	initial_gas_mix = KITCHEN_COLDROOM_ATMOS

/turf/open/floor/wood/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/wood/lavaland
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS

/turf/open/floor/wood/broken
	icon_state = "wood-broken"
	broken = TRUE

/turf/open/floor/wood/broken/two
	icon_state = "wood-broken2"

/turf/open/floor/wood/broken/three
	icon_state = "wood-broken3"

/turf/open/floor/wood/broken/four
	icon_state = "wood-broken4"

/turf/open/floor/wood/broken/five
	icon_state = "wood-broken5"

/turf/open/floor/wood/broken/six
	icon_state = "wood-broken6"

/turf/open/floor/wood/broken/seven
	icon_state = "wood-broken7"

/turf/open/floor/wood/lavaland/broken
	icon_state = "wood-broken"
	broken = TRUE

/turf/open/floor/wood/lavaland/broken/two
	icon_state = "wood-broken2"

/turf/open/floor/wood/lavaland/broken/three
	icon_state = "wood-broken3"

/turf/open/floor/wood/lavaland/broken/four
	icon_state = "wood-broken4"

/turf/open/floor/wood/lavaland/broken/five
	icon_state = "wood-broken5"

/turf/open/floor/wood/lavaland/broken/six
	icon_state = "wood-broken6"

/turf/open/floor/wood/lavaland/broken/seven
	icon_state = "wood-broken7"

/turf/open/floor/wood/airless/broken
	icon_state = "wood-broken"
	broken = TRUE

/turf/open/floor/wood/airless/broken/two
	icon_state = "wood-broken2"

/turf/open/floor/wood/airless/broken/three
	icon_state = "wood-broken3"

/turf/open/floor/wood/airless/broken/four
	icon_state = "wood-broken4"

/turf/open/floor/wood/airless/broken/five
	icon_state = "wood-broken5"

/turf/open/floor/wood/airless/broken/six
	icon_state = "wood-broken6"

/turf/open/floor/wood/airless/broken/seven
	icon_state = "wood-broken7"

/turf/open/floor/wood/cold/broken
	icon_state = "wood-broken"
	broken = TRUE

/turf/open/floor/wood/cold/broken/two
	icon_state = "wood-broken2"

/turf/open/floor/wood/cold/broken/three
	icon_state = "wood-broken3"

/turf/open/floor/wood/cold/broken/four
	icon_state = "wood-broken4"

/turf/open/floor/wood/cold/broken/five
	icon_state = "wood-broken5"

/turf/open/floor/wood/cold/broken/six
	icon_state = "wood-broken6"

/turf/open/floor/wood/cold/broken/seven
	icon_state = "wood-broken7"

/turf/open/floor/bamboo
	desc = "A bamboo mat with a decorative trim."
	icon = 'icons/turf/floors/bamboo_mat.dmi'
	icon_state = "bamboo"
	floor_tile = /obj/item/stack/tile/bamboo
	broken_states = list("damaged")
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/bamboo)
	flags_1 = NONE
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_WOOD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE

/turf/open/floor/bamboo/broken
	icon_state = "damaged"
	broken = TRUE

/turf/open/floor/grass
	name = "grass patch"
	desc = "You can't tell if this is real grass or just cheap plastic imitation."
	icon_state = "grass1"
	floor_tile = /obj/item/stack/tile/grass
	broken_states = list("sand")
	flags_1 = NONE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_GRASS
	clawfootstep = FOOTSTEP_GRASS
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	var/ore_type = /obj/item/stack/ore/glass
	var/turfverb = "uproot"
	tiled_dirt = FALSE
	flammability = 2 // california simulator

/turf/open/floor/grass/Initialize(mapload)
	. = ..()
	if(src.type == /turf/open/floor/grass) //don't want grass subtypes getting the icon state,
		icon_state = "grass[rand(1,4)]"
		update_appearance(UPDATE_ICON)

/turf/open/floor/grass/attackby(obj/item/C, mob/user, params)
	if((C.tool_behaviour == TOOL_SHOVEL) && params)
		new ore_type(src, 2)
		user.visible_message("[user] digs up [src].", span_notice("You [turfverb] [src]."))
		playsound(src, 'sound/effects/shovel_dig.ogg', 50, 1)
		make_plating()
	if(..())
		return

/turf/open/floor/grass/snow
	gender = PLURAL
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	desc = "Looks cold."
	icon_state = "snow"
	ore_type = /obj/item/stack/sheet/mineral/snow
	planetary_atmos = TRUE
	floor_tile = null
	initial_gas_mix = FROZEN_ATMOS
	bullet_sizzle = TRUE
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	flammability = -5 // negative flammability, makes fires deplete much faster

/turf/open/floor/grass/snow/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return

/turf/open/floor/grass/snow/crowbar_act(mob/living/user, obj/item/I)
	return

/turf/open/floor/grass/snow/basalt //By your powers combined, I am captain planet
	gender = NEUTER
	name = "volcanic floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "basalt"
	ore_type = /obj/item/stack/ore/glass/basalt
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	slowdown = 0

/turf/open/floor/grass/snow/basalt/Initialize(mapload)
	. = ..()
	if(prob(15))
		icon_state = "basalt[rand(0, 12)]"
		set_basalt_light(src)

/turf/open/floor/grass/snow/safe
	planetary_atmos = FALSE


/turf/open/floor/grass/fakebasalt //Heart is not a real planeteer power
	name = "aesthetic volcanic flooring"
	desc = "Safely recreated turf for your hellplanet-scaping."
	icon = 'icons/turf/floors.dmi'
	icon_state = "basalt"
	floor_tile = /obj/item/stack/tile/basalt
	ore_type = /obj/item/stack/ore/glass/basalt
	turfverb = "dig up"
	slowdown = 0
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/grass/fakebasalt/Initialize(mapload)
	. = ..()
	if(prob(15))
		icon_state = "basalt[rand(0, 12)]"
		set_basalt_light(src)


/turf/open/floor/carpet
	name = "carpet"
	desc = "Soft velvet carpeting. Feels good between your toes."
	icon = 'icons/turf/floors/carpet.dmi'
	icon_state = "carpet"
	floor_tile = /obj/item/stack/tile/carpet
	broken_states = list("damaged")
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/carpet)
	flags_1 = NONE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_CARPET
	barefootstep = FOOTSTEP_CARPET_BAREFOOT
	clawfootstep = FOOTSTEP_CARPET_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	flammability = 3 // this will be abused and i am all for it

/turf/open/floor/carpet/examine(mob/user)
	. = ..()
	. += span_notice("There's a <b>small crack</b> on the edge of it.")

/turf/open/floor/carpet/Initialize(mapload)
	. = ..()
	update_appearance(UPDATE_ICON)

/turf/open/floor/carpet/update_icon(updates=ALL)
	. = ..()
	if(!.)
		return 0
	if(!broken && !burnt)
		if(smooth)
			queue_smooth(src)
	else
		make_plating()
		if(smooth)
			queue_smooth_neighbors(src)

/turf/open/floor/carpet/broken
	icon_state = "damaged"
	broken = TRUE

/turf/open/floor/carpet/black
	icon = 'icons/turf/floors/carpet_black.dmi'
	floor_tile = /obj/item/stack/tile/carpet/black
	canSmoothWith = list(/turf/open/floor/carpet/black)

/turf/open/floor/carpet/black/broken
	icon_state = "damaged"
	broken = TRUE

/turf/open/floor/carpet/exoticblue
	icon = 'icons/turf/floors/carpet_exoticblue.dmi'
	floor_tile = /obj/item/stack/tile/carpet/exoticblue
	canSmoothWith = list(/turf/open/floor/carpet/exoticblue)

/turf/open/floor/carpet/exoticblue/broken
	icon_state = "damaged"
	broken = TRUE

/turf/open/floor/carpet/cyan
	icon = 'icons/turf/floors/carpet_cyan.dmi'
	floor_tile = /obj/item/stack/tile/carpet/cyan
	canSmoothWith = list(/turf/open/floor/carpet/cyan)

/turf/open/floor/carpet/cyan/broken
	icon_state = "damaged"
	broken = TRUE

/turf/open/floor/carpet/exoticgreen
	icon = 'icons/turf/floors/carpet_exoticgreen.dmi'
	floor_tile = /obj/item/stack/tile/carpet/exoticgreen
	canSmoothWith = list(/turf/open/floor/carpet/exoticgreen)

/turf/open/floor/carpet/exoticgreen/broken
	icon_state = "damaged"
	broken = TRUE

/turf/open/floor/carpet/orange
	icon = 'icons/turf/floors/carpet_orange.dmi'
	floor_tile = /obj/item/stack/tile/carpet/orange
	canSmoothWith = list(/turf/open/floor/carpet/orange)

/turf/open/floor/carpet/orange/broken
	icon_state = "damaged"
	broken = TRUE

/turf/open/floor/carpet/exoticpurple
	icon = 'icons/turf/floors/carpet_exoticpurple.dmi'
	floor_tile = /obj/item/stack/tile/carpet/exoticpurple
	canSmoothWith = list(/turf/open/floor/carpet/exoticpurple)

/turf/open/floor/carpet/exoticpurple/broken
	icon_state = "damaged"
	broken = TRUE

/turf/open/floor/carpet/red
	icon = 'icons/turf/floors/carpet_red.dmi'
	floor_tile = /obj/item/stack/tile/carpet/red
	canSmoothWith = list(/turf/open/floor/carpet/red)

/turf/open/floor/carpet/red/broken
	icon_state = "damaged"
	broken = TRUE

/turf/open/floor/carpet/royalblack
	icon = 'icons/turf/floors/carpet_royalblack.dmi'
	floor_tile = /obj/item/stack/tile/carpet/royalblack
	canSmoothWith = list(/turf/open/floor/carpet/royalblack)

/turf/open/floor/carpet/royalblack/broken
	icon_state = "damaged"
	broken = TRUE

/turf/open/floor/carpet/royalblue
	icon = 'icons/turf/floors/carpet_royalblue.dmi'
	floor_tile = /obj/item/stack/tile/carpet/royalblue
	canSmoothWith = list(/turf/open/floor/carpet/royalblue)

/turf/open/floor/carpet/royalblue/broken
	icon_state = "damaged"
	broken = TRUE

/turf/open/floor/carpet/narsie_act(force, ignore_mobs, probability = 20)
	. = (prob(probability) || force)
	for(var/I in src)
		var/atom/A = I
		if(ignore_mobs && ismob(A))
			continue
		if(ismob(A) || .)
			A.narsie_act()

/turf/open/floor/carpet/break_tile()
	broken = TRUE
	update_appearance(UPDATE_ICON)

/turf/open/floor/carpet/burn_tile()
	burnt = TRUE
	update_appearance(UPDATE_ICON)

/turf/open/floor/carpet/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	return FALSE


/turf/open/floor/fakepit
	desc = "A clever illusion designed to look like a bottomless pit."
	smooth = SMOOTH_TRUE | SMOOTH_BORDER | SMOOTH_MORE
	canSmoothWith = list(/turf/open/floor/fakepit)
	icon = 'icons/turf/floors/Chasms.dmi'
	icon_state = "smooth"
	tiled_dirt = FALSE

/turf/open/floor/fakepit/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = 'icons/turf/floors.dmi'
	underlay_appearance.icon_state = "basalt"
	return TRUE

/turf/open/floor/fakespace
	icon = 'icons/turf/space.dmi'
	icon_state = "0"
	floor_tile = /obj/item/stack/tile/fakespace
	broken_states = list("damaged")
	plane = PLANE_SPACE
	tiled_dirt = FALSE

/turf/open/floor/fakespace/Initialize(mapload)
	. = ..()
	icon_state = SPACE_ICON_STATE

/turf/open/floor/fakespace/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = 'icons/turf/space.dmi'
	underlay_appearance.icon_state = SPACE_ICON_STATE
	underlay_appearance.plane = PLANE_SPACE
	return TRUE
