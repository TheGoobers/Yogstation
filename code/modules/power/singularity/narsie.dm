/obj/singularity/narsie //Moving narsie to a child object of the singularity so it can be made to function differently. --NEO
	name = "Nar'sie's Avatar"
	desc = "Your mind begins to bubble and ooze as it tries to comprehend what it sees."
	icon = 'icons/obj/magic_terror.dmi'
	pixel_x = -89
	pixel_y = -85
	density = FALSE
	current_size = 9 //It moves/eats like a max-size singulo, aside from range. --NEO
	contained = 0 //Are we going to move around?
	dissipate = 0 //Do we lose energy over time?
	move_self = 1 //Do we move on our own?
	grav_pull = 5 //How many tiles out do we pull?
	consume_range = 6 //How many tiles out do we eat
	light_power = 0.7
	light_range = 15
	light_color = rgb(255, 0, 0)
	gender = FEMALE
	does_targeting = FALSE
	var/clashing = FALSE //If Nar'sie is fighting Ratvar

/obj/singularity/narsie/large
	name = "Nar'sie"
	icon = 'icons/obj/narsie.dmi'
	// Pixel stuff centers Nar'sie.
	pixel_x = -236
	pixel_y = -256
	current_size = 12
	grav_pull = 10
	consume_range = 12 //How many tiles out do we eat

/obj/singularity/narsie/large/Initialize(mapload)
	. = ..()
	send_to_playing_players(span_narsie("NAR-SIE HAS RISEN"))
	sound_to_playing_players('sound/creatures/narsie_rises.ogg')

	var/area/A = get_area(src)
	if(A)
		var/mutable_appearance/alert_overlay = mutable_appearance('icons/effects/cult_effects.dmi', "ghostalertsie")
		notify_ghosts("Nar'sie has risen in \the [A.name]. Reach out to the Geometer to be given a new shell for your soul.", source = src, alert_overlay = alert_overlay, action=NOTIFY_ATTACK)
	INVOKE_ASYNC(src, PROC_REF(narsie_spawn_animation))

/obj/singularity/narsie/large/cult  // For the new cult ending, guaranteed to end the round within 3 minutes
	var/list/souls_needed = list()
	var/soul_goal = 0
	var/souls = 0
	var/resolved = FALSE

/obj/singularity/narsie/large/cult/Initialize(mapload)
	. = ..()
	GLOB.cult_narsie = src
	var/list/all_cults = list()
	for(var/datum/antagonist/cult/C in GLOB.antagonists)
		if(!C.owner)
			continue
		all_cults |= C.cult_team
	for(var/datum/team/cult/T in all_cults)
		deltimer(T.blood_target_reset_timer)
		T.blood_target = src
		var/datum/objective/eldergod/summon_objective = locate() in T.objectives
		if(summon_objective)
			summon_objective.summoned = TRUE
	for(var/datum/mind/cult_mind in SSticker.mode.cult)
		if(isliving(cult_mind.current))
			var/mob/living/L = cult_mind.current
			L.narsie_act()
	for(var/mob/living/player in GLOB.player_list)
		if(player.stat != DEAD && player.loc && is_station_level(player.loc.z) && !iscultist(player) && !isanimal(player))
			souls_needed[player] = TRUE

	//nar nar attracts the singularity for more epic gamer engineer moments
	for(var/obj/singularity/singulo in GLOB.singularities)
		if(singulo.z == z)
			singulo.target = src
	
	soul_goal = round(1 + LAZYLEN(souls_needed) * 0.75)
	INVOKE_ASYNC(GLOBAL_PROC, PROC_REF(begin_the_end))

/proc/begin_the_end()
	ending_helper()
	if(QDELETED(GLOB.cult_narsie)) // uno
		priority_announce("Status report? We detected a anomaly, but it disappeared almost immediately.","Central Command Higher Dimensional Affairs", 'sound/misc/notice1.ogg')
		GLOB.cult_narsie = null
		sleep(20)
		INVOKE_ASYNC(GLOBAL_PROC, PROC_REF(cult_ending_helper), 2)
		return
	sleep(5 SECONDS)
	priority_announce("An acausal dimensional event has been detected in your sector. Event has been flagged EXTINCTION-CLASS. Directing all available assets toward simulating solutions. SOLUTION ETA: 30 SECONDS.","Central Command Higher Dimensional Affairs", 'sound/misc/airraid.ogg')
	sleep(30 SECONDS)
	if(QDELETED(GLOB.cult_narsie)) // dos
		priority_announce("Termination of event has been detected. Please note that further damage to company property or wastage of company resources will not be tolerated.","Central Command Higher Dimensional Affairs", 'sound/misc/notice1.ogg')
		GLOB.cult_narsie = null
		sleep(20)
		INVOKE_ASYNC(GLOBAL_PROC, PROC_REF(cult_ending_helper), 2)
		return
	priority_announce("Simulations on acausal dimensional event complete. Deploying solution package now. Deployment ETA: 30 SECONDS.","Central Command Higher Dimensional Affairs")
	sleep(5 SECONDS)
	set_security_level("delta")
	SSshuttle.registerHostileEnvironment(GLOB.cult_narsie)
	SSshuttle.lockdown = TRUE
	sleep(25 SECONDS)
	if(QDELETED(GLOB.cult_narsie)) // tres
		priority_announce("Nuclear detonation has been aborted due to termination of event. Please note that further damage to corporate property will not be tolerated.","Central Command Higher Dimensional Affairs", 'sound/misc/notice1.ogg')
		GLOB.cult_narsie = null
		sleep(2 SECONDS)
		set_security_level("red")
		SSshuttle.clearHostileEnvironment()
		SSshuttle.lockdown = FALSE
		INVOKE_ASYNC(GLOBAL_PROC, PROC_REF(cult_ending_helper), 2)
		return
	if(GLOB.cult_narsie.resolved == FALSE)
		GLOB.cult_narsie.resolved = TRUE
		sound_to_playing_players('sound/machines/alarm.ogg')
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cult_ending_helper)), 12 SECONDS)

