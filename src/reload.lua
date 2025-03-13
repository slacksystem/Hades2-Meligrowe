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

function GrowHero(args)
	local changeValue = 1
	local changeValueAbs = 0
	local sizeAbsolute = false
	local doPresentation = false
	if args then
		changeValue = args.changeValue or 1
		changeValueAbs = args.changeValue or 0
		sizeAbsolute = args.sizeAbsolute or false
		doPresentation = doPresentation or false
	end
	if CurrentRun.Hero ~= nil and HeroHasTrait("GrowTrait") then
		local trait = GetHeroTrait("GrowTrait")
		if trait.GrowLevel ~= nil then
			if not sizeAbsolute then
				trait.GrowLevel = trait.GrowLevel + changeValue
			else
				trait.GrowLevel = changeValueAbs
			end
		end
		GrowTraitUpdate()
	end

	if args and args.doPresentation == true then
		thread(function()
			PlaySound({ Name = "/SFX/HealthIncreasePickup" })
			wait( 0.02 )
		
			local roomData = RoomData[CurrentRun.CurrentRoom.Name] or CurrentRun.CurrentRoom
			local globalVoiceLines = GlobalVoiceLines[roomData.CloseTalentScreenGlobalVoiceLines] or GlobalVoiceLines.TalentDropUsedVoiceLines
			thread( PlayVoiceLines, globalVoiceLines, true )
		
			ShakeScreen({ Speed = 1000, Distance = 2, Duration = 0.3 })
			thread( DoRumble, { { ScreenPreWait = 0.02, LeftFraction = 0.3, Duration = 0.3 }, } )
			SetAnimation({ Name = "MelinoeBoonInteractPowerUp", DestinationId = CurrentRun.Hero.ObjectId })
			CreateAnimation({ Name = "HealthSparkleShower", DestinationId = CurrentRun.Hero.ObjectId })
		end)
	end
end

function AddGrowTraitToHero(skipUI)
	AddTraitToHero({
		TraitData = GetProcessedTraitData({
			Unit = CurrentRun.Hero,
			TraitName = "GrowTrait",
			Rarity = "Common",
		}),
		SkipNewTraitHighlight = true,
		SkipQuestStatusCheck = true,
		SkipActivatedTraitUpdate = true,
		SkipUIUpdate = skipUI,
	})
end

function EndEncounterEffects_wrap(base, currentRun, currentRoom, currentEncounter)
	--imitating condition structure from Eris keepsake (funny bell of damage)
	if currentEncounter == currentRoom.Encounter or currentEncounter == MapState.EncounterOverride then
		if not currentRoom.BlockClearRewards then
			GrowHero({ doPresentation = true })
		end
	end
end