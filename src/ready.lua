---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global
---@diagnostic disable: undefined-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
-- 	so you will most likely want to have it reference
--	values and functions later defined in `reload.lua`.

OnAnyLoad {
	function (triggerArgs)
		
	end
}

--puts the funny boon on you at the start of a run (over in reload.lua)
modutil.mod.Path.Wrap("StartOver", function(base, args)
	StartOver_wrap(base, args)
end)

modutil.mod.Path.Wrap("ApplyTraitSetupFunctions", function(base, unit, args)
	base(unit, args)

	--Applying in the same context as setup functions usually run (e.g. Circe's actual boons)
	if unit == CurrentRun.Hero and HeroHasTrait("GrowTrait") then
		print("Found the modifier...")
		local trait = GetHeroTrait("GrowTrait")
		GrowTraitUpdate(unit, trait)
	end

end)

modutil.mod.Path.Wrap("EndEncounterEffects", function(base, currentRun, currentRoom, currentEncounter)
	base(currentRun, currentRoom, currentEncounter)

	--imitating condition structure from Eris keepsake (funny bell of damage)
	if currentEncounter == currentRoom.Encounter or currentEncounter == MapState.EncounterOverride then
		if not currentRoom.BlockClearRewards then
			if CurrentRun.Hero ~= nil and HeroHasTrait("GrowTrait") then
				local trait = GetHeroTrait("GrowTrait")
				if trait.GrowTraitValue ~= nil and trait.GrowTraitGrowthPerRoom ~= nil then
					trait.GrowTraitValue = trait.GrowTraitValue + trait.GrowTraitGrowthPerRoom
					
				end
				if trait.BaseChipmunkValue ~= nil and trait.VoicePitchPerRoom ~= nil then
					trait.BaseChipmunkValue = trait.BaseChipmunkValue + trait.VoicePitchPerRoom
				end
				GrowTraitUpdate(CurrentRun.Hero, trait)
			end
		end
	end
end)