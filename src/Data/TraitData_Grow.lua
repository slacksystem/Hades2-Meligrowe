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
	Description = "After each {$Keywords.EncounterAlt}, get bigger.",
}, order)

local textfile = rom.path.combine(rom.paths.Content, 'Game/Text/en/TraitText.en.sjson')

sjson.hook(textfile, function(sjsonData)
	table.insert(sjsonData.Texts, text_to_insert)
end)

GrowTraits = {
	GrowTrait = 
	{
		InheritFrom = {"BaseCurse"},
		Icon = "Boon_Circe_02",
		--BaseChipmunkValue = -0.43,
		--[[SetupFunction = 
		{
			Name = "CirceEnlarge",
			Args = 
			{
				ScaleMultiplier = 1.25,
				InitialPresentationFunctionName = "CirceEnlargePresentation",
				ReportValues = 
				{
					ReportedScale = "Scale",
				},
			},
		},
		AddOutgoingDamageModifiers = 
		{
			ValidWeaponMultiplier = 1.15,
			ReportValues = {ReportedMultiplier = "ValidWeaponMultiplier"}
		},]]
		
		RoomsPerUpgrade = 
		{ 
			Amount = 1,
			MaxMana = 5,
			ReportValues = 
			{ 
				ReportedGrowth = "MaxMana", 
			},

		},
		CurrentRoom = 0,
		ExtractValues = 
		{
			{
				Key = "ReportedGrowth",
				ExtractAs = "GrowthValue",
				IncludeSigns = true,
			},
		},
	},
}

for key, growTrait in pairs(GrowTraits) do
	TraitData[key] = growTrait
end