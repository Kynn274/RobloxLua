local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local MapSpawn = workspace.MainFolder_Workspace.Checkpoint.StarterArea.SpawnLocation

RunService.Stepped:Connect(function ()
	for _, p in pairs(Players:GetPlayers()) do
		local Character = p.Character;
		if (Character) then
			local RootPart = Character:FindFirstChild("HumanoidRootPart")
			if (RootPart) then 
				if (RootPart.Position.Y <= -90) then
					local Orientation = RootPart.CFrame - RootPart.Position;
					RootPart.CFrame = CFrame.new(MapSpawn.Position.X, MapSpawn.Position.Y + MapSpawn.Size.Y + 3, MapSpawn.Position.Z) * Orientation;
					local BodyPosition = Instance.new("BodyPosition")
					BodyPosition.Position = RootPart.Position
					BodyPosition.MaxForce = Vector3.new(0, math.huge, 0)
					BodyPosition.Parent = RootPart
					Debris:AddItem(BodyPosition, 1)
				end
			end
		end
	
	end
end)