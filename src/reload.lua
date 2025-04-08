---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global
---@diagnostic disable: undefined-global

-- this file will be reloaded if it changes during gameplay,
-- 	so only assign to values or define things here.

GrowUnstuck = GrowUnstuck or false --lock size to 1.0 toggle

--table print debug function
function dump(o)
	if type(o) == 'table' then
	   local s = '{ '
	   for k,v in pairs(o) do
		  if type(k) ~= 'number' then k = '"'..k..'"' end
		  s = s .. '['..k..'] = ' .. dump(v) .. ','
	   end
	   return s .. '} '
	else
	   return tostring(o)
	end
end


--returns false if hero or trait are not found
function GrowTraitUpdate(args)
	local unit = nil
	local trait = nil
	local mode = "room"

	if CurrentRun ~= nil and CurrentRun.Hero ~= nil then
		unit = CurrentRun.Hero
		if HeroHasTrait("GrowTrait") then
			trait = GetHeroTrait("GrowTrait")
		elseif HeroHasTrait("HealthGrowTrait") then
			trait = GetHeroTrait("HealthGrowTrait")
			mode = "hp"
		elseif HeroHasTrait("HubGrowTrait")then
			trait = GetHeroTrait("HubGrowTrait")
			mode = "hub"
		end
	end

	if unit == nil or trait == nil then return false end

	local growthPerRoom = config.sizeGrowthPerRoom
	local pitchPerRoom = config.voicePitchChangePerRoom

	if mode == "hub" then
		growthPerRoom = config.hubModeGrowth
		pitchPerRoom = config.hubModePitch
	end

	if mode == "hp" then
		local currentHP = CurrentRun.Hero.MaxHealth or 110
		local startHP = config.healthModeNormalSizeHP or 110
		local finalSize = config.healthModeBigSize or 1.9
		local finalPitch = config.healthModeBigPitch or -1.4

		if config.healthModeUseStartingHP then startHP = CurrentRun.Hero.trackedHP or startHP end

		--lerp size and pitch from set starting HP value to size/pitch at 400 and beyond
		trait.GrowTraitValue = ( 1 * (400 - currentHP) + finalSize * (currentHP - startHP) ) / ( 400 - startHP )
		trait.BaseChipmunkValue = ( finalPitch * (currentHP - startHP) ) / ( 400 - startHP ) --startPitch is zero, therefore startPitch * (400 - currentHP) == 0
	elseif mode == "room" then
		trait.GrowTraitValue = (config.startingSize or 1) + trait.GrowLevel * growthPerRoom
		trait.BaseChipmunkValue = (config.startingPitch or 0) + trait.GrowLevel * pitchPerRoom
	else
		trait.GrowTraitValue = 1 + trait.GrowLevel * growthPerRoom
		trait.BaseChipmunkValue = trait.GrowLevel * pitchPerRoom
	end


	if mode == "room" then
		growthPerRoomDisplay = growthPerRoom * (config.growEveryXRooms or 2)
	end

	if HeroHasTrait("CirceEnlargeTrait") then
		trait.GrowTraitValue = trait.GrowTraitValue * 1.25
		if mode == "room" then
			growthPerRoomDisplay = growthPerRoom * 1.25
		end
		trait.BaseChipmunkValue = trait.BaseChipmunkValue - 0.2
	end

	if HeroHasTrait("CirceShrinkTrait") then
		trait.GrowTraitValue = trait.GrowTraitValue * 0.75
		if mode == "room" then
			growthPerRoomDisplay = growthPerRoom * 0.75
		end
		trait.BaseChipmunkValue = trait.BaseChipmunkValue + 0.3
	end

	if config.voicePitchUseLowerLimit and config.voicePitchLowerLimit ~= nil then
		trait.BaseChipmunkValue = math.max(trait.BaseChipmunkValue, config.voicePitchLowerLimit)
	end

	if config.voicePitchUseUpperLimit and config.voicePitchUpperLimit ~= nil then
		trait.BaseChipmunkValue = math.min(trait.BaseChipmunkValue, config.voicePitchUpperLimit)
	end

	if config.sizeUseLowerLimit and config.sizeLowerLimit ~= nil then
		trait.GrowTraitValue = math.max(trait.GrowTraitValue, config.sizeLowerLimit)
	end

	if config.sizeUseUpperLimit and config.sizeUpperLimit ~= nil then
		trait.GrowTraitValue = math.min(trait.GrowTraitValue, config.sizeUpperLimit)
	end

	if trait.GrowTraitValue <= 0.01 then
		trait.GrowTraitValue = 0.01
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

	CurrentRun.Hero.trackedScale = currentSize --this exists to allow dialogue to interact

	if GrowUnstuck then currentSize = 1 end

	SetAudioEffectState({ Name = "Chipmunk", Value = chipmunk })
	SetScale({ Id = unit.ObjectId, Fraction = currentSize, Duration = 0.2 })
	unit.EffectVfxScale = currentSize
	
	return true
