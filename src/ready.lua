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

modutil.mod.Path.Wrap("StartOver", function(base, args)
	StartOver_wrap(base, args)
end)

modutil.mod.Path.Wrap("ApplyTraitSetupFunctions", function(base, unit, args)
	base(unit, args)

	if unit == CurrentRun.Hero and HeroHasTrait("GrowTrait") then
		print("Found the modifier...")
		local trait = GetHeroTrait("GrowTrait")
		GrowTraitSetup(unit)
	end

end)

--[[modutil.mod.Path.Wrap("AddTraitData", function(base, unit, traitData, args)
	local retTrait = base(unit, traitData, args)
	if retTrait == nil then return end

	if unit == CurrentRun.Hero and retTrait.Name == "GrowTrait" and args.Context == nil then
		print("Found the modifier...")
		GrowTraitSetup(unit)
	end

	return retTrait
end)]]