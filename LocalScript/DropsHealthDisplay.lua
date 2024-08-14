-- Service
local player = game.Players.LocalPlayer

-- Model
local doors = game.Workspace.MainFolder_Workspace.Doors

-- Data
local areasData = require(game.ReplicatedStorage.JSON.AreasData)

-- UI
local teleport = player:WaitForChild('PlayerGui'):WaitForChild('Frames').Teleport

local function Invisible(Door)
	Door.CanCollide = false
	Door.Transparency = 1
end

local function Visible(Door)
	Door.CanCollide = true
	Door.Transparency = 0
end

while true do
	for _, detail in pairs(areasData) do
		local door = doors:FindFirstChild(detail.Door)		

		if door then
			if player.Level.Value >= detail.Location then -- Door
				Invisible(door)
			else 
				Visible(door)
			end	
		end
	end
	task.wait(1)
end