end

function GrowHero(args)
	local changeValue = 1
	local changeValueAbs = 0
	local sizeAbsolute = false
	local lastScale = nil
	if args then
		changeValue = args.changeValue or 1
		changeValueAbs = args.changeValue or 0
		sizeAbsolute = args.sizeAbsolute or false
	end
	if CurrentRun.Hero ~= nil then
		lastScale = CurrentRun.Hero.trackedScale --checks for size changes to affect presentation (grow vs. shrink)
		if HeroHasTrait("GrowTrait") then
			local trait = GetHeroTrait("GrowTrait")
			if trait.GrowLevel ~= nil then
				if not sizeAbsolute then
					trait.GrowLevel = trait.GrowLevel + changeValue
				else
					trait.GrowLevel = changeValueAbs
				end
			end
			GrowTraitUpdate()
		elseif HeroHasTrait("HealthGrowTrait") then
			--Just update size and play animation below. No logic needed to change size here.
			GrowTraitUpdate()
		elseif HeroHasTrait("HubGrowTrait") then
			local trait = GetHeroTrait("HubGrowTrait")
			if trait.GrowLevel ~= nil then
				if not sizeAbsolute then
					trait.GrowLevel = trait.GrowLevel + changeValue
				else
					trait.GrowLevel = changeValueAbs
				end
			end
			GrowTraitUpdate()
		end
	else
		return
	end

	local scaleDiff = CurrentRun.Hero.trackedScale - lastScale
	CurrentRun.Hero.trackedScaleDiff = scaleDiff

	if args and args.doPresentation == true then
		if not GrowUnstuck then
			if scaleDiff > 0 then
				--grow
				thread(function()
					PlaySound({ Name = "/SFX/Enemy Sounds/Wringer/WringerChargeUp", Id = CurrentRun.Hero.ObjectId })
					wait( 0.02 )
				end)

				thread( InCombatTextArgs, { TargetId = CurrentRun.Hero.ObjectId, Text = "GrowPopUp", PreDelay = 0.35, Duration = 1.5, Cooldown = 1.0 } )
				SetAnimation({ Name = "MelinoeBoonInteractPowerUp", DestinationId = CurrentRun.Hero.ObjectId })
				CreateAnimation({ Name = "HealthSparkleShower", DestinationId = CurrentRun.Hero.ObjectId })
			elseif scaleDiff < 0 then
				--shrink
				thread(function()
					PlaySound({ Name = "/SFX/ThanatosHermesKeepsakeFail", Id = CurrentRun.Hero.ObjectId, Volume = 0.25 })
					wait( 0.02 )
				end)

				thread( InCombatTextArgs, { TargetId = CurrentRun.Hero.ObjectId, Text = "ShrinkPopUp", PreDelay = 0.35, Duration = 1.5, Cooldown = 1.0 } )
				SetAnimation({ Name = "MelinoeShrink", DestinationId = CurrentRun.Hero.ObjectId })
				CreateAnimation({ Name = "HealthSparkleBurst", DestinationId = CurrentRun.Hero.ObjectId })
			end
			
			if scaleDiff ~= 0 then
				local globalVoiceLines = GlobalVoiceLines.GrowBiggerVoiceLines --this is actually all size change voice lines don't be fooled
				thread( PlayVoiceLines, globalVoiceLines, true )
			
				ShakeScreen({ Speed = 1000, Distance = 2, Duration = 0.3 })
				thread( DoRumble, { { ScreenPreWait = 0.02, LeftFraction = 0.3, Duration = 0.3 }, } )
			end
		else
			thread( InCombatTextArgs, { TargetId = CurrentRun.Hero.ObjectId, Text = "UnstuckEnablePopUp", PreDelay = 0.35, Duration = 2.5, Cooldown = 1.0 } )
		end
	end
