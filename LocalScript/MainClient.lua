-- Service
local player = game.Players.LocalPlayer
local tweenService = game.TweenService
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local remotes = replicatedStorage:WaitForChild("Remotes")

-- Model
local despawnedDrops = replicatedStorage:WaitForChild("DespawnedDrops")

-- UI
local purchaseDoor = player.PlayerGui:WaitForChild('PurchaseDoor')
local frames = player.PlayerGui:WaitForChild('Frames')

-- var
local areaBuyBtnConnection

local function destroyDrop(drop)
	task.wait(0.5)
	local money = drop.Parent
	local oldParent = drop.Parent
	
	local increasingMoney = money.Money.Value * (1 + player.leaderstats.Rebirth.Value / 2) * (1 + player.OnBoosting.Coins.Percentage.Value)
	
	drop.Parent= despawnedDrops
	
	local random = math.random(1,100)
	if random <= 20 * (1 + player.OnBoosting.Diamonds.Percentage.Value) then
		local increasingDiamond = 1
		remotes.UpdateDiamond:FireServer(increasingDiamond)
		task.wait(0.5)
	end
	
	remotes.UpdateMoney:FireServer(increasingMoney)
	task.wait(2)
	drop.Health.Value = drop.MaxHealth.Value
	drop.Parent = oldParent
	
end



task.spawn(function()

	while task.wait(0.5) do
		
		local damage=0
		
		for _, pet in pairs(workspace.MainFolder_Workspace.PlayerPets:FindFirstChild(player.Name):GetChildren()) do
			if pet.Attack.Value ~= nil then
				for _, frame in pairs(player.PlayerGui.Frames.FruitInventory.Frame.ScrollingFrame:GetChildren()) do
					if frame:IsA('Frame') then
						frame.ImageButton.Interactable = false
					end				
				end
				
				if pet.Attack.Value.Health.Value ~= 0 then
					damage = pet.Speed.Value
					
				end
				
				pet.Attack.Value.Health.Value = math.max(pet.Attack.Value.Health.Value - damage, 0)
				if pet.Attack.Value.Health.Value == 0 then
					remotes.StopDamaging:FireServer(pet)
					
					for _, frame in pairs(player.PlayerGui.Frames.FruitInventory.Frame.ScrollingFrame:GetChildren()) do
						if frame:IsA('Frame') then
							frame.ImageButton.Interactable = true
						end
					end
					
					coroutine.wrap(destroyDrop)(pet.Attack.Value)
				end
			end
		end
		
	end
end)

runService.Heartbeat:Connect(function()
	for _, drop in pairs(workspace:WaitForChild("MainFolder_Workspace"):WaitForChild("Drops"):GetDescendants()) do
		if drop:IsA("Model") then
			local healthDisplay = drop:FindFirstChild("HealthDisplay")
			local bar = healthDisplay.Background.Bar
			local healthDisplayText = healthDisplay.Background.HealthDisplayLabel
			
			healthDisplayText.Text = drop.Health.Value
			bar:TweenSize(UDim2.fromScale(drop.Health.Value/drop.MaxHealth.Value, 1), Enum.EasingDirection.Out,Enum.EasingStyle.Sine,0.3)
		end
	end
end)

remotes.UnAttackPet.OnClientEvent:Connect(function(petName)
	for _, pet in pairs(player.PlayerGui.PetsDisplayGUI.SelectedFruits.ScrollingFrame:GetChildren()) do
		if pet:IsA('Frame') then
			if pet.Name == petName and pet.PetDisplayFrame.ImageLabel.Visible == true then
				pet.PetDisplayFrame.ImageLabel.Visible = false
				break
			end
		end
	end
	
	local check = true
	for _, pet in pairs(workspace.MainFolder_Workspace.PlayerPets:FindFirstChild(player.Name):GetChildren()) do
		if pet.Attack.Value ~= nil then
			check = false
		end
	end
	
	if check == true then
		for _, frame in pairs(player.PlayerGui.Frames.FruitInventory.Frame.ScrollingFrame:GetChildren()) do
			if frame:IsA('Frame') then
				frame.ImageButton.Interactable = true
			end
		end
	end
end)

remotes.AttackingPet.OnClientEvent:Connect(function(petName)
	for _, pet in pairs(player.PlayerGui.PetsDisplayGUI.SelectedFruits.ScrollingFrame:GetChildren()) do
		if pet:IsA('Frame') then
			if pet.Name == petName and pet.PetDisplayFrame.ImageLabel.Visible == false then
				pet.PetDisplayFrame.ImageLabel.Visible = true
				break
			end
		end
	end
end)