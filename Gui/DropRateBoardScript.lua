local Module3D = require(game.ReplicatedStorage:WaitForChild("Module3D"))
local FruitData = require(game.Workspace.MainFolder_Workspace.Fruits.GachaTree.Data)
local Pets = game.ReplicatedStorage:WaitForChild("Pets")
local player = game.Players.LocalPlayer

game.ReplicatedStorage.Remotes.GameLoadingCompleted.OnClientEvent:Connect(function()
	local PlayerGui = player.PlayerGui
	local FruitsFrame = PlayerGui.DropRateBoard.Fruits
	for _, pet in ipairs(Pets:GetChildren()) do
		local PetDisplayFrame = FruitsFrame.ScrollingFrame.PetDisplayFrame:Clone()
		PetDisplayFrame.Name =  pet.Name
		
		PetDisplayFrame.DropRateFrame.Name = pet.Name .. "DropRate"
		PetDisplayFrame.Parent = FruitsFrame.ScrollingFrame
		PetDisplayFrame.UIStroke.UIGradient.Rotation = -45
		PetDisplayFrame.UIStroke.Thickness = 25
		--print(1)
		
		local Pet = player.PetLibrary:FindFirstChild(pet.Name)
		if Pet.rarity.Value == "Common" then
			PetDisplayFrame.UIStroke.UIGradient.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1))
			PetDisplayFrame:FindFirstChild(pet.Name .. "DropRate").DropRateText.Text = tostring(string.format("%.2f",FruitData.fruitPets.Common[1].chance)) .. "%" 
		elseif Pet.rarity.Value == "Uncommon" then
			PetDisplayFrame.UIStroke.UIGradient.Color = ColorSequence.new(Color3.new(0.0196078, 1, 0.0196078), Color3.new(1, 1, 1))
			PetDisplayFrame:FindFirstChild(pet.Name .. "DropRate").DropRateText.Text = tostring(string.format("%.2f",FruitData.fruitPets.Uncommon[1].chance)) .. "%" 
		elseif Pet.rarity.Value == "Rare" then
			PetDisplayFrame.UIStroke.UIGradient.Color = ColorSequence.new(Color3.new(0, 0.133333, 1), Color3.new(1, 1, 1))
			PetDisplayFrame:FindFirstChild(pet.Name .. "DropRate").DropRateText.Text = tostring(string.format("%.2f",FruitData.fruitPets.Rare[1].chance)) .. "%" 
		elseif Pet.rarity.Value == "Epic" then
			PetDisplayFrame.UIStroke.UIGradient.Color = ColorSequence.new(Color3.new(0.74902, 0, 1), Color3.new(1, 1, 1))
			PetDisplayFrame:FindFirstChild(pet.Name .. "DropRate").DropRateText.Text = tostring(string.format("%.2f",FruitData.fruitPets.Epic[1].chance)) .. "%" 
		elseif Pet.rarity.Value == "Legendary" then
			PetDisplayFrame.UIStroke.UIGradient.Color = ColorSequence.new(Color3.new(1, 0.968627, 0), Color3.new(1, 1, 1))
			PetDisplayFrame:FindFirstChild(pet.Name .. "DropRate").DropRateText.Text = tostring(string.format("%.2f",FruitData.fruitPets.Legendary[1].chance)) .. "%" 
		end


		local newpet = pet:Clone()
		local Model3D = Module3D:Attach3D(PetDisplayFrame,newpet)
		Model3D:SetDepthMultiplier(1.2)
		Model3D.Camera.FieldOfView = 5
		Model3D.Visible = true

		game:GetService("RunService").RenderStepped:Connect(function()
			Model3D:SetCFrame(CFrame.Angles(0,tick() % (math.pi * 2),0) * CFrame.Angles(math.rad(-10),0,0))
		end)
		--local Frame = Instance.new("Frame")
		--Frame.Name = "PetDisplayFrame"
	end

	PlayerGui.DropRateBoard.Fruits.ScrollingFrame.PetDisplayFrame.Visible = false
end)

--local Model3D = Module3D:Attach3D(Frame,Apple)
--Model3D:SetDepthMultiplier(1.2)
--Model3D.Camera.FieldOfView = 5
--Model3D.Visible = true

--game:GetService("RunService").RenderStepped:Connect(function()
--	Model3D:SetCFrame(CFrame.Angles(0,tick() % (math.pi * 2),0) * CFrame.Angles(math.rad(-10),0,0))
--end)