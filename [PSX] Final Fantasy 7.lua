-- Definitions and relative addresses are referencing http://wiki.qhimm.com/view/FF7/Battle/Battle_Mechanics
rng_index = 0x62e18
rng_table = 0x62e10

enemies = {
	["levels"] = {
		[0]=0xf8589,
		[1]=0x0,
		[2]=0x0,
		[3]=0x0,
		[4]=0x0
	},
	["health"] = {
		[0]=0x0,
		[1]=0x0,
		[2]=0x0,
		[3]=0x0,
		[4]=0x0
	},
	["ATB"] = {
		[0]=0x0,
		[1]=0x0,
		[2]=0x0,
		[3]=0x0,
		[4]=0x0
	}
}

team = {
	["levels"] = {
		[0]=0xf83e9,
		[1]=0xf8451, 
		[2]=0xf84b9
	}, 
	["luck"] = {
		[0]=0xf83f5,
		[1]=0xf845d,
		[2]=0xf84c5
	}, 
	["charindex"] = {
		[0]=0x0,
		[1]=0x0,
		[2]=0x0 
	}, 
	["ATB"] = {
		[0]=0x0,
		[1]=0x0,
		[2]=0x0
	}, 
	["Limit"] = {
		[0]=0x0,
		[1]=0x0,
		[2]=0x0
	}
}

function getAeri(value) 
	if (value >= 0x100) then
		newvalue = value % 256
		getAeri(newvalue)
	elseif (value >=0) then
		timer = bit.band(bit.ror(value,4),1)
		if timer == 0 then
			return "Aeris"
		elseif timer == 1 then
			return "Aerith"
		else
			return "error in function getAeri() - timer is neither odd nor even"
		end
	else
		return "error in function getAeri() - was passed negative value"
	end
end

protags = {	
	[0] = "Cloud",
	[1] = "Barret",
	[2] = "Tifa",
	[3] = "The Slum Drunk", -- This gets overwritten by the GetAeri() function anyway
	[4] = "Red XIII",
	[5] = "Cait Sith",
	[6] = "Cid",
	[7] = "Yuffie", 	-- The Young Cloud/Sephiroth flags are unneccesary for the purposes of this script,
	[8] = "Vincent"		-- as those battles should only slow down to Sephiroth reviving Young Cloud.
} 

function generateCrit(luck, level, foelevel) 
	sum = mainmemory.read_u8(luck) + mainmemory.read_u8(level) - mainmemory.read_u8(foelevel)
	div = math.floor(sum / 4)	
	return div
end

function generateRNG(addr1, addr2, addr3)
	table_offset = mainmemory.read_s32_le(addr3)
	
	step1 = mainmemory.read_u8(addr2 + (table_offset + 1)) % 8
	step2 = mainmemory.read_u8(addr1 + step1)
	
	step3 = mainmemory.read_u8(addr2 + (table_offset + 2)) % 8
	step4 = mainmemory.read_u8(addr1 + step3)
	
	step5 = bit.lshift(step4, 0x8)
	step6 = step2 + step5
	return math.floor((step6*99)/0xFFFF)+1
end

while true do 
	--[[crit_table = {}
	for i = 0, 2 do
		for j = 0, 4 do
			crit_table[i][j] = generateCrit(team.luck[i], team.level[i], enemies.level[j]
		end
	end]]
	
	rindex = mainmemory.read_u8(rng_index)
	rvalue = mainmemory.read_u8(rng_table + rindex)
	
	crit_rng = generateRNG(0x83084, rng_table, rng_index)
	gui.text(0, 20, "RNG Index " .. rindex .. " = " .. rvalue)	
	gui.text(0, 40, "   Crit RNG = " .. crit_rng)	
	gui.text(0, 60, "   " .. getAeri(rvalue)) -- Pass rindex for version 1 behavior, pass rvalue for version 2 behaviour, pass crit_rng for version 3 bahevir.
	emu.frameadvance() 
end