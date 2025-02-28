---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global
---@diagnostic disable: undefined-global

-- this file will be reloaded if it changes during gameplay,
-- 	so only assign to values or define things here.

--Mostly copy of vanilla function. Modded section marked.

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