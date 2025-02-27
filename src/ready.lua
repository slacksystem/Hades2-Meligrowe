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
		if CurrentRun.Hero ~= nil then
			print("bee")
		end
	end
}

modutil.mod.Path.Wrap("StartOver", function(base, args)
	StartOver_wrap(base, args)
end)