---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global
---@diagnostic disable: undefined-global

-- this file will be reloaded if it changes during gameplay,
-- 	so only assign to values or define things here.

function GrowTraitUpdate( unit, trait)
	print("Growth trait setup triggered!")
	local currentSize = trait.GrowTraitValue or config.startingSize or 1
	--[[roomArgs = roomArgs or {}
	local duration = args.Duration
	local skipPresentation = false
	if roomArgs.Grouped then
		duration = 0
	else
		thread( CirceEnlargePresentation )
	end]]
	SetAudioEffectState({ Name = "Chipmunk", Value = GetTotalHeroTraitValue("BaseChipmunkValue") })
	SetScale({ Id = unit.ObjectId, Fraction = currentSize, Duration = 0.5 })
	unit.EffectVfxScale = currentSize
end

--Mostly copy of vanilla function. Modded section marked, adds the funny boon.
function StartOver_wrap(base, args)

	AddInputBlock({ Name = "StartOver" })

	for index, familiarName in ipairs( FamiliarOrderData ) do
		local familiarData = FamiliarData[familiarName]
		local familiar = familiarData.Unit
		if familiar then
			CleanupEnemy( familiar )
			familiarData.Unit = nil
		end
	end

	local currentRun = CurrentRun
	EndRun( currentRun )
	CurrentHubRoom = nil
	PreviousDeathAreaRoom = nil

	if GameState.NextRunSeed ~= nil then
		RandomSetNextInitSeed( { Seed = GameState.NextRunSeed } )
		GameState.NextRunSeed = nil
	end
	
	HideCombatUI( "StartOver" )
	currentRun = StartNewRun( currentRun,
		{
			StartingBiome = args.StartingBiome or "F",
			RandomOffset = args.RandomOffset,
			ForcedRewards = args.ForcedRewards,
			ActiveBounty = args.ActiveBounty,
			RunOverrides = args.RunOverrides,
			StartingRoomOverrides = args.StartingRoomOverrides,
		})
	StopMusicianMusic( { Duration = 1.0 } )
	ResetObjectives()

	SetConfigOption({ Name = "FlipMapThings", Value = false })
	SetConfigOption({ Name = "BlockGameplayTimer", Value = false })

	AddTimerBlock( currentRun, "StartOver" )

	-- MODDED CODE ------------------------

	local testTrait = AddTraitToHero({
		TraitData = GetProcessedTraitData({
			Unit = CurrentRun.Hero,
			TraitName = "GrowTrait",
			Rarity = "Common"
		}),
		SkipNewTraitHighlight = true,
		SkipQuestStatusCheck = true,
		SkipActivatedTraitUpdate = true,
	})

	-- END MODDED CODE --------------------
	
	RequestSave({ StartNextMap = currentRun.CurrentRoom.Name, SaveName = "_Temp", DevSaveName = CreateDevSaveName( currentRun ) })
	ValidateCheckpoint({ Value = true })
	
	UnblockCombatUI( "StartOver" )
	RemoveInputBlock({ Name = "StartOver" })
	RemoveTimerBlock( currentRun, "StartOver" )
	AddInputBlock({ Name = "MapLoad" })
	AddTimerBlock( CurrentRun, "MapLoad" )

	LoadMap({ Name = currentRun.CurrentRoom.Name, ResetBinks = true })

end