/obj/singularity/narsie/large/cult/Destroy()
	send_to_playing_players("<span class='narsie'>\"<b>[pick("Nooooo...", "Not die. How-", "Die. Mort-", "Sas tyen re-")]\"</b></span>")
	sound_to_playing_players('sound/magic/demon_dies.ogg', 50)
	var/list/all_cults = list()
	for(var/datum/antagonist/cult/C in GLOB.antagonists)
		if(!C.owner)
			continue
		all_cults |= C.cult_team
	for(var/datum/team/cult/T in all_cults)
		var/datum/objective/eldergod/summon_objective = locate() in T.objectives
		if(summon_objective)
			summon_objective.summoned = FALSE
			summon_objective.killed = TRUE
	return ..()

/proc/ending_helper()
	SSticker.force_ending = 1

/proc/cult_ending_helper(ending_type = 0)
	if(ending_type == 2) //narsie fukkin died
		Cinematic(CINEMATIC_CULT_FAIL,world,CALLBACK(GLOBAL_PROC,GLOBAL_PROC_REF(ending_helper)))
	else if(ending_type) //no explosion
		Cinematic(CINEMATIC_CULT,world,CALLBACK(GLOBAL_PROC,GLOBAL_PROC_REF(ending_helper)))
	else // explosion
		Cinematic(CINEMATIC_CULT_NUKE,world,CALLBACK(GLOBAL_PROC,GLOBAL_PROC_REF(ending_helper)))



//ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/singularity/narsie/large/attack_ghost(mob/dead/observer/user as mob)
	makeNewConstruct(/mob/living/simple_animal/hostile/construct/harvester, user, cultoverride = TRUE, loc_override = src.loc)

/obj/singularity/narsie/process()
	if(clashing)
		return
	eat()
	if(!target || prob(5))
		pickcultist()
	if(istype(target, /obj/structure/destructible/clockwork/massive/ratvar))
		move(get_dir(src, target)) //Oh, it's you again.
	else
		move()
	if(prob(25))
		mezzer()


/obj/singularity/narsie/Process_Spacemove()
	return clashing


/obj/singularity/narsie/Bump(atom/A)
	var/turf/T = get_turf(A)
	if(T == loc)
		T = get_step(A, A.dir) //please don't slam into a window like a bird, Nar'sie
	forceMove(T)


/obj/singularity/narsie/mezzer()
	for(var/mob/living/carbon/M in viewers(consume_range, src))
		if(M.stat == CONSCIOUS)
			if(!iscultist(M))
				to_chat(M, span_cultsmall("You feel conscious thought crumble away in an instant as you gaze upon [src.name]..."))
				M.apply_effect(6 SECONDS, EFFECT_STUN)


/obj/singularity/narsie/consume(atom/A)
	if(isturf(A))
		A.narsie_act()


/obj/singularity/narsie/ex_act() //No throwing bombs at her either.
	return


/obj/singularity/narsie/proc/pickcultist() //Nar'sie rewards her cultists with being devoured first, then picks a ghost to follow.
	var/list/cultists = list()
	var/list/noncultists = list()
	for(var/obj/structure/destructible/clockwork/massive/ratvar/enemy in GLOB.poi_list) //Prioritize killing Ratvar
		if(enemy.z != z)
			continue
		acquire(enemy)
		return

	for(var/mob/living/carbon/food in GLOB.alive_mob_list) //we don't care about constructs or cult-Ians or whatever. cult-monkeys are fair game i guess
		var/turf/pos = get_turf(food)
		if(!pos || (pos.z != z))
			continue

		if(iscultist(food))
			cultists += food
		else
			noncultists += food

		if(cultists.len) //cultists get higher priority
			acquire(pick(cultists))
			return

		if(noncultists.len)
			acquire(pick(noncultists))
			return

	//no living humans, follow a ghost instead.
	for(var/mob/dead/observer/ghost in GLOB.player_list)
		if(!ghost.client)
			continue
		var/turf/pos = get_turf(ghost)
		if(!pos || (pos.z != z))
			continue
		cultists += ghost
	if(cultists.len)
		acquire(pick(cultists))
		return


/obj/singularity/narsie/proc/acquire(atom/food)
	if(food == target)
		return
	to_chat(target, span_cultsmall("NAR-SIE HAS LOST INTEREST IN YOU."))
	target = food
	if(ishuman(target))
		to_chat(target, "<span class ='cult'>NAR-SIE HUNGERS FOR YOUR SOUL.</span>")
	else
		to_chat(target, "<span class ='cult'>NAR-SIE HAS CHOSEN YOU TO LEAD HER TO HER NEXT MEAL.</span>")

//Wizard narsie
/obj/singularity/narsie/wizard
	grav_pull = 0

/obj/singularity/narsie/wizard/eat()
//	if(defer_powernet_rebuild != 2)
//		defer_powernet_rebuild = 1
	for(var/atom/X in urange(consume_range,src,1))
		if(isturf(X) || ismovable(X))
			consume(X)
//	if(defer_powernet_rebuild != 2)
//		defer_powernet_rebuild = 0
	return


/obj/singularity/narsie/proc/narsie_spawn_animation()
	icon = 'icons/obj/narsie_spawn_anim.dmi'
	setDir(SOUTH)
	move_self = 0
	flick("narsie_spawn_anim",src)
	sleep(1.1 SECONDS)
	move_self = 1
	icon = initial(icon)



