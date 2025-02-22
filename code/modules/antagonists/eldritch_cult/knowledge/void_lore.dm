/datum/eldritch_knowledge/base_void
	name = "Glimmer of Winter"
	desc = "Pledges yourself to the path of the Void. Allows you to transmute a stuff with a knife or its derivatives into a void blade. Additionally, empowers your Mansus grasp to chill any target hit."
	gain_text = "Wanting, I lie, too weary to die, too lost to the ice for saving. My sins claim me, untame me"
	banned_knowledge = list(
		/datum/eldritch_knowledge/base_ash,
		/datum/eldritch_knowledge/base_rust,
		/datum/eldritch_knowledge/base_flesh,
		/datum/eldritch_knowledge/base_mind,
		/datum/eldritch_knowledge/base_blade,
		/datum/eldritch_knowledge/base_cosmic,
		/datum/eldritch_knowledge/ash_mark,
		/datum/eldritch_knowledge/rust_mark,
		/datum/eldritch_knowledge/flesh_mark,
		/datum/eldritch_knowledge/mind_mark,
		/datum/eldritch_knowledge/blade_mark,
		/datum/eldritch_knowledge/cosmic_mark,
		/datum/eldritch_knowledge/ash_blade_upgrade,
		/datum/eldritch_knowledge/rust_blade_upgrade,
		/datum/eldritch_knowledge/flesh_blade_upgrade,
		/datum/eldritch_knowledge/mind_blade_upgrade,
		/datum/eldritch_knowledge/blade_blade_upgrade,
		/datum/eldritch_knowledge/cosmic_blade_upgrade,
		/datum/eldritch_knowledge/ash_final,
		/datum/eldritch_knowledge/rust_final,
		/datum/eldritch_knowledge/flesh_final,
		/datum/eldritch_knowledge/mind_final,
		/datum/eldritch_knowledge/blade_final,
		/datum/eldritch_knowledge/cosmic_final)
	unlocked_transmutations = list(/datum/eldritch_transmutation/void_knife)
	cost = 1
	route = PATH_VOID
	tier = TIER_PATH

/datum/eldritch_knowledge/base_void/on_gain(mob/user)
	. = ..()
	var/obj/realknife = new /obj/item/melee/sickly_blade/void
	user.put_in_hands(realknife)
	RegisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK, PROC_REF(on_mansus_grasp))

/datum/eldritch_knowledge/base_void/on_lose(mob/user)
	UnregisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK)

/datum/eldritch_knowledge/base_void/proc/on_mansus_grasp(mob/living/source, mob/living/target)
	SIGNAL_HANDLER

	if(!iscarbon(target))
		return COMPONENT_BLOCK_HAND_USE
	var/mob/living/carbon/carbon_target = target
	carbon_target.adjust_silence(10 SECONDS)
	carbon_target.apply_status_effect(/datum/status_effect/void_chill)

/datum/eldritch_knowledge/base_void/on_eldritch_blade(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/datum/status_effect/eldritch/E = H.has_status_effect(/datum/status_effect/eldritch/rust) || H.has_status_effect(/datum/status_effect/eldritch/ash) || H.has_status_effect(/datum/status_effect/eldritch/flesh) || H.has_status_effect(/datum/status_effect/eldritch/void) || H.has_status_effect(/datum/status_effect/eldritch/cosmic)
		if(E)
			E.on_effect()
			H.adjust_silence(10)
			H.adjust_bodytemperature(-10)

/datum/eldritch_knowledge/spell/void_phase
	name = "T1 - Void Phase"
	gain_text = "The entity calls themself the Aristocrat. They effortlessly walk through air like \
		nothing - leaving a harsh, cold breeze in their wake. They disappear, and I am left in the blizzard."
	desc = "Grants you Void Phase, a long range targeted teleport spell. \
		Additionally causes damage to heathens around your original and target destination."
	cost = 1
	spell_to_add = /datum/action/cooldown/spell/pointed/void_phase
	banned_knowledge = list(
		/datum/eldritch_knowledge/spell/mental_obfuscation)
	route = PATH_VOID
	tier = TIER_1

/datum/eldritch_knowledge/void_cloak
	name = "T1 - Void Cloak"
	gain_text = "The Owl is the keeper of things that are not quite in practice, but in theory are. Many things are."
	desc = "Allows you to transmute a glass shard, a bedsheet, and any outer clothing item (such as armor or a suit jacket) \
		to create a Void Cloak. This cloak will make the wearer partially invisible over time, and allow them to temporarily dodge attacks."
	unlocked_transmutations = list(/datum/eldritch_transmutation/void_cloak)
	cost = 1
	tier = TIER_1

/datum/eldritch_knowledge/void_mark
	name = "Grasp Mark - Mark of The Void"
	gain_text = "A gust of wind? A shimmer in the air? The presence is overwhelming, \
		my senses began to betray me. My mind is my own enemy."
	desc = "Your Mansus Grasp now applies the Mark of Void. The mark is triggered from an attack with your Void Blade. \
		When triggered, further silences the victim and swiftly lowers the temperature of their body and the air around them."
	cost = 2
	banned_knowledge = list(
		/datum/eldritch_knowledge/ash_mark,
		/datum/eldritch_knowledge/rust_mark,
		/datum/eldritch_knowledge/flesh_mark,
		/datum/eldritch_knowledge/mind_mark,
		/datum/eldritch_knowledge/blade_mark,
		/datum/eldritch_knowledge/cosmic_mark)
	route = PATH_VOID
	tier = TIER_MARK

/datum/eldritch_knowledge/void_mark/on_gain(mob/user)
	. = ..()
	RegisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK, PROC_REF(on_mansus_grasp))

