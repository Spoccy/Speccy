// Speccy's Main Lua
// Speccy - 2022

// Don't take stuff from this Lua without getting my permission first.

-- Leveling function, pretty nice. It's from Disgea by the way... just with some edits.

rawset(_G, "newExpRequirement", function(p)
	return FixedRound(2621 * ((p.speccy.level+1) ^ 3) + 52428 * ((p.speccy.level+1) ^ 2) + 131070 * (p.speccy.level+1))/65535
end)

rawset(_G, "levelSpeccyUp", function(p)
	if p.mo and p.mo.valid then
		if p.mo.skin == "speccy" then
			p.speccy.level = $ + 1
			p.speccy.exp = 0
			p.speccy.expreq = newExpRequirement(p)
			p.speccy.maxhp
		else
			error("cannot level up if you're not Speccy!", 2)
		end
	else
		error("cannot level up if you don't exist!", 2)
	end
end

-- Boss Table, supports custom bosses by adding them after Speccy... maybe you can add them before, I don't know, maybe by rawsetting it yourself.

-- Layout: [MT_MOBJNAME] = {"Boss Name", Damage, EXP reward}

rawset(_G, "adventureBossTable", {
	[MT_EGGMOBILE] = {"Egg Zapper", 10, 25},
	[MT_EGGMOBILE2] = {"Egg Slimer", 10, 45},
	[MT_EGGMOBILE3] = {"Sea Egg", 15, 70},
	[MT_EGGMOBILE4] = {"Egg Colosseum", 15, 95},
	[MT_FANG] = {"Fang the Sniper", 25, 135},
	[MT_METALSONIC_BATTLE] = {"Metal Sonic", 35, 165},
	[MT_CYBRAKDEMON] = {"Black Eggman", 50, 200},
	[MT_CYBRAKDEMON_ELECTRIC_BARRIER] = {"Black Eggman's Barrier", 25, 0},
})

rawset(_G, "resetSpeccyVars", function(p)
	if p.mo and p.mo.valid then
		if p.mo.skin == "speccy" then
			p.speccy = {}
			p.speccy.maxhp = 100
			p.speccy.hp = p.speccy.maxhp
			p.speccy.level = 1
			p.speccy.xp = 0
			p.speccy.expreq = newExpRequirement(p)
		else
			error("cannot run resetSpeccyVars if you're not Speccy!", 2)
		end
	else
		error("cannot run resetSpeccyVars if you don't exist!", 2)
	end
end)

addHook("PlayerThink", function(p)
	if p.mo and p.mo.valid then
		if p.mo.skin == "speccy" then
			if p.speccy == nil then
				resetSpeccyVars(p)
			else
				print(p.speccy.expreq)
			end
		end
	end
end)

-- Something to make the Metal Sonic boss easier for Speccy, given to me by Jon.

addHook("MobjMoveCollide", function(mo, pmo)
    if not (pmo.skin == "speccy") or (pmo.z > mo.z + mo.height + FRACUNIT) or (mo.z > pmo.z + pmo.height) then return end
    if mo.state == S_METALSONIC_FLOAT
        mo.flags2 = $|MF2_CLASSICPUSH
    end
end, MT_METALSONIC_BATTLE)