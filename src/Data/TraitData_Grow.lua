---@diagnostic disable: undefined-global

--insert trait description
local order = {
	'Id',
	'InheritFrom',
	'DisplayName',
	'Description',
}

local text_to_insert = sjson.to_object({
	Id = "GrowTrait",
	InheritFrom = "BaseBoon",
	DisplayName = "Increasing Heft",
	Description = "{#UpgradeFormat}{$TooltipData.ExtractData.CurrentMelSize:P} {#Prev}size. Every {#BoldFormat}{$TooltipData.ExtractData.TooltipRoomInterval} {$Keywords.EncounterPlural}{#Prev}, gains {#BoldFormatGraft}+{$TooltipData.ExtractData.MelSizeIncreasePerXRooms:F} {#Prev}more size.",
}, order)

local textfile = rom.path.combine(rom.paths.Content, 'Game/Text/en/TraitText.en.sjson')

sjson.hook(textfile, function(sjsonData)
---@diagnostic disable-next-line: param-type-mismatch
	table.insert(sjsonData.Texts, text_to_insert)
end)

--insert pop-up text for growth
local orderPopUp = {
	'Id',
	'DisplayName',
}

local text_to_insert_pop_up = sjson.to_object({
	Id = "GrowPopUp",
	DisplayName = "Bigger...",
}, orderPopUp)

local textfilePopUp = rom.path.combine(rom.paths.Content, 'Game/Text/en/HelpText.en.sjson')

sjson.hook(textfilePopUp, function(sjsonData)
---@diagnostic disable-next-line: param-type-mismatch
	table.insert(sjsonData.Texts, text_to_insert_pop_up)
end)


--custom voice line sets for getting bigger
GlobalVoiceLines.GrowBiggerVoiceLines =
{
	{
		GameStateRequirements =
		{
			{
				Path = { "CurrentRun", "Hero", "trackedScale" },
				Comparison = ">=",
				Value = 1.5,
			},
		},

		Queue = "Interrupt",
		BreakIfPlayed = true,
		RandomRemaining = true,
		PreLineWait = 0.2,
		--SuccessiveChanceToPlay = 0.25,
		UsePlayerSource = true,
		SkipCooldownCheckIfNonePlayed = true,
		TriggerCooldowns = { Name = "MelinoeAnyQuipSpeech" },

		{ Cue = "/VO/Melinoe_3526", Text = "I'm huge..." , PlayFirst = true},
		{ Cue = "/VO/Melinoe_2595", Text = "You're all grown up." },
		{ Cue = "/VO/Melinoe_2596", Text = "Sprang up so fast." },
		{ Cue = "/VO/Melinoe_2597", Text = "How tall you've grown..." },
		{ Cue = "/VO/Melinoe_2598", Text = "You're a sight to behold." },
		{ Cue = "/VO/Melinoe_2371", Text = "Full grown." },
		{ Cue = "/VO/Melinoe_2372", Text = "All grown up." },
	},
	{
		--Uses same requirements as picking up a boon.
		GameStateRequirements =
		{
			{
				Path = { "CurrentRun", "CurrentRoom", "Encounter", "Name" },
				IsNone = { "Shop", "DevotionTestF", "DevotionTestG", "DevotionTestH", "DevotionTestN", "DevotionTestO", "DevotionTestP", "ArtemisCombatIntro",
					"ArtemisCombatF", "ArtemisCombatF2",
					"ArtemisCombatG", "ArtemisCombatG2",
					"ArtemisCombatN", "ArtemisCombatN2",
					"HeraclesCombatN", "HeraclesCombatN2",
					"HeraclesCombatO", "HeraclesCombatO2",
					"HeraclesCombatP", "HeraclesCombatP2",
					"NemesisCombatF", "NemesisCombatG",
					"NemesisCombatH", "IcarusCombatO",
					"IcarusCombatO2", "IcarusCombatP",
					"IcarusCombatP2", },
			},
			{
				Path = { "CurrentRun", "CurrentRoom", "Name" },
				IsNone = { "TestAllThings", "F_Story01", "G_Story01", "H_Bridge01", "I_Story01", "N_Story01", "O_Story01", "P_Story01" },
			},
		},
		
		Queue = "Interrupt",
		BreakIfPlayed = true,
		RandomRemaining = true,
		PreLineWait = 0.2,
		--SuccessiveChanceToPlay = 0.33,
		UsePlayerSource = true,
		SkipCooldownCheckIfNonePlayed = true,
		Cooldowns =
		{
			{ Name = "MelinoeGrowBigger", Time = 30 },
		},
		TriggerCooldowns = { Name = "MelinoeAnyQuipSpeech" },

		{ Cue = "/VO/Melinoe_2593", Text = "You'll grow up in no time.", PlayFirst = true},
		{ Cue = "/VO/Melinoe_0200", Text = "Greater strength." },
		{ Cue = "/VO/Melinoe_0208", Text = "{#Emph}Hm!" },
		{ Cue = "/VO/Melinoe_0212", Text = "I grow strong." },
		{ Cue = "/VO/Melinoe_0213", Text = "Greater might..." },
		{ Cue = "/VO/Melinoe_2359", Text = "Grow strong." },
		{ Cue = "/VO/Melinoe_2360", Text = "Grow and flourish." },
		{ Cue = "/VO/Melinoe_2304", Text = "Grow and thrive." },
		{ Cue = "/VO/Melinoe_2303", Text = "You're growing strong." },
		{ Cue = "/VO/Melinoe_0569", Text = "{#Emph}<Inhale>" },
		{ Cue = "/VO/Melinoe_2306", Text = "Drink deep and grow tall." },
		{ Cue = "/VO/Melinoe_1515", Text = "Beautiful." },
		{ Cue = "/VO/Melinoe_3279", Text = "Wow..." },
		{ Cue = "/VO/Melinoe_3284", Text = "Huh..." },
		{ Cue = "/VO/Melinoe_0580", Text = "{#Emph}Ugh..." },
		{ Cue = "/VO/Melinoe_0761", Text = "{#Emph}Ungh..." },
	},
}

