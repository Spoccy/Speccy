freeslot("SPR2_SCRH", "S_PLAY_SPECCROUCH", "MT_CARBONWING", "SPR_CWNG", "S_CARBON_WING", "MT_SPECADVENTBOMB")

states[S_PLAY_SPECCROUCH] = {

	sprite = SPR_PLAY,
	frame = SPR2_SCRH|A,
	tics = -1,
	nextstate = S_NULL

}

states[S_CARBON_WING] = {

	sprite = SPR_CWNG,
	frame = A|FF_PAPERSPRITE,
	tics = -1,
	nextstate = S_NULL

}

mobjinfo[MT_CARBONWING] = {
	spawnstate = S_CARBON_WING,
	spawnhealth = 1,
	radius = 16*FRACUNIT,
	height = 32*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_NOCLIPTHING|MF_NOCLIPHEIGHT
}

mobjinfo[MT_SPECADVENTBOMB] = {
	spawnstate = mobjinfo[MT_FBOMB].spawnstate,
	spawnhealth = 1,
	radius = 16*FRACUNIT,
	height = 32*FRACUNIT,
	flags = MF_NOCLIPTHING
}