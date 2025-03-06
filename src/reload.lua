---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global
---@diagnostic disable: undefined-global

-- this file will be reloaded if it changes during gameplay,
-- 	so only assign to values or define things here.

function GrowTraitUpdate( unit, trait)
	if unit == nil or trait == nil then return end

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
	SetAudioEffectState({ Name = "Chipmunk", Value = GetTotalHeroTraitValue("BaseChipmunkValue") })
	SetScale({ Id = unit.ObjectId, Fraction = trait.GrowTraitValue, Duration = 0.2 })
	unit.EffectVfxScale = trait.GrowTraitValue
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