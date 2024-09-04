-- Service
local replicatedStorage = game:GetService("ReplicatedStorage")
local dataStoreService = game:GetService('DataStoreService')
local players = game:GetService("Players")

-- DataStore
local playerInventory = dataStoreService:GetDataStore('playerInventory')
local playerCoins = dataStoreService:GetDataStore('playerInventory', 'Coins')
local playerDiamonds = dataStoreService:GetDataStore('playerInventory', 'Diamonds')
local playerPets = dataStoreService:GetDataStore('playerInventory', 'Pets')
local playerDailyGift = dataStoreService:GetDataStore('playerInventory', 'DailyGift')

-- ReplicatedStorage
local remotes = replicatedStorage.Remotes

-- Workspace
local fruit = workspace.MainFolder_Workspace.Fruits.GachaTree
local gachaArea = workspace.MainFolder_Workspace.GachaArea:WaitForChild('GachaArea')
local anima=fruit:WaitForChild("Animation")
local gacha=fruit:WaitForChild("Gacha")
local humanoid=fruit:WaitForChild("Humanoid")
local idle=humanoid:LoadAnimation(anima)
local gacha=humanoid:LoadAnimation(gacha)

-- Module
local fruitData = require(fruit.Data)
local tableFunction = require(replicatedStorage.TableFunction)

-- Var
local playerFetchDebounce = {}
local touchedGachaArea = {}

local common = 0
local uncommon = 0
local rare = 0
local epic = 0
local legendary = 0

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- FUNCTION

local function chooseRandomPet(petTable, boostNum, kind)
	local chosenPet = nil
	local randomNumber = math.random(1,100)
	local weight = 0
	local rarity

	local EpicBoostValue = 0
	local LegendaryBoostValue = 0

	if boostNum == 1 then
		if kind == 'Legendary' then
			LegendaryBoostValue = 1
		else
			EpicBoostValue = 1
		end
	elseif boostNum == 2 then
		EpicBoostValue = 1
		LegendaryBoostValue = 1
	end

	if 0 < randomNumber and fruitData.commonDropRate - 2 * boostNum >= randomNumber then
		rarity = 'Common'
	elseif fruitData.commonDropRate - 2 * boostNum < randomNumber and randomNumber <= fruitData.commonDropRate + fruitData.uncommonDropRate - 4 * boostNum then
		rarity = 'Uncommon'
	elseif fruitData.commonDropRate + fruitData.uncommonDropRate - 4 * boostNum < randomNumber and randomNumber <= fruitData.commonDropRate + fruitData.uncommonDropRate + fruitData.rareDropRate - 5 * boostNum then
		rarity = 'Rare'
	elseif fruitData.commonDropRate + fruitData.uncommonDropRate + fruitData.rareDropRate - 5 * boostNum < randomNumber and randomNumber <= fruitData.commonDropRate + fruitData.uncommonDropRate + fruitData.rareDropRate + fruitData.epicDropRate - 5 * LegendaryBoostValue then
		rarity = 'Epic'
	elseif fruitData.commonDropRate + fruitData.uncommonDropRate + fruitData.rareDropRate + fruitData.epicDropRate - 5 * LegendaryBoostValue < randomNumber and randomNumber <= fruitData.commonDropRate + fruitData.uncommonDropRate + fruitData.rareDropRate + fruitData.epicDropRate + fruitData.legendaryDropRate then
		rarity = 'Legendary'
	end

	local petGroup = fruitData.fruitPets[rarity]
	local number = table.maxn(petGroup)

	chosenPet = petGroup[math.random(1,number)]

	return chosenPet
end

function gachaFruit(player)
	local legendaryBoost = player.LegendaryBoost.Value
	local epicBoost = player.EpicBoost.Value
	local BoostNumber = legendaryBoost + epicBoost
	local kind = ''

	if BoostNumber == 1 then
		if legendaryBoost == 1 then
			kind = 'Legendary'
		else
			kind = 'Epic'
		end
	end

	local chosenPet = chooseRandomPet(fruitData.fruitPets, BoostNumber, kind)

	local val = Instance.new("StringValue")
	val.Name = tostring(chosenPet.Name)
	val.Parent = player.Pets
	val.Value = chosenPet.Stt

	return chosenPet
end

-- Update Gold
function updateGold(player, price)
	local success, newCoinsValue = pcall(function()
		return playerCoins:IncrementAsync(player.UserId, (-1) * price)
	end)
	if success then
		player.leaderstats.Coins.Value = newCoinsValue
	end	
end

