-- Service
local dataStoreService = game:GetService('DataStoreService')
local replicatedStorage = game:GetService('ReplicatedStorage')
local tweenService = game:GetService('TweenService')

-- DataStore
local playerInventory = dataStoreService:GetDataStore('playerInventory')
local playerCoins = dataStoreService:GetDataStore('playerInventory', 'Coins')
local playerDiamonds = dataStoreService:GetDataStore('playerInventory', 'Diamonds')
local playerLevel = dataStoreService:GetDataStore('playerInventory', 'Level')
local playerTasks = dataStoreService:GetDataStore('playerInventory', 'Tasks')
local playerEpicBoost = dataStoreService:GetDataStore('playerInventory', 'EpicBoost')
local playerLegendaryBoost = dataStoreService:GetDataStore('playerInventory', 'LegendaryBoost')

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

-- Claim Gifts
remotes.ClaimTasksGift.OnServerEvent:Connect(function(player, kind, taskName)
	local success, currentTasks = pcall(function()
		return playerTasks:GetAsync(player.UserId)
	end)
	if success then
		currentTasks[kind][taskName].Received = 1
		local success, errormess = pcall(function()
			return playerTasks:SetAsync(player.UserId, currentTasks)
		end)
		if success then
			local success, newTasks = pcall(function()
				return playerTasks:GetAsync(player.UserId)
			end)
			if success then
				print(newTasks)
				if kind == 'DailyTasks' then
					player.DailyTasksReceived:FindFirstChild(taskName).Value = newTasks[kind][taskName].Received
				end

				-- Update Coins
				local success, newCoinsValue = pcall(function()
					return playerCoins:IncrementAsync(player.UserId, newTasks[kind][taskName].Gifts.Coins.Value)
				end)
				if success then
					player.leaderstats.Coins.Value = newCoinsValue
					remotes.UpdateCurrencyClient:FireClient(player)
				end

				-- Update Diamond
				local success, newDiamondValue = pcall(function()
					return playerDiamonds:IncrementAsync(player.UserId, newTasks[kind][taskName].Gifts.Diamonds.Value)
				end)
				if success then
					player.leaderstats.Diamonds.Value = newDiamondValue
					remotes.UpdateCurrencyClient:FireClient(player)
				end
			end
		end
	end
end)

-- Shop Purchase
remotes.ProductsProcessing.OnServerEvent:Connect(function(player, kind, indexNum)
	local storeData = require(replicatedStorage.JSON.StoreData)
	local productDetail = storeData[kind][indexNum]

	if productDetail.Id == '' then -- Không mua bằng robux
		if productDetail.Currency == 'Diamonds' then
			local success, updatedDiamonds = pcall(function()
				return playerDiamonds:IncrementAsync(player.UserId, (-1) * productDetail.Price)
			end)
			if success then
				player.leaderstats.Diamonds.Value = updatedDiamonds
				remotes.UpdateCurrencyClient:FireClient(player)
			end
		elseif productDetail.Currency == 'Coins' then
			local success, updatedCoins = pcall(function()
				return playerCoins:IncrementAsync(player.UserId, (-1) * productDetail.Price)
			end)
			if success then
				player.leaderstats.Coins.Value = updatedCoins
				remotes.UpdateCurrencyClient:FireClient(player)
			end
		end

		if kind == 'Gold' then
			local success, updatedCoins = pcall(function()
				return playerCoins:IncrementAsync(player.UserId, productDetail.Value)
			end)
			if success then
				player.leaderstats.Coins.Value = updatedCoins
				remotes.UpdateCurrencyClient:FireClient(player)
			end
		elseif kind == 'Boost' then
			player.OnBoosting:FindFirstChild(productDetail.Individual).Percentage.Value += productDetail.Value

			local product = Instance.new('IntValue')
			product.Name = productDetail.Name
			product.Parent = player.OnBoosting:FindFirstChild(productDetail.Individual)
			product.Value = productDetail.Time

			coroutine.wrap(limitTime)(player, product, productDetail)
		end
	else -- mua bằng robux
		if kind == 'Diamond' then
			local success, updatedDiamonds = pcall(function()
				return playerDiamonds:IncrementAsync(player.UserId, productDetail.Value)
			end)
			if success then
				player.leaderstats.Diamonds.Value = updatedDiamonds
				remotes.UpdateCurrencyClient:FireClient(player)
			end
		elseif kind == 'Boost' then
			if productDetail.Individual == 'Epic' then
				local success, errormess = pcall(function()
					playerEpicBoost:SetAsync(player.UserId, 1)
				end)
				if success then
					player.EpicBoost.Value = 1
				end
			elseif productDetail.Individual == 'Legendary' then
				local success, errormess = pcall(function()
					playerLegendaryBoost:SetAsync(player.UserId, 1)
				end)
				if success then
					player.LegendaryBoost.Value = 1
				end
			end
		end
	end
end)

function limitTime(player, product, productDetail)
	while product.Value > 0 do
		task.wait(1)
		product.Value -= 1
	end

	player.OnBoosting:FindFirstChild(productDetail.Individual).Percentage.Value /= (1 + productDetail.Value)
end

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
	local success, errormess = pcall(function()
		playerCoins:SetAsync(player.UserId, coins)
	end)
	if success then
		local success, updatedCoins = pcall(function()
			return playerCoins:GetAsync(player.UserId)
		end)
		if success then
			player.leaderstats.Coins.Value = updatedCoins
		end
	end

	-- Update Level
	local success, errormess = pcall(function()
		return playerLevel:SetAsync(player.UserId, level)
	end)
	if success then
		local success, newLevel = pcall(function()
			return playerLevel:GetAsync(player.UserId)
		end)
		if success then
			player.Level.Value = newLevel
		end
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
