---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global
---@diagnostic disable: undefined-global

-- this file will be reloaded if it changes during gameplay,
-- 	so only assign to values or define things here.

function StartOver_wrap(base, args)
	base(args)
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
	--KNOWN ISSUE: This trait does not stick if you quit before the game autosaves again
end