-- Update pet
function updatePet(player, tableOfGachaFruits)
	local success, currentPets = pcall(function()
		return playerPets:GetAsync(player.UserId)
	end)
	if success then
		for _, pet in pairs(tableOfGachaFruits) do
			currentPets[pet.Name].Number += 1
			currentPets[pet.Name].Status = 1
			player.PetLibrary:FindFirstChild(pet.Name).number.Value += 1
			player.PetLibrary:FindFirstChild(pet.Name).status.Value = 1
		end
		print(currentPets)

		local sc, newPets = pcall(function()
			return playerPets:SetAsync(player.UserId, currentPets)
		end)
		print(sc)
		if sc then
			print(newPets)
			remotes.PetLibrary:FireClient(player)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- REMOTES

remotes.Gachax1.OnServerEvent:Connect(function(player)
	local tableOfGachaFruits = {} 
	local price = fruitData.fruitPrice * (1 + player.leaderstats.Rebirth.Value)
	local currency = fruitData.fruitCurrency

	gacha:Play()
	idle:Stop()

	local chosenPet = gachaFruit(player)
	table.insert(tableOfGachaFruits, chosenPet)
	idle:Play()

	-- Update Gold
	updateGold(player, price)
	-- Update Pet
	updatePet(player, tableOfGachaFruits)

	remotes.FetchFruit:FireClient(player, tableOfGachaFruits)
	remotes.UpdateCurrencyClient:FireClient(player)
end)

remotes.Gachax10.OnServerEvent:Connect(function(player)
	local tableOfGachaFruits = {}
	local price = fruitData.fruitPrice * (1 + player.leaderstats.Rebirth.Value)
	local currency = fruitData.fruitCurrency

	gacha:Play()

	for i = 1, 10 do
		local chosenPet = gachaFruit(player)
		table.insert(tableOfGachaFruits, chosenPet)
	end
	-- Update Gold
	updateGold(player, price)
	-- Update Pet
	updatePet(player, tableOfGachaFruits)

	remotes.FetchFruit:FireClient(player, tableOfGachaFruits)
	remotes.UpdateCurrencyClient:FireClient(player)
end)

remotes.SellFruit.OnServerEvent:Connect(function(player, list, price)
	-- Update Pets
	local success, currentPets = pcall(function()
		return playerPets:GetAsync(player.UserId)
	end)
	if success then
		for _, pet in pairs(list) do
			currentPets[pet.Name].Number = pet.number.Value
		end
		local success, errormess = pcall(function()
			playerPets:SetAsync(player.UserId, currentPets)
		end)
		if success then
			print('Sold pets!')
		end
	end

	-- Update Coins
	local success, newCoinsValue = pcall(function()
		return playerCoins:IncrementAsync(player.UserId, price)
	end)
	if success then
		player.leaderstats.Coins.Value = newCoinsValue
	end

	remotes.UpdateCurrencyClient:FireClient(player)
end)

-- Nhận quà hằng ngày
remotes.ClaimDailyGifts.OnServerEvent:Connect(function(player, giftName)
	local success, currentDailyGift = pcall(function()
		return playerDailyGift:GetAsync(player.UserId)
	end)

	if success then
		currentDailyGift[giftName].Received = 1
		local success, errormess = pcall(function()
			return playerDailyGift:SetAsync(player.UserId, currentDailyGift)
		end)

		if success then
			local success, newDailyGift = pcall(function()
				return playerDailyGift:GetAsync(player.UserId)
			end)
			if success then
				player.DailyGiftReceived:FindFirstChild(giftName).Value = 1
				if newDailyGift[giftName].Gold > 0 then
					local success, newCoinsValue = pcall(function()
						return playerCoins:IncrementAsync(player.UserId, newDailyGift[giftName].Gold)
					end)
					if success then
						player.leaderstats.Coins.Value = newCoinsValue
					end
				end

				if newDailyGift[giftName].Diamond > 0 then
					local success, newDiamondValue = pcall(function()
						return playerDiamonds:IncrementAsync(player.UserId, newDailyGift[giftName].Diamond)
					end)
					if success then
						player.leaderstats.Diamonds.Value = newDiamondValue
					end
				end

				if newDailyGift[giftName].Gacha > 0 then
					local tableOfGachaFruits = {}
					gacha:Play()

					for i = 1, 10 do
						local chosenPet = gachaFruit(player)
						table.insert(tableOfGachaFruits, chosenPet)
					end

					-- Update Pet
					updatePet(player, tableOfGachaFruits)
					remotes.FetchFruit:FireClient(player, tableOfGachaFruits)
				end
			end
		end
	end

	remotes.UpdateCurrencyClient:FireClient(player)
end)

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- ACTION

gachaArea.Touched:Connect(function(hit)
	local character = hit.Parent
	if character then
		local player = players:FindFirstChild(character.Name)
		if player then
			remotes.GachaWindowOpen:FireClient(player)
			task.wait(1)
		end
	end
end)

players.PlayerRemoving:Connect(function(player)
	if playerFetchDebounce[player] then
		playerFetchDebounce[player] = nil
	end
end)

