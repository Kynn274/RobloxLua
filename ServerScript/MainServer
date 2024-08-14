local Players = game:GetService("Players")
local DataStoreService = game:GetService('DataStoreService')
local DataStore = DataStoreService:GetDataStore('MyDataStore1')
local tweenService = game.TweenService

local mainFolder_Workspace = workspace.MainFolder_Workspace
local playerPets = mainFolder_Workspace.PlayerPets
local areasData = require(game.ReplicatedStorage.JSON.AreasData)
local drops = mainFolder_Workspace.Drops
local t=1
local touched = 0

Players.PlayerAdded:Connect(function(player)
	local folder = Instance.new("Folder")
	folder.Name = player.Name
	folder.Parent = playerPets

	for _,v in pairs(script.PlayerData:GetChildren()) do
		v:Clone().Parent = player
	end
end)

Players.PlayerRemoving:Connect(function(player)
	if playerPets:FindFirstChild(player.Name) then
		playerPets:FindFirstChild(player.Name):Destroy()
	end
end)

-- Drop attack 
game.ReplicatedStorage.Remotes.StopDamaging.OnServerEvent:Connect(function(player, pet)
	pet.Attack.Value = nil
	game.ReplicatedStorage.Remotes.UnAttackPet:FireClient(player, pet.Name)
end)

function returnt(t)
	t=t-1
	return t
end

for _, drop in pairs(drops:GetDescendants()) do
	if drop:IsA("Model") then
		--print(1)
		drop.Health.Value = drop.MaxHealth.Value
		
		drop.ClickDetector.MouseClick:Connect(function(player)
			
			local currentPlayerPets = playerPets[player.Name]
			
			if #currentPlayerPets:GetChildren() > 0 then
				local check = false
				
				for _, pet in pairs(currentPlayerPets:GetChildren()) do
					if pet.Attack.Value == nil then
						pet.Attack.Value = drop
						game.ReplicatedStorage.Remotes.AttackingPet:FireClient(player, pet.Name)
						check = true
						task.wait(0.5)
						break
					end
				end
				
				if check == false then
					for _, pet in pairs(currentPlayerPets:GetChildren()) do
						pet.Attack.Value = nil
						game.ReplicatedStorage.Remotes.UnAttackPet:FireClient(player, pet.Name)
					end
				end						
			end
		end)
	end
end

-- Update Data
function updateData(player, coins, level)
	player.leaderstats.Coins.Value = coins
	player.Level.Value = level
	
	local Data = DataStore:GetAsync(tostring(player.UserId))
	Data.Coins = coins
	Data.Level = level
	DataStore:SetAsync(tostring(player.UserId), Data)
	
	game.ReplicatedStorage.Remotes.GetPlayerData:FireClient(player, Data)
	touched = 0
end

-- Equip pets
game.ReplicatedStorage.Remotes.EquipPet.OnServerEvent:Connect(function(player, petName)
	print(petName)
	if player.Pets:FindFirstChild(petName) then
		local petModel = game.ReplicatedStorage.Pets:FindFirstChild(petName):Clone()
		petModel.Parent = workspace.MainFolder_Workspace.PlayerPets:FindFirstChild(player.Name)
		
		local Speed = Instance.new('IntValue')
		Speed.Name = 'Speed'
		Speed.Parent = petModel
		Speed.Value = player.PetLibrary:FindFirstChild(petName).damage.Value
	end
end)

game.ReplicatedStorage.Remotes.UnequipPets.OnServerEvent:Connect(function(player, petName)
	workspace.MainFolder_Workspace.PlayerPets:FindFirstChild(player.Name):FindFirstChild(petName):Destroy()
end)

-- Tele
game.ReplicatedStorage.Remotes.Tele.OnServerEvent:Connect(function(player, area)
	local playerModel = game.Workspace:WaitForChild(player.Name)
	local checkpoints = game.Workspace.MainFolder_Workspace.Checkpoint
	local spawnLocation = checkpoints:FindFirstChild(area).SpawnLocation 
	
	playerModel.HumanoidRootPart.CFrame = CFrame.new(spawnLocation.Position.X, spawnLocation.Position.Y + 2, spawnLocation.Position.Z)
end)

-- Purchase Door 
game.ReplicatedStorage.Remotes.PurchaseDoor.OnServerEvent:Connect(function(player, coins, level)
	updateData(player, coins, level)
end)

for _, door in pairs(game.Workspace.MainFolder_Workspace.Doors:GetChildren()) do
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
				game.ReplicatedStorage.Remotes.RequestPurchaseDoor:FireClient(player, door.Name)
			end
			
			number = 0
		end	
	end
	
	door.Touched:Connect(onTouch)
	door.TouchEnded:Connect(onTouchEnded)
end
