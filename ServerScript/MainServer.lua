-- Service
local dataStoreService = game:GetService('DataStoreService')
local replicatedStorage = game:GetService('ReplicatedStorage')
local tweenService = game:GetService('TweenService')

-- DataStore
local playerInventory = dataStoreService:GetDataStore('playerInventory')
local playerCoins = dataStoreService:GetDataStore('playerInventory', 'Coins')
local playerDiamonds = dataStoreService:GetDataStore('playerInventory', 'Diamonds')
local playerLevel = dataStoreService:GetDataStore('playerInventory', 'Level')

-- ReplicatedStorage
local remotes = replicatedStorage.Remotes

-- Workspace
local mainFolder_Workspace = workspace.MainFolder_Workspace
local playerPets = mainFolder_Workspace.PlayerPets
local drops = mainFolder_Workspace.Drops

-- Data
local areasData = require(replicatedStorage.JSON.AreasData)

-- Var
local t = 1
local touched = 0

game.Players.PlayerAdded:Connect(function(player)
	local folder = Instance.new("Folder")
	folder.Name = player.Name
	folder.Parent = playerPets

	for _,v in pairs(script.PlayerData:GetChildren()) do
		v:Clone().Parent = player
	end
end)

game.Players.PlayerRemoving:Connect(function(player)
	if playerPets:FindFirstChild(player.Name) then
		playerPets:FindFirstChild(player.Name):Destroy()
	end
end)

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- REMOTES

-- Drop attack 
remotes.StopDamaging.OnServerEvent:Connect(function(player, pet)
	pet.Attack.Value = nil
	game.ReplicatedStorage.Remotes.UnAttackPet:FireClient(player, pet.Name)
end)

-- Equip pets
remotes.EquipPet.OnServerEvent:Connect(function(player, petName)
	print(petName)
	if player.Pets:FindFirstChild(petName) then
		local petModel = replicatedStorage.Pets:FindFirstChild(petName):Clone()
		petModel.Parent = playerPets:FindFirstChild(player.Name)
		
		local Speed = Instance.new('IntValue')
		Speed.Name = 'Speed'
		Speed.Parent = petModel
		Speed.Value = player.PetLibrary:FindFirstChild(petName).damage.Value
	end
end)

remotes.UnequipPets.OnServerEvent:Connect(function(player, petName)
	playerPets:FindFirstChild(player.Name):FindFirstChild(petName):Destroy()
end)

-- Tele
remotes.Tele.OnServerEvent:Connect(function(player, area)
	local playerModel = game.Workspace:WaitForChild(player.Name)
	local checkpoints = mainFolder_Workspace.Checkpoint
	local spawnLocation = checkpoints:FindFirstChild(area).SpawnLocation 
	
	playerModel.HumanoidRootPart.CFrame = CFrame.new(spawnLocation.Position.X, spawnLocation.Position.Y + 2, spawnLocation.Position.Z)
end)
-- 
-- Purchase Door 
remotes.PurchaseDoor.OnServerEvent:Connect(function(player, coins, level)
	updateData(player, coins, level)
end)
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- FUNCTION

function returnt(t)
	return t - 1
end

for _, drop in pairs(drops:GetDescendants()) do
	if drop:IsA("Model") then
		drop.Health.Value = drop.MaxHealth.Value		
		drop.ClickDetector.MouseClick:Connect(function(player)
			local currentPlayerPets = playerPets[player.Name]
			
			if #currentPlayerPets:GetChildren() > 0 then
				local check = false
				
				for _, pet in pairs(currentPlayerPets:GetChildren()) do
					if pet.Attack.Value == nil then
						pet.Attack.Value = drop
						remotes.AttackingPet:FireClient(player, pet.Name)
						check = true
						task.wait(0.5)
						break
					end
				end
				
				if check == false then
					for _, pet in pairs(currentPlayerPets:GetChildren()) do
						pet.Attack.Value = nil
						remotes.UnAttackPet:FireClient(player, pet.Name)
					end
				end						
			end
		end)
	end
end

-- Update Data
function updateData(player, coins, level)
	-- Update Coins
	local success, newCoinsValue = pcall(function()
		return playerCoins:UpdateAsync(player.UserId, coins)
	end)
	if success then
		player.leaderstats.Coins.Value = newCoinsValue
	end

	-- Update Level
	local success, newLevel = pcall(function()
		return playerLevel:UpdateAsync(player.UserId, level)
	end)
	if success then
		player.Level.Value = newLevel
	end

	remotes.UpdateCurrencyClient:FireClient(player)
	touched = 0
end

for _, door in pairs(mainFolder_Workspace.Doors:GetChildren()) do
	local number = 0
	local touchedNumber = 0
	local playerModel

	function onTouch(hit)
		number = 1
		
		local plr = hit.Parent
		local player = game.Players:FindFirstChild(plr.Name)
		
		if player then
			playerModel = game.Workspace:WaitForChild(player.Name)
		end
		touchedNumber += 1
	end
	
	function onTouchEnded(hit)
		touchedNumber -= 1
		
		if number == 1 and touchedNumber == 0 and playerModel then
			local player = game.Players:FindFirstChild(playerModel.Name)
			local area = areasData[areasData[door.Name].NextArea]

			if player and player.Level.Value < area.Location then
				remotes.RequestPurchaseDoor:FireClient(player, door.Name)
			end
			
			number = 0
		end	
	end
	
	door.Touched:Connect(onTouch)
	door.TouchEnded:Connect(onTouchEnded)
end
