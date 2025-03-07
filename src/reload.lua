---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global
---@diagnostic disable: undefined-global

-- this file will be reloaded if it changes during gameplay,
-- 	so only assign to values or define things here.

--returns false if hero or trait are not found
function GrowTraitUpdate(args)
	local unit = nil
	local trait = nil

	if CurrentRun.Hero ~= nil then
		unit = CurrentRun.Hero
		if HeroHasTrait("GrowTrait") then
			trait = GetHeroTrait("GrowTrait")
		end
	end

	if unit == nil or trait == nil then return false end

	trait.GrowTraitValue = (config.startingSize or 1) + trait.GrowLevel * trait.GrowTraitGrowthPerRoom
	trait.BaseChipmunkValue = (config.startingPitch or 0) + trait.GrowLevel * trait.VoicePitchPerRoom
	--[[roomArgs = roomArgs or {}
	local duration = args.Duration
	local skipPresentation = false
	if roomArgs.Grouped then
		duration = 0
	else
		thread( CirceEnlargePresentation )
	end]]

	trait.GrowTraitGrowthPerRoomDisplay = trait.GrowTraitGrowthPerRoom

	if HeroHasTrait("CirceEnlargeTrait") then
		trait.GrowTraitValue = trait.GrowTraitValue * 1.25
		trait.GrowTraitGrowthPerRoomDisplay = trait.GrowTraitGrowthPerRoom * 1.25
		trait.BaseChipmunkValue = trait.BaseChipmunkValue - 0.2
	end

	if HeroHasTrait("CirceShrinkTrait") then
		trait.GrowTraitValue = trait.GrowTraitValue * 0.75
		trait.GrowTraitGrowthPerRoomDisplay = trait.GrowTraitGrowthPerRoom * 0.75
		trait.BaseChipmunkValue = trait.BaseChipmunkValue + 0.3
	end

	if config.voicePitchLowerLimit ~= nil then
		trait.BaseChipmunkValue = math.max(trait.BaseChipmunkValue, config.voicePitchLowerLimit)
	end

	if config.voicePitchUpperLimit ~= nil then
		trait.BaseChipmunkValue = math.min(trait.BaseChipmunkValue, config.voicePitchUpperLimit)
	end

	if trait.GrowTraitValue <= 0.1 then
		trait.GrowTraitValue = 0.1
	end

	local chipmunk = GetTotalHeroTraitValue("BaseChipmunkValue")
	local currentSize = trait.GrowTraitValue

	if args ~= nil and args.Transformed == true then
		--make voice deeper when in Dark Side. ignores set pitch cap.
		if chipmunk >= 0 then
			chipmunk = chipmunk - 0.8
		else
			--so basically diminishing returns (until chipmunk - 0.1 breaks even)
			local chipmunkScaling = -0.8 + chipmunk * 0.250
			chipmunk = math.min(chipmunk - 0.2, chipmunkScaling)
		end

		currentSize = currentSize * 1.1
	end

	SetAudioEffectState({ Name = "Chipmunk", Value = chipmunk })
	SetScale({ Id = unit.ObjectId, Fraction = currentSize, Duration = 0.2 })
	unit.EffectVfxScale = currentSize
	
	return true
end

--Mostly copy of vanilla function. Modded section marked, adds the funny boon.
function StartNewRun_wrap(base, prevRun, args)
	local testTrait = AddTraitToHero({
		TraitData = GetProcessedTraitData({
			Unit = CurrentRun.Hero,
			TraitName = "GrowTrait",
			Rarity = "Common",
		}),
		SkipNewTraitHighlight = true,
		SkipQuestStatusCheck = true,
		SkipActivatedTraitUpdate = true,
	})
end

function EndEncounterEffects_wrap(base, currentRun, currentRoom, currentEncounter)
	--imitating condition structure from Eris keepsake (funny bell of damage)
	if currentEncounter == currentRoom.Encounter or currentEncounter == MapState.EncounterOverride then
		if not currentRoom.BlockClearRewards then
			if CurrentRun.Hero ~= nil and HeroHasTrait("GrowTrait") then
				local trait = GetHeroTrait("GrowTrait")
				if trait.GrowLevel ~= nil then
					trait.GrowLevel = trait.GrowLevel + 1
				end
				GrowTraitUpdate(CurrentRun.Hero, trait)
			end
		end
	end
end

function SpellTransformStartPresentation_wrap(base, user, weaponData, functionArgs, triggerArgs)

end