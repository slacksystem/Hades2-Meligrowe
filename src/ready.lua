---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
-- 	so you will most likely want to have it reference
--	values and functions later defined in `reload.lua`.

OnAnyLoad {
	function (triggerArgs)
		if CurrentRun.Hero ~= nil then
			CurrentRun.Hero.Outline = GetOutline()
			CurrentRun.Hero.Outline.Id = CurrentRun.Hero.ObjectId
			AddOutline(CurrentRun.Hero.Outline)
		end
	end
}

modutil.mod.Path.Wrap("StartOver", function(base, args)
	StartOver_wrap(base, args)
end)

modutil.mod.Path.Wrap("CreateLevelDisplay", function(base, newEnemy, currentRun)
	base(newEnemy, currentRun)
	CreateLevelDisplay_wrap(newEnemy, currentRun)
end)

modutil.mod.Path.Wrap("DoEnemyHealthBufferDeplete", function(base, enemy)
	base(enemy)
	DoEnemyHealthBufferDeplete_wrap(enemy)
end)

modutil.mod.Path.Wrap("WeaponLobAmmoDrop", function(base, triggerArgs, weaponDataArgs)
	WeaponLobAmmoDrop_override(triggerArgs, weaponDataArgs)
end)

modutil.mod.Path.Wrap("KillPresentation", function(base, victim, killer, args)
	game.RemoveOutline({ Id = victim.ObjectId })
	return base(victim, killer, args)
end)

modutil.mod.Path.Wrap("PostEnemyKillPresentation", function(base, victim, triggerArgs)
	game.RemoveOutline({ Id = victim.ObjectId })
	return base(victim, triggerArgs)
end)

modutil.mod.Path.Wrap("DeathPresentation", function(base, currentRun, killer, args)
	game.RemoveOutline({ Id = currentRun.Hero.ObjectId })
	return base(currentRun, killer, args)
end)

modutil.mod.Path.Wrap("BossChillKillPresentation", function(base, unit)
	game.RemoveOutline({ Id = unit.ObjectId })
	return base(unit)
end)

modutil.mod.Path.Wrap("GenericBossKillPresentation", function(base, unit, args)
	game.RemoveOutline({ Id = unit.ObjectId })
	return base(unit, args)
end)

modutil.mod.Path.Wrap("LastKillPresentation", function(base, unit)
	game.RemoveOutline({ Id = unit.ObjectId })
	return base(unit)
end)

modutil.mod.Path.Wrap("PostEnemyKillPresentation", function(base, victim, triggerArgs)
	game.RemoveOutline({ Id = victim.ObjectId })
	return base(victim, triggerArgs)
end)

modutil.mod.Path.Wrap("ErisKillPresentation", function(base, unit, args)
	game.RemoveOutline({ Id = unit.ObjectId })
	return base(unit, args)
end)

modutil.mod.Path.Wrap("ChronosKillPresentation", function(base, unit, args)
	game.RemoveOutline({ Id = unit.ObjectId })
	return base(unit, args)
end)

modutil.mod.Path.Wrap("HecateKillPresentation", function(base, unit, args)
	game.RemoveOutline({ Id = unit.ObjectId })
	return base(unit, args)
end)

modutil.mod.Path.Wrap("InfestedCerberusKillPresentation", function(base, unit, args)
	game.RemoveOutline({ Id = unit.ObjectId })
	return base(unit, args)
end)

modutil.mod.Path.Wrap("CrawlerMiniBossKillPresentation", function(base, unit, args)
	game.RemoveOutline({ Id = unit.ObjectId })
	return base(unit, args)
end)

modutil.mod.Path.Wrap("SirenKillPresentation", function(base, unit, args)
	game.RemoveOutline({ Id = unit.ObjectId })
	return base(unit, args)
end)

modutil.mod.Path.Wrap("ScyllaKillPresentation", function(base, unit, args)
	game.RemoveOutline({ Id = unit.ObjectId })
	return base(unit, args)
end)

modutil.mod.Path.Wrap("SpawnKillPresentation", function(base, unit)
	game.RemoveOutline({ Id = unit.ObjectId })
	return base(unit)
end)
