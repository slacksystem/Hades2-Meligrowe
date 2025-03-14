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

--Debug
rom.inputs.on_key_pressed{"None H", function()
		GrowHero({ sizeAbsolute = true })
	end
}

rom.inputs.on_key_pressed{"None J", function()
		GrowHero()
	end
}

rom.inputs.on_key_pressed{"None K", function()
		GrowHero({ changeValue = 25})
	end
}

rom.inputs.on_key_pressed{"None L", function()
	GrowHero({ changeValue = 2, doPresentation = true })
end
}


--puts the funny boon on you at the start of a run (over in reload.lua)
modutil.mod.Path.Wrap("StartNewRun", function(base, prevRun, args)
	local retVar = base(prevRun, args)
	local skipUI = false
	if prevRun == nil then --fix for crash on new save files
		skipUI = true
	end
	AddGrowTraitToHero(skipUI)
	return retVar
end)

modutil.mod.Path.Wrap("ApplyTraitSetupFunctions", function(base, unit, args)
	base(unit, args)

	--Applying in the same context as setup functions usually run (e.g. Circe's actual boons)
	if not args or (args and not args.Context) then
		GrowTraitUpdate()
	end

end)

--[[modutil.mod.Path.Wrap("EndEncounterEffects", function(base, currentRun, currentRoom, currentEncounter)
	EndEncounterEffects_wrap(base, currentRun, currentRoom, currentEncounter)
	return base(currentRun, currentRoom, currentEncounter)
end)]]

modutil.mod.Path.Wrap("CheckChamberTraits", function(base)
	local retVal = base()
	CheckChamberTraits_wrap(base)
	return retVal
end)

modutil.mod.Path.Wrap("SpellTransformStartPresentation", function(base, user, weaponData, functionArgs, triggerArgs)
	if GrowTraitUpdate({ Transformed = true }) == false then
		return base(user, weaponData, functionArgs, triggerArgs)
	end
	PlaySound({ Name = "/VO/MelinoeEmotes/EmoteAttackingAxe", Id = CurrentRun.Hero.ObjectId })
end)

modutil.mod.Path.Wrap("SpellTransformEndPresentation", function(base, user, weaponData, functionArgs, triggerArgs)
	if GrowTraitUpdate() == false then
		return base(user, weaponData, functionArgs, triggerArgs)
	end
	PlaySound({ Name = "/SFX/TimeSlowEnd", Id = CurrentRun.Hero.ObjectId })
	PlaySound({ Name = "/VO/MelinoeEmotes/EmoteGasping", Id = CurrentRun.Hero.ObjectId })
end)

modutil.mod.Path.Wrap("CirceEnlarge", function(base, unit, args, roomArgs)
	base(unit, args, roomArgs)
	GrowTraitUpdate()
end)

modutil.mod.Path.Wrap("CirceShrink", function(base, unit, args, roomArgs)
	base(unit, args, roomArgs)
	GrowTraitUpdate()
end)