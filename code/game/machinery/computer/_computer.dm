/obj/machinery/computer
	name = "computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 300
	active_power_usage = 300
	max_integrity = 200
	integrity_failure = 100
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 40, ACID = 20)
	clicksound = "keyboard"
	light_system = STATIC_LIGHT
	light_range = 2
	light_power = 1
	light_on = TRUE
	var/icon_keyboard = "generic_key"
	var/icon_screen = "generic"
	var/clockwork = FALSE
	var/time_to_scewdrive = 20
	var/authenticated = FALSE

/obj/machinery/computer/Initialize(mapload, obj/item/circuitboard/C)
	. = ..()
	if(mapload)
		update_appearance(UPDATE_ICON)
	power_change()
	if(!QDELETED(C))
		qdel(circuit)
		circuit = C
		C.moveToNullspace()

/obj/machinery/computer/Destroy()
	QDEL_NULL(circuit)
	return ..()

/obj/machinery/computer/process()
	if(stat & (NOPOWER|BROKEN))
		return 0
	return 1

/obj/machinery/computer/ratvar_act()
	if(!clockwork)
		clockwork = TRUE
		icon_screen = "ratvar[rand(1, 4)]"
		icon_keyboard = "ratvar_key[rand(1, 6)]"
		icon_state = "ratvarcomputer[rand(1, 4)]"
		update_appearance(UPDATE_ICON)

/obj/machinery/computer/narsie_act()
	if(clockwork && clockwork != initial(clockwork)) //if it's clockwork but isn't normally clockwork
		clockwork = FALSE
		icon_screen = initial(icon_screen)
		icon_keyboard = initial(icon_keyboard)
		icon_state = initial(icon_state)
		update_appearance(UPDATE_ICON)

/obj/machinery/computer/update_appearance(updates)
	. = ..()
	//Prevents fuckery with subtypes that are meant to be pixel shifted or map shifted shit
	if(pixel_x == 0 && pixel_y == 0)
		// this bit of code makes the computer hug the wall its next to
		var/turf/T = get_turf(src)
		var/list/offet_matrix = list(0, 0)		// stores offset to be added to the console in following order (pixel_x, pixel_y)
		var/dirlook
		switch(dir)
			if(NORTH)
				offet_matrix[2] = -3
				dirlook = SOUTH
			if(SOUTH)
				offet_matrix[2] = 1
				dirlook = NORTH
			if(EAST)
				offet_matrix[1] = -5
				dirlook = WEST
			if(WEST)
				offet_matrix[1] = 5
				dirlook = EAST
		if(dirlook)
			T = get_step(T, dirlook)
			var/obj/structure/window/W = locate() in T
			if(istype(T, /turf/closed/wall) || W)
				pixel_x = offet_matrix[1]
				pixel_y = offet_matrix[2]


/obj/machinery/computer/update_overlays()
	. = ..()
	if(stat & NOPOWER)
		. += "[icon_keyboard]_off"
		return
	. += icon_keyboard

	// This whole block lets screens ignore lighting and be visible even in the darkest room
	var/overlay_state = icon_screen
	if(stat & BROKEN)
		overlay_state = "[icon_state]_broken"
	. += mutable_appearance(icon, overlay_state)
	. += mutable_appearance(icon, overlay_state, layer, EMISSIVE_PLANE)

/obj/machinery/computer/power_change()
	. = ..()
	if(!.)
		return // reduce unneeded light changes
	if(stat & NOPOWER)
		set_light(FALSE)
	else
		set_light(TRUE)

/obj/machinery/computer/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	if(circuit && !(flags_1&NODECONSTRUCT_1))
		to_chat(user, span_notice("You start to disconnect the monitor..."))
		if(I.use_tool(src, user, time_to_scewdrive, volume=50))
			deconstruct(TRUE, user)
	return TRUE


/obj/machinery/computer/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(stat & BROKEN)
				playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
			else
				playsound(src.loc, 'sound/effects/glasshit.ogg', 75, 1)
		if(BURN)
			playsound(src.loc, 'sound/items/welder.ogg', 100, 1)

/obj/machinery/computer/obj_break(damage_flag)
	if(!circuit) //no circuit, no breaking
		return
	. = ..()
	if(.)
		playsound(loc, 'sound/effects/glassbr3.ogg', 100, TRUE)
		set_light(0)

/obj/machinery/computer/emp_act(severity)
	. = ..()
	if (!(. & EMP_PROTECT_SELF))
		switch(severity)
			if(1)
				if(prob(50))
					obj_break(ENERGY)
			if(2)
				if(prob(10))
					obj_break(ENERGY)

/obj/machinery/computer/deconstruct(disassembled = TRUE, mob/user)
	on_deconstruction()
	if(!(flags_1 & NODECONSTRUCT_1))
		if(circuit) //no circuit, no computer frame
			var/obj/structure/frame/computer/A = new /obj/structure/frame/computer(src.loc)
			A.setDir(dir)
			A.circuit = circuit
			A.setAnchored(TRUE)
			if(stat & BROKEN)
				if(user)
					to_chat(user, span_notice("The broken glass falls out."))
				else
					playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
				new /obj/item/shard(drop_location())
				new /obj/item/shard(drop_location())
				A.state = 3
				A.icon_state = "3"
			else
				if(user)
					to_chat(user, span_notice("You disconnect the monitor."))
				A.state = 4
				A.icon_state = "4"
			circuit = null
		for(var/obj/C in src)
			C.forceMove(loc)
	qdel(src)

/obj/machinery/computer/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(istype(mover) && (mover.pass_flags & PASSCOMPUTER))
		return TRUE
