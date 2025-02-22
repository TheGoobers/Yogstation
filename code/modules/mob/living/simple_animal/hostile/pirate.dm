/mob/living/simple_animal/hostile/pirate
	name = "Pirate"
	desc = "Does what he wants cause a pirate is free."
	icon = 'icons/mob/simple_human.dmi'
	icon_state = "piratemelee"
	icon_living = "piratemelee"
	icon_dead = "pirate_dead"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	speak_chance = 0
	turns_per_move = 5
	response_help = "pushes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 0
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = "punches"
	attack_sound = 'sound/weapons/punch1.ogg'
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 15
	speak_emote = list("yarrs")
	loot = list(/obj/effect/mob_spawn/human/corpse/pirate,
			/obj/item/melee/cutlass)
	del_on_death = 1
	faction = list("pirate")

/mob/living/simple_animal/hostile/pirate/sentience_act()
	faction -= "pirate"

/mob/living/simple_animal/hostile/pirate/melee
	name = "Pirate Swashbuckler"
	icon_state = "piratemelee"
	icon_living = "piratemelee"
	icon_dead = "piratemelee_dead"
	melee_damage_lower = 30
	melee_damage_upper = 30
	armour_penetration = 35
	attack_vis_effect = ATTACK_EFFECT_SLASH
	attacktext = "slashes"
	attack_sound = 'sound/weapons/rapierhit.ogg'

	do_footstep = TRUE
 
/mob/living/simple_animal/hostile/pirate/melee/space
	name = "Space Pirate Swashbuckler"
	icon_state = "piratespace"
	icon_living = "piratespace"
	icon_dead = "piratespace_dead"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	speed = 1
	spacewalk = TRUE

/mob/living/simple_animal/hostile/pirate/ranged
	name = "Pirate Gunner"
	icon_state = "pirateranged"
	icon_living = "pirateranged"
	icon_dead = "pirateranged_dead"
	projectilesound = 'sound/weapons/laser.ogg'
	ranged = 1
	rapid = 2
	rapid_fire_delay = 6
	retreat_distance = 5
	minimum_distance = 5
	projectiletype = /obj/projectile/beam/laser
	loot = list(/obj/effect/mob_spawn/human/corpse/pirate/ranged)

/mob/living/simple_animal/hostile/pirate/ranged/space
	name = "Space Pirate Gunner"
	icon_state = "piratespaceranged"
	icon_living = "piratespaceranged"
	icon_dead = "piratespaceranged_dead"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	speed = 1
	spacewalk = TRUE