-- the trait itself
GrowTraits = {
	GrowTrait = 
	{
		--InheritFrom = {"BaseCurse"},
		Icon = "Boon_Circe_02",
		BaseChipmunkValue = config.startingPitch,
		SetupFunction = 
		{
			Name = "aaaaaaa", --I don't think this actually does anything but im leaving it
			Args = 
			{
				--ScaleMultiplier = 1.25,
				--InitialPresentationFunctionName = "CirceEnlargePresentation",
				ReportValues = 
				{
					ReportedScale = "Scale",
				},
			},
		},
		--[[AddOutgoingDamageModifiers = 
		{
			ValidWeaponMultiplier = 1.15,
			ReportValues = {ReportedMultiplier = "ValidWeaponMultiplier"}
		},]]
		GrowTraitGrowthPerRoom = { BaseValue = config.sizeGrowthPerRoom or 0.015, DecimalPlaces = 3 },
		GrowTraitGrowthPerRoomDisplay = { BaseValue = config.sizeGrowthPerRoom or 0.015, DecimalPlaces = 3 },
		GrowTraitValue = config.startingSize or 1,
		VoicePitchPerRoom = { BaseValue = config.voicePitchChangePerRoom or -0.024, DecimalPlaces = 3 },
		GrowLevel = 0,
		ShowInHUD = true,
		CurrentRoom = 0,
		RoomsPerUpgrade = 
		{ 
			Amount = { BaseValue = config.growEveryXRooms or 2 },
			ReportValues =
			{ 
				ReportedRoomsPerUpgrade = "Amount",
			},
		},
		ExtractValues = 
		{
			{
				Key = "GrowTraitGrowthPerRoomDisplay",
				ExtractAs = "MelSizeIncreasePerXRooms",
				Format = "Percent",
				DecimalPlaces = 3,
			},
			{
				SkipAutoExtract = true,
				Key = "GrowTraitValue",
				ExtractAs = "CurrentMelSize",
				Format = "PercentDelta",
				DecimalPlaces = 3,
			},
			{
				Key = "ReportedRoomsPerUpgrade",
				ExtractAs = "TooltipRoomInterval",
			},
		},
	},
}

--add trait to the game
for key, growTrait in pairs(GrowTraits) do
	TraitData[key] = growTrait
end

--retain this value between upgrades and such
table.insert(PersistentTraitKeys, "GrowLevel")