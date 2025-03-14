return {
	version = 0,
	enabled = true,
	message = 'Hello World!',
	startingSize = 1.00,
	sizeGrowthPerRoom = 0.015,
	startingPitch = 0,
	voicePitchChangePerRoom = -0.024,
	voicePitchLowerLimit = -99, --impossibly low. change if you want a limit (reasonable is -1.1)
	voicePitchUpperLimit = 99, --impossibly high. change if you want a limit (reasonable is 1.1)
	growEveryXRooms = 2,
}
