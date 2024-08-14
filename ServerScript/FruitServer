local replicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService('DataStoreService')
local DataStore = DataStoreService:GetDataStore('MyDataStore1')
local players = game:GetService("Players")

local remotes = replicatedStorage.Remotes
local fruit = workspace.MainFolder_Workspace.Fruits.GachaTree
local playerFetchDebounce = {}
local petsData = require(replicatedStorage.JSON.PetsData)
local anima=fruit:WaitForChild("Animation")
local gacha=fruit:WaitForChild("Gacha")
local humanoid=fruit:WaitForChild("Humanoid")
local idle=humanoid:LoadAnimation(anima)
local gacha=humanoid:LoadAnimation(gacha)
local fruitData = require(fruit.Data)

local common = 0
local uncommon = 0
local rare = 0
local epic = 0
local legendary = 0

local pets = require(game.Workspace.MainFolder_Workspace.Fruits.GachaTree.Data)

local function chooseRandomPet(petTable)
	local chosenPet = nil
	local randomNumber = math.random(1,100)
	local weight = 0
	local rarity
	
	--print("RandomNumber :"..tostring(randomNumber) ) -- tonumber()

	--for i,v in pairs(petTable) do
	--	weight += v.chance
	--	print("Weight :"..tostring(weight) )
		
	--	if weight >= randomNumber then
	--		print(v)
	--		chosenPet = v
	--		break
	--	end
	--end

	if 0 < randomNumber and pets.commonDropRate >= randomNumber then
		rarity = 'Common'
	elseif pets.commonDropRate < randomNumber and randomNumber <= pets.commonDropRate + pets.uncommonDropRate then
		rarity = 'Uncommon'
	elseif pets.commonDropRate + pets.uncommonDropRate < randomNumber and randomNumber <= pets.commonDropRate + pets.uncommonDropRate + pets.rareDropRate then
		rarity = 'Rare'
	elseif pets.commonDropRate + pets.uncommonDropRate + pets.rareDropRate < randomNumber and randomNumber <= pets.commonDropRate + pets.uncommonDropRate + pets.rareDropRate + pets.epicDropRate then
		rarity = 'Epic'
	elseif pets.commonDropRate + pets.uncommonDropRate + pets.rareDropRate + pets.epicDropRate < randomNumber and randomNumber <= pets.commonDropRate + pets.uncommonDropRate + pets.rareDropRate + pets.epicDropRate + pets.legendaryDropRate then
		rarity = 'Legendary'
	end
	
	local petGroup = pets.fruitPets[rarity]
	local number = table.maxn(petGroup)

	chosenPet = petGroup[math.random(1,number)]
	
	return chosenPet
end

function gachaFruit(player)

	local chosenPet = chooseRandomPet(fruitData.fruitPets)
	local val = Instance.new("StringValue")
	val.Name = tostring(chosenPet.Name)
	val.Parent = player.Pets
	val.Value = chosenPet.Stt

	return chosenPet
end

fruit.ProximityPart.ProximityPrompt.Triggered:Connect(function(player)
	remotes.GachaWindowOpen:FireClient(player)
end)

remotes.Gachax1.OnServerEvent:Connect(function(player)
	local tableOfGachaFruits = {} 
	local price = fruitData.fruitPrice
	local currency = fruitData.fruitCurrency

	gacha:Play()
	idle:Stop()

	player.leaderstats[currency].Value -= price
	
	local chosenPet = gachaFruit(player)
	table.insert(tableOfGachaFruits, chosenPet)
	print(tableOfGachaFruits)
	idle:Play()

	-- Update Gold
	updateGold(player)
	-- Update Pet
	updatePet(player, tableOfGachaFruits)

	remotes.FetchFruit:FireClient(player, tableOfGachaFruits)
end)

remotes.Gachax10.OnServerEvent:Connect(function(player)
	local tableOfGachaFruits = {}
	local price = fruitData.fruitPrice
	local currency = fruitData.fruitCurrency
	
	gacha:Play()
	
	player.leaderstats[currency].Value -= (price * 10)
	for i = 1, 10 do
		local chosenPet = gachaFruit(player)
		table.insert(tableOfGachaFruits, chosenPet)
	end
	-- Update Gold
	updateGold(player)
	-- Update Pet
	updatePet(player, tableOfGachaFruits)

	remotes.FetchFruit:FireClient(player, tableOfGachaFruits)
end)

-- Update Gold
function updateGold(player)
	local Data = DataStore:GetAsync(tostring(player.UserId))
	--print(player.leaderstats.Coins.Value)
	Data.Coins = player.leaderstats.Coins.Value
	DataStore:SetAsync(tostring(player.UserId), Data)
	game.ReplicatedStorage.Remotes.GetPlayerData:FireClient(player, Data)
	--print(Data)
end

-- Update pet
function updatePet(player, tableOfGachaFruits)
	local Data = DataStore:GetAsync(tostring(player.UserId))

	for _, pet in pairs(tableOfGachaFruits) do
		Data.Pets[pet.Stt].Number += 1
		Data.Pets[pet.Stt].Status = 1
		player.PetLibrary:FindFirstChild(pet.Name).number.Value += 1
		player.PetLibrary:FindFirstChild(pet.Name).status.Value = 1
	end
	
	DataStore:SetAsync(tostring(player.UserId), Data)
	game.ReplicatedStorage.Remotes.PetLibrary:FireClient(player)
end

players.PlayerRemoving:Connect(function(player)
	if playerFetchDebounce[player] then
		playerFetchDebounce[player] = nil
	end
end)

game.ReplicatedStorage.Remotes.SellFruit.OnServerEvent:Connect(function(player, list, price)
	local Data = DataStore:GetAsync(tostring(player.UserId))
	local i = 1
	
	for _, pet in pairs(Data.Pets) do
		pet.Number = list[i]
		i += 1
	end
	
	Data.Coins = price
	player.leaderstats.Coins.Value = price
	
	print(Data)
	DataStore:SetAsync(tostring(player.UserId), Data)
	game.ReplicatedStorage.Remotes.GetPlayerData:FireClient(player, Data)
end)

-- Nhận quà hằng ngày
game.ReplicatedStorage.Remotes.ClaimGift.OnServerEvent:Connect(function(player, giftName)
	local Data = DataStore:GetAsync(tostring(player.UserId))

	Data.DailyGift[giftName].Received = 1
	if Data.DailyGift[giftName].Gold > 0 then
		Data.Coins += Data.DailyGift[giftName].Gold
		player.leaderstats.Coins.Value += Data.DailyGift[giftName].Gold
	end

	if Data.DailyGift[giftName].Diamond > 0 then
		Data.Diamonds += Data.DailyGift[giftName].Diamond
		player.leaderstats.Diamonds.Value += Data.DailyGift[giftName].Diamond
	end

	if Data.DailyGift[giftName].Gacha > 0 then
		fruit.ProximityPart.ProximityPrompt.Enabled=false
		fruit.ProximityPart2.ProximityPrompt.Enabled=false
		for i = 1, 10 do 
			gachaFruit(player)
		end
		task.wait(0.5)
		fruit.ProximityPart.ProximityPrompt.Enabled=true
		fruit.ProximityPart2.ProximityPrompt.Enabled=true
	end
	
	DataStore:SetAsync(tostring(player.UserId), Data)
	replicatedStorage.Remotes.GetPlayerData:FireClient(player, Data)
end)