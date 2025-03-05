---@diagnostic disable: undefined-global

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
	Description = "{#UpgradeFormat}{$TooltipData.ExtractData.CurrentMelSize:P} {#Prev}size. After each {$Keywords.EncounterAlt}, gains {#BoldFormatGraft}+{$TooltipData.ExtractData.MelSizeIncreasePerRoom:F} {#Prev}more size.",
}, order)

local textfile = rom.path.combine(rom.paths.Content, 'Game/Text/en/TraitText.en.sjson')

sjson.hook(textfile, function(sjsonData)
---@diagnostic disable-next-line: param-type-mismatch
	table.insert(sjsonData.Texts, text_to_insert)
end)

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
		GrowTraitGrowthPerRoom = { BaseValue = config.sizeGrowthPerRoom or 0.03, DecimalPlaces = 3 },
		GrowTraitValue = config.startingSize or 1,
		VoicePitchPerRoom = { BaseValue = config.voicePitchChangePerRoom or -0.05, DecimalPlaces = 3 },
		ExtractValues = 
		{
			{
				Key = "GrowTraitGrowthPerRoom",
				ExtractAs = "MelSizeIncreasePerRoom",
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
		},
	},
}

for key, growTrait in pairs(GrowTraits) do
	TraitData[key] = growTrait
end