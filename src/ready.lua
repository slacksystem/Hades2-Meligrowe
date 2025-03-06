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
modutil.mod.Path.Wrap("StartNewRun", function(base, prevRun, args)
	local retVar = base(prevRun, args)
	StartNewRun_wrap(base, prevRun, args)
	return retVar
end)

modutil.mod.Path.Wrap("ApplyTraitSetupFunctions", function(base, unit, args)
	base(unit, args)

	--Applying in the same context as setup functions usually run (e.g. Circe's actual boons)
	if unit == CurrentRun.Hero and HeroHasTrait("GrowTrait") and (not args or (args and not args.Context)) then
		local trait = GetHeroTrait("GrowTrait")
		GrowTraitUpdate(unit, trait)
	end

end)

modutil.mod.Path.Wrap("EndEncounterEffects", function(base, currentRun, currentRoom, currentEncounter)
	EndEncounterEffects_wrap(base, currentRun, currentRoom, currentEncounter)
	return base(currentRun, currentRoom, currentEncounter)
end)

modutil.mod.Path.Wrap("SpellTransformStartPresentation", function(base, user, weaponData, functionArgs, triggerArgs)
	if unit == CurrentRun.Hero and HeroHasTrait("GrowTrait") then
		local trait = GetHeroTrait("GrowTrait")
		GrowTraitUpdate(unit, trait, { Transformed = true })
	else
		return base(user, weaponData, functionArgs, triggerArgs)
	end
	PlaySound({ Name = "/VO/MelinoeEmotes/EmoteAttackingAxe", Id = CurrentRun.Hero.ObjectId })
end)

modutil.mod.Path.Wrap("SpellTransformEndPresentation", function(base, user, weaponData, functionArgs, triggerArgs)
	if unit == CurrentRun.Hero and HeroHasTrait("GrowTrait") then
		local trait = GetHeroTrait("GrowTrait")
		GrowTraitUpdate(unit, trait)
	else
		return base(user, weaponData, functionArgs, triggerArgs)
	end
	PlaySound({ Name = "/SFX/TimeSlowEnd", Id = CurrentRun.Hero.ObjectId })
	PlaySound({ Name = "/VO/MelinoeEmotes/EmoteGasping", Id = CurrentRun.Hero.ObjectId })
end)