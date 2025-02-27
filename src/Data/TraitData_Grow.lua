---@diagnostic disable: undefined-global

print("Hello...?")

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

print("Anyone there...?")

for key, growTrait in pairs(GrowTraits) do
	print("Did this run at all...?")
	TraitData[key] = growTrait
end

print("We good?")