end

function AddGrowTraitToHero(args)
	
	local init = false
	local skipUI = false --this stops new save files from crashing.

	if args then
		init = args.init
		skipUI = args.skipUI
	end

	--initialize tracking values if they don't exist regardless of args
	CurrentRun.Hero.trackedScale = CurrentRun.Hero.trackedScale or config.startingSize or 1.0 --this exists to allow dialogue to interact and presentation to detect grow vs. shrink
	CurrentRun.Hero.trackedScaleDiff = CurrentRun.Hero.trackedScaleDiff or 0 --supplemental to the above
	CurrentRun.Hero.trackedHP = CurrentRun.Hero.trackedHP or CurrentRun.Hero.MaxHealth --remember HP from run start for certain maxHP mode settings

	--use init if starting a new run. resets certain tracking variables
	if init == true then
		CurrentRun.Hero.trackedScale = config.startingSize or 1.0
		CurrentRun.Hero.trackedScaleDiff = 0
		CurrentRun.Hero.trackedHP = CurrentRun.Hero.MaxHealth
	end

	local traitName = "GrowTrait"

	if CurrentHubRoom ~= nil then
		traitName = "HubGrowTrait"
	elseif config.growthMode == "Max HP" then
		traitName = "HealthGrowTrait"
		if init == true then
			if config.healthModeUseStartingHP then
				CurrentRun.Hero.trackedScale = 1.0
			else
				local currentHP = CurrentRun.Hero.trackedHP
				local startHP = config.healthModeNormalSizeHP or 110
				local finalSize = config.healthModeBigSize or 1.9

				--lerp size to make sure start size is recorded correctly
				CurrentRun.Hero.trackedScale = ( 1 * (400 - currentHP) + finalSize * (currentHP - startHP) ) / ( 400 - startHP )
			end
		end
	end
	


	local traitsToCheck = { "HubGrowTrait", "GrowTrait", "HealthGrowTrait" }
	local traitWasRemoved = false

	for _, traitCheck in pairs(traitsToCheck) do
		if traitCheck ~= traitName then
			if HeroHasTrait(traitCheck) then
				RemoveTrait(CurrentRun.Hero, traitCheck, {SkipUIUpdate = skipUI})
				traitWasRemoved = true
			end
		end
	end

	if HeroHasTrait(traitName) then return end

	local tD = GetProcessedTraitData({
		Unit = CurrentRun.Hero,
		TraitName = traitName,
		Rarity = "Common",
	})
	
	--anti-crash for hub area
	tD.Name = traitName
	tD.TraitOrderingValueCache = -1

	AddTraitToHero({
		TraitData = tD,
		SkipNewTraitHighlight = true,
		SkipQuestStatusCheck = true,
		SkipActivatedTraitUpdate = true,
		SkipUIUpdate = skipUI,
	})

	--set GrowLevel and room counter to their appropriate levels
	if traitWasRemoved and HeroHasTrait("GrowTrait") and traitName == "GrowTrait" and CurrentRun.EncounterDepth then
		local trait = GetHeroTrait("GrowTrait")
		local divisor = config.growEveryXRooms or 2
		trait.GrowLevel = math.floor(CurrentRun.EncounterDepth / divisor) * divisor --round down to closest multiple of X rooms
		trait.CurrentRoom = trait.RoomsPerUpgrade.Amount - CurrentRun.EncounterDepth % divisor
	end

	GrowTraitUpdate()
end

function CheckChamberTraits_wrap(base)
	if not HeroHasTrait("GrowTrait") then return end
	
	local trait = GetHeroTrait("GrowTrait")

	if trait.CurrentRoom == 0 then
		GrowHero({ changeValue = (config.growEveryXRooms or 2), doPresentation = true })
	end

	--[[imitating condition structure from Eris keepsake (funny bell of damage)
	if currentEncounter == currentRoom.Encounter or currentEncounter == MapState.EncounterOverride then
		if trait.CurrentRoom == trait.RoomsPerUpgrade.Amount - 1  then
				GrowHero({ changeValue = (config.growEveryXRooms or 2), doPresentation = true })
		end
	end]]
end