/datum/eldritch_knowledge/void_mark/on_lose(mob/user, datum/antagonist/heretic/our_heretic)
	UnregisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK)

/datum/eldritch_knowledge/void_mark/proc/on_mansus_grasp(mob/living/source, mob/living/target)
	SIGNAL_HANDLER

	if(isliving(target))
		var/mob/living/living_target = target
		living_target.apply_status_effect(/datum/status_effect/eldritch/void, 1)

/datum/eldritch_knowledge/cold_snap
	name = "T2 - Aristocrat's Way"
	gain_text = "I found a thread of cold breath. It lead me to a strange shrine, all made of crystals. \
		Translucent and white, a depiction of a nobleman stood before me."
	desc = "Grants you immunity to cold temperatures, and removes your need to breathe. Gain immunity to slipping on ice. \
		You can still take damage due to a lack of pressure."
	cost = 1
	route = PATH_VOID
	tier = TIER_2
	
/datum/eldritch_knowledge/cold_snap/on_gain(mob/user, datum/antagonist/heretic/our_heretic)
	. = ..()
	user.add_traits(list(TRAIT_NOBREATH, TRAIT_RESISTCOLD, TRAIT_NOSLIPICE), type)

/datum/eldritch_knowledge/cold_snap/on_lose(mob/user, datum/antagonist/heretic/our_heretic)
	. = ..()
	user.remove_traits(list(TRAIT_RESISTCOLD, TRAIT_NOBREATH, TRAIT_NOSLIPICE), type)

/datum/eldritch_knowledge/spell/void_blast
	name = "T2 - Void Blast"
	gain_text = "Every door I open racks my body. I am afraid of what is behind them. Someone is expecting me, \
		and my legs start to drag. Is that... snow?"
	desc = "Grants you Void Blast, a spell that shoots out a freezing blast in a cone in front of you, \
		freezing the ground and any victims within."
	cost = 1
	spell_to_add = /datum/action/cooldown/spell/cone/staggered/cone_of_cold/void
	tier = TIER_2

/datum/eldritch_knowledge/void_blade_upgrade
	name = "Blade Upgrade - Shiva's Kiss"
	gain_text = "Fleeting memories, fleeting feet. I mark my way with frozen blood upon the snow. Covered and forgotten, wandering I lie, too weary to die."
	desc = "Your blade will now inject a freezing venom into your targets."
	cost = 2
	banned_knowledge = list(
		/datum/eldritch_knowledge/ash_blade_upgrade,
		/datum/eldritch_knowledge/rust_blade_upgrade,
		/datum/eldritch_knowledge/flesh_blade_upgrade,
		/datum/eldritch_knowledge/mind_blade_upgrade,
		/datum/eldritch_knowledge/blade_blade_upgrade,
		/datum/eldritch_knowledge/cosmic_blade_upgrade)
	route = PATH_VOID
	tier = TIER_BLADE

/datum/eldritch_knowledge/void_blade_upgrade/on_eldritch_blade(target,user,proximity_flag,click_parameters)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		carbon_target.reagents.add_reagent(/datum/reagent/consumable/frostoil, 1)

/datum/eldritch_knowledge/spell/void_pull
	name = "T3 - Void Pull"
	gain_text = "All is fleeting, but what else stays? I'm close to ending what was started. \
		The Aristocrat reveals themselves to me again. They tell me I am late. Their pull is immense, I cannot turn back."
	desc = "Grants you Void Pull, a spell that pulls all nearby heathens towards you, stunning them briefly."
	cost = 1
	spell_to_add = /datum/action/cooldown/spell/aoe/void_pull
	route = PATH_VOID
	tier = TIER_3

/datum/eldritch_knowledge/spell/call_of_ice
	name = "T3 - Diamond Dust"
	gain_text = "Staring at death, I take a breath, there's nothing left. \
	     Now close my eyes, for one last time, and say goodbye \
		 Lying naked while the snow falls all around me; \
		 Drifting closer to the edge but She won't have me! \
		 Wake up in sweat, full of regret, try to forget \
		 These memories, lurking beneath, lost in a dream..."
	desc = "A powerful spell that calls forth memories of ice, will create a large area of ice around you."
	cost = 1
	spell_to_add = /datum/action/cooldown/spell/aoe/slip/void
	tier = TIER_3

/datum/eldritch_knowledge/void_final
	name = "Ascension Rite - Waltz at the End of Time"
	gain_text = "The world falls into darkness. I stand in an empty plane, small flakes of ice fall from the sky. \
		The Aristocrat stands before me, beckoning. We will play a waltz to the whispers of dying reality, \
		as the world is destroyed before our eyes. The void will return all to nothing, WITNESS MY ASCENSION!"
	desc = "The ascension ritual of the Path of Void. \
		Bring 3 corpses to a transmutation rune to complete the ritual. \
		When completed, causes a violent storm of void snow \
		to assault the station, freezing and damaging heathens. \
		Additionally, you will become immune to the effects of space and take reduced damage."
	cost = 3
	unlocked_transmutations = list(/datum/eldritch_transmutation/final/void_final)
	route = PATH_VOID
	tier = TIER_ASCEND
