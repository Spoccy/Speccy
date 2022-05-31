-- Speccy's Main Lua
-- Speccy - 2022

-- Don't take stuff from this Lua without getting my permission first.

-- Leveling function, pretty nice. It's from Disgea by the way... just with some edits.

rawset(_G, "newExpRequirement", function(p)
	return FixedRound(2621 * ((p.speccy.level+1) ^ 3) + 52428 * ((p.speccy.level+1) ^ 2) + 131070 * (p.speccy.level+1))/65535
end)

rawset(_G, "levelSpeccyUp", function(p)
	if p.mo and p.mo.valid then
		if p.mo.skin == "speccy" then
			p.speccy.level = $ + 1
			p.speccy.exp = $ - p.speccy.expreq
			p.speccy.expreq = newExpRequirement(p)
			p.speccy.maxhp = $ + 15 * (p.speccy.maxhp % (p.speccy.level+1))
		else
			error("cannot level up if you're not Speccy!", 2)
		end
	else
		error("cannot level up if you don't exist!", 2)
	end
end)

-- Boss Table, supports custom bosses by adding them after Speccy... maybe you can add them before, I don't know, maybe by rawsetting it yourself.
-- This is carried over from before the re-script.

-- Layout: [MT_MOBJNAME] = {"Boss Name", Damage, EXP reward}

rawset(_G, "adventureBossTable", {
	[MT_EGGMOBILE] = {"Egg Zapper", 25, 75},
	[MT_EGGMOBILE2] = {"Egg Slimer", 35, 150},
	[MT_EGGMOBILE3] = {"Sea Egg", 45, 175},
	[MT_EGGMOBILE4] = {"Egg Colosseum", 50, 250},
	[MT_FANG] = {"Fang the Sniper", 35, 500},
	[MT_METALSONIC_BATTLE] = {"Metal Sonic", 50, 750},
	[MT_CYBRAKDEMON] = {"Black Eggman", 100, 1000},
	[MT_CYBRAKDEMON_ELECTRIC_BARRIER] = {"Black Eggman's Barrier", 25, 0},
})

rawset(_G, "resetSpeccyVars", function(p)
	if p.mo and p.mo.valid then
		if p.mo.skin == "speccy" then
			p.speccy = {}
			p.speccy.maxhp = 100
			p.speccy.hp = p.speccy.maxhp
			p.speccy.level = 1
			p.speccy.exp = 0
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
			
				if p.speccy.exp >= p.speccy.expreq then
					levelSpeccyUp(p)
				end
			
			end
		end
	end
end)

-- Damage Handler

addHook("ShouldDamage", function(pmo, inf, mo, dmg, dmgtype)
	if pmo and pmo.valid then
		if pmo.skin == "speccy" then
			if pmo.player then
				local p = pmo.player
				if inf and inf.valid then
					if src and src.valid then
						if inf.type == src.type then
							if (src.flags & MF_BOSS) then
								if adventureBossTable[mo.type] ~= nil then
									p.speccy.hp = $ - adventureBossTable[mo.type][2]
								else
									p.speccy.hp = $ - 25
								end
								
								P_DoPlayerPain(p, mo, inf)
								p.powers[pw_flashing] = 3*TICRATE
							elseif (src.flags & MF_ENEMY) then
								p.speccy.hp = $ - P_RandomRange(5,10)
							end
						else
							p.speccy.hp = $ - P_RandomRange(10,15)
						end
					else
						p.speccy.hp = $ - P_RandomRange(10,15)
					end
				end
				return false
			end
		end
	end
end)

-- EXP Handler

addHook("MobjDeath", function(mo, inf, pmo)
	if pmo and pmo.valid then
		if pmo.player and pmo.player.speccy then
			if (mo.flags & MF_BOSS) then
				if adventureBossTable[mo.type] ~= nil then
					pmo.player.speccy.exp = $ + adventureBossTable[mo.type][3]
				else
					pmo.player.speccy.exp = $ + 25
				end
			elseif (mo.flags & MF_ENEMY) then
				pmo.player.speccy.exp = $ + P_RandomRange(2,5)
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

-- Hud stuff at the very bottom.
-- Seeing as people are going to be reading this maybe, I'll post on how to make a HUD.

-- In order to make a HUD, start with checking for the below:

if not speccyCustomHud then
  rawset(_G, "speccyCustomHud", {})
end

-- It makes sure that Speccy exists, and that her customHuds table exists.

-- Part 1: The Actual HUD.

-- Starting with the actual HUD here.
-- You'll be wanting to read a lot of Speccy's stats here so I made a list for you!

/*

    	p.speccy	- This is your main array, always check for this after making sure the player exists.
	p.speccy.hp - Your health.
	p.speccy.maxhp - Your maximum health.
	p.speccy.level - Your level.
	p.speccy.exp   - Your current EXP count. 
	p.speccy.expreq   - EXP needed to reach next level. p.exqreq - p.exp to get EXP left.

*/

-- ZELDA II-esque HUD

speccyCustomHud[#speccyCustomHud+1] = function(v, p)

	-- Black Bar for that nice feel.
	
	v.drawFill(0, 0, 320, 24, 31)

	-- HP BAR, on the left because Speccy has no Magic.

end

hud.add(speccyCustomHud[1], "game")
