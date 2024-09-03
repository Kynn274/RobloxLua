local player = game.Players.LocalPlayer

local Drops = game.Workspace.MainFolder_Workspace.Drops

for _, area in pairs(Drops:GetChildren()) do
	if area:IsA('Folder') then
		for _, lootModel in pairs(area:GetChildren()) do
			if lootModel:IsA('Model') then
				lootModel.HealthDisplay.MaxDistance = 30
			end
		end
	end
end