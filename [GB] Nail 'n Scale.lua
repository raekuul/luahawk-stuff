faceTable = {
	[0] = "N/A",
	[1] = "Right",
	[2] = "Left",
	[3] = "Up",
	[4] = "Down"
}

spike = {}
nail1 = {}
nail2 = {}

function drawInformation()
	gui.DrawNew("native")
	
	spike.X = mainmemory.read_u8(0x00A8)
	spike.Y = mainmemory.read_u8(0x00A7)
	spike.F = mainmemory.read_u8(0x0344)
	
	if spike.F > 4 then
		spike.F = 0
	end
	
	nail1.y = mainmemory.read_u8(0x00C7)
	nail1.x = mainmemory.read_u8(0x00C8)
	nail2.y = mainmemory.read_u8(0x00E7)
	nail2.x = mainmemory.read_u8(0x00E8)
	gui.drawText(10, 10,"Coordinates: \nSpike: " .. spike.X .. ", " .. spike.Y .. ", " .. faceTable[spike.F] .. "\nNail 1: " .. nail1.x .. ", " .. nail1.y .. "\nNail 2: " .. nail2.x .. ", " .. nail2.y)
	
	
end

while true do
	drawInformation()
	emu.frameadvance()
end