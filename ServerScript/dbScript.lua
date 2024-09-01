-- Service
local dataStoreService = game:GetService('DataStoreService')
local replicatedStorage = game:GetService('ReplicatedStorage')

-- replicatedStorage
local remotes = replicatedStorage.Remotes

-- DataStore
local playerInventory = dataStoreService:GetDataStore('playerInventory')
local playerLevel = dataStoreService:GetDataStore('playerInventory', 'Level')
local playerCoins = dataStoreService:GetDataStore('playerInventory', 'Coins')
local playerDiamonds = dataStoreService:GetDataStore('playerInventory', 'Diamonds')
local playerPets = dataStoreService:GetDataStore('playerInventory', 'Pets')
local playerDailyGift = dataStoreService:GetDataStore('playerInventory', 'DailyGift')
local playerTasks = dataStoreService:GetDataStore('playerInventory', 'Tasks')
local playerOnlineTime = dataStoreService:GetDataStore('playerInventory', 'OnlineTime')
local playerPreviousDate = dataStoreService:GetDataStore('playerInventory', 'PreviousDate')
local playerLegendaryBoost = dataStoreService:GetDataStore('playerInventory', 'LegendaryBoost')
local playerEpicBoost = dataStoreService:GetDataStore('playerInventory', 'EpicBoost')
local playerNumOfDates = dataStoreService:GetDataStore('playerInventory', 'NumOfDates')
local playerRebirth = dataStoreService:GetDataStore('playerInventory', 'Rebirth')

local attributesList = {
	'Level',
	'Coins',
	'Diamonds',
	'Pets',
	'DailyGift',
	'Tasks',
	'OnlineTime',
	'PreviousDate',
	'LegendaryBoost',
	'EpicBoost',
	'NumOfDates',
	'Rebirth',
}

game.Players.PlayerAdded:Connect(mainfunc)
game.Players.PlayerRemoving:Connect(function(player)
    local success, newOnlineTime = pcall(function()
        return playerOnlineTime:Update(player.UserId, player.OnlineTime.Value)
    end)
    if success then
        print('Saved online time!')
    end
end)
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- FUNCTION
function mainfunc(player)
    local playerCharacter = workspace:WaitForChild(player.Name)
	local location = game.Workspace.MainFolder_Workspace.Checkpoint.StaterArea.SpawnLocation
	
	playerCharacter.HumanoidRootPart.CFrame = CFrame.new(location.X, location.Y + 1, location.Z)
	
	level(player)
	coins(player)
	diamonds(player)
    pets(player)
	epicBoost(player)
    legendaryBoost(player)
    rebirth(player)
    previousDate(player)
    
    remotes.CreateLibrary:FireClient(player)
    remotes.CreateTeleport:FireClient(player)
    remotes.CreateFruitInventory:FireClient(player)
    remotes.CreateDropRateBoard:FireClient(player)
    remotes.CreateDailyTasks:FireClient(player)
    remotes.CreateGiftsAndTasks:FireClient(player)
    remotes.GameLoadingCompleted:FireClient(player)
    coroutine.wrap(checkDead)(player)
end

function checkDead(player)
	while task.wait(1) do
		local character = workspace:WaitForChild(player.Name)

		--print(character.Humanoid.Health)
		if character.Humanoid.Health == 0 then
			local t = true
			coroutine.wrap(resetCharacter)(t, player)
		end
	end
end

function resetCharacter(t, player)
	wait(1)
    while t == true do
		--print(1123)
		local playerCharacter = workspace:WaitForChild(player.Name)
		if playerCharacter.Humanoid.Health == 100 then
			task.wait(0.5)
			mainfunc(player)
			t = false
		end
		task.wait(0.1)
	end
end
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- GET DATA

-- Get coins
function coins(player)
	local success, currentCoins = pcall(function()
		return playerCoins:GetAsync(player.UserId)
	end)
	
	if success then
		player.leaderstats.Coins.Value = currentCoins
	else
		replicatedStorage.Remotes.Newplayer:FireClient(player)
		player.leaderstats.Coins.Value = 0
		playerCoins:SetAsync(player.UserId, 0)
	end
end

-- Get level
function level(player)
	local success, currentLevel = pcall(function()
		return playerLevel:GetAsync(player.UserId)
	end) 
	
	if success then
		player.Level.Value = currentLevel
	else
		player.Level.Value = 1
		playerLevel:SetAsync(player.UserId, 1)
	end
end

-- Get diamonds
function diamonds(player)
	local success, currentDiamonds = pcall(function()
		return playerDiamonds:GetAsync(player.UserId)
	end)

	if success then
		player.leaderstats.Diamonds.Value = currentDiamonds
	else
		player.leaderstats.Diamonds.Value = 0
		playerDiamonds:SetAsync(player.UserId, 0)
	end
end

-- Get pets
function pets(player)
    local petsData = require(replicatedStorage.JSON.PetsData)

    local success, currentPets = pcall(function()
        return playerPets:GetAsync(player.UserId)
    end)

    if success then
        local petsList = currentPets
        for index, pet in pairs (petsData) do
            if not petsList[pet.key] then
                table.insert(petsList, pet)
            end
        end
        updatePetsClient(petsList)
    else
        playerPets:SetAsync(player.UserId, petsData)
        updatePetsClient(petsData)
    end
end

function updatePetsClient(petsData)
    for _, pet in pairs (petsData) do
        local fruit = Instance.new('StringValue')
		fruit.Name = tostring(pet.Name)
		fruit.Parent = player.PetLibrary

		local stt = Instance.new("IntValue")
		stt.Name = 'stt'
		stt.Parent = fruit
		stt.Value = count

		local rarity = Instance.new("StringValue")
		rarity.Name = 'rarity'
		rarity.Parent = fruit
		rarity.Value = pet.Rarity

		local number = Instance.new("IntValue")
		number.Name = 'number'
		number.Parent = fruit
		number.Value = pet.Number

		local damage = Instance.new('IntValue')
		damage.Name = 'damage'
		damage.Parent = fruit
		damage.Value = pet.Speed

		local avatar = Instance.new('StringValue')
		avatar.Name = 'avatar'
		avatar.Parent = fruit
		avatar.Value = pet.Avatar

		local status = Instance.new("IntValue")
		status.Name = 'status'
		status.Parent = fruit
		status.Value = pet.Status

        for i = 1, pet.Number do
            local val = Instance.new('StringValue')
            val.Name = pet.Name
            val.Parent = player.Pets
        end
    end
    remotes.LoadPets:FireClient(player)
end

-- Get legendaryBoost
function legendaryBoost(player)
    local success, currentLegendaryBoost = pcall(function()
        return playerLegendaryBoost:GetAsync(player.UserId)
    end)

    if success then
        player.LegendaryBoost.Value = currentLegendaryBoost
    else
        playerLegendaryBoost:SetAsync(player.UserId, 0)
        player.LegendaryBoost.Value = 0
    end
end

-- Get epicBoost
function epicBoost(player)
    local success, currentEpicBoost = pcall(function()
        return playerEpicBoost:GetAsync(player.UserId)
    end)

    if success then
        player.EpicBoost.Value = currentEpicBoost
    else
        playerEpicBoost:SetAsync(player.UserId, 0)
        player.EpicBoost.Value = 0
    end
end

-- Get Rebirth
function rebirth(player)
    local success, currentRebirth = pcall(function()
        return playerRebirth:GetAsync(player.UserIds)
    end)
    
    if success then
        player.leaderstats.Rebirth.Value = currentRebirth
    else
        playerRebirth:SetAsync(player.UserId, 0)
        player.leaderstats.Rebirth.Value = 0
    end
end

-- Get dailyGift
function dailyGift(player)
    local dailyGiftData = require(replicatedStorage.JSON.DailyGift)

    local success, currentDailyGift = pcall(function()
        return playerDailyGift:GetAsync(player.UserId)
    end)

    if not success then
        playerDailyGift:SetAsync(player.UserId, dailyGiftData)
    end
end

-- Get tasks
function tasks(player)
    local tasksData = require(replicatedStorage.JSON.TasksData)

    local success, currentTasks = pcall(function()
        return playerTasks:GetAsync(player.UserId)
    end)

    if not success then
        playerTasks:SetAsync(player.UserId, tasksData)
    end
end

-- Get onlineTime
function onlineTime(player)
    local success, currentOnlineTime = pcall(function()
        return playerOnlineTime:GetAsync(player.UserId)
    end)

    if success then
        player.OnlineTime.Value = currentOnlineTime
    else
        playerOnlineTime:SetAsync(player.UserId, 0)
        player.OnlineTime.Value = 0
    end
end

-- Get numOfDates 
function numOfDates(player)
    local success, currentNumOfDates = pcall(function()
        return playerNumOfDates:GetAsync(player.UserId)
    end)

    if success then
        player.Streak.Value = currentNumOfDates
    else
        playerNumOfDates:SetAsync(player.UserId, 1)
        player.Streak.Value = 1
    end
end

-- Get previousDate
function previousDate(player)
    local newDate = {
        year = 2020,
		month = 1, 
		day = 1,
		hour = 0,
		min = 0,
		sec = 0
    }

    local success, currentPreviousDate = pcall(function()
        return playerPreviousDate:GetAsync(player.UserId)
    end)

    if success then
        updateDate(player, currentPreviousDate)
    else
        playerPreviousDate:SetAsync(player.UserId, newDate)
        updateDate(player, newDate)
    end

end

function updateDate(player, previousDay)
    local Today = {
        year = tonumber(os.date("%Y")),
		month = tonumber(os.date("%m")),
		day = tonumber(os.date("%d")),
		hour = tonumber(os.date("%H")),
		min = tonumber(os.date("%M")),
		sec = tonumber(os.date("%S"))
    }

    local yesterday = lastDay(Today)
    local check = compare2Date(previousDay, yesterday)

    if check then -- Yesterday
        -- Update Streak
        local success, currentStreak = pcall(function()
            return playerNumOfDates:GetAsync(player.UserId)
        end)
        if success then
            if currentStreak == 7 then
                local success, newStreak = pcall(function()
                    return playerNumOfDates:UpdateAsync(player.UserId, 1)
                end)
                if success then
                    player.Streak.Value = newStreak
                    resetDailyGift(player)
                end
            else
                local success, newStreak = pcall(function()
                    return playerNumOfDates:IncrementAsync(player.UserId, 1)
                end)
                if success then
                    player.Streak.Value = newStreak
                end
            end
        end

        -- Update OnlineTime
        local success, newOnlineTime = pcall(function()
            return playerOnlineTime:UpdateAsync(player.UserId, 0)
        end)
        if success then
            player.OnlineTime.Value = 0
        end

        -- Update PreviousDate
        local success, newPreviousDate = pcall(function()
            return playerPreviousDate:Update(player.UserId, Today)
        end)
        if success then 
            print('Updated new day')
            resetDailyTasks(player)
        end
    else
        if not compare2Date(Today, previousDay) then
        -- Update Streak
        local success, newStreak = pcall(function()
            return playerNumOfDates:UpdateAsync(player.UserId, 1)
        end)
        if success then
            player.Streak.Value = newStreak
        end

        -- Update OnlineTime
        local success, newOnlineTime = pcall(function()
            return playerOnlineTime:UpdateAsync(player.UserId, 0)
        end)
        if success then
            player.OnlineTime.Value = newOnlineTime
        end

        -- Update PreviousDate
        local success, newPreviousDate = pcall(function()
            return playerPreviousDate:Update(player.UserId, Today)
        end)
        if success then 
            print('Updated new day')
            resetDailyTasks(player)
            resetDailyGift(player)
        end
    end

    coroutine.wrap(countTime)(player)
    updateDailyGiftsReceived(player)
    updateDailyTasksReceived(player)
end

function lastDay(Today)
    local Day = Today.day
	local Month = Today.month
	local Year = Today.year

	Day -= 1
	if Day == 0 then
		if Month == 12 then 
			Month = 11
			Day = 30
		elseif Month == 11 then 
			Month = 10
			Day = 31
		elseif Month == 10 then
			Month = 9
			Day = 31
		elseif Month == 9 then 
			Month = 8
			Day = 30
		elseif Month == 8 then
			Month = 7
			Day = 31
		elseif Month == 7 then
			Month = 6
			Day = 30
		elseif Month == 6 then
			Month = 5
			Day = 31
		elseif Month == 5 then
			Month = 4
			Day = 30
		elseif Month == 4 then
			Month = 3
			Day = 31
		elseif Month == 3 then
			Month = 2
			if Year % 4 == 0 and Year % 100 ~= 0 or Year % 400 == 0 then 
				Day = 29
			else 
				Day = 28
			end
		elseif Month == 2 then
			Month = 1
			Day = 31
		elseif Month == 1 then
			Month = 12
			Day = 31
			Year -= 1
		end
	end

	local day = {
		year = Year,
		month = Month, 
		day = Day,
		hour = 0,
		min = 0,
		sec = 0
	}
	return day
end

function compare2Date(day1, day2)
	return day1.day == day2.day and day1.month == day2.month and day1.year == day2.year
end

function resetDailyTasks(player)
    local success, currentTasks = pcall(function()
        return playerTasks:GetAsync(player.UserId)
    end)
    if success then
        local dailyTasks = currentTasks['DailyTasks']
        for _, task in pairs(dailyTasks) do
            if task.Received then
                task.Received = 0
            end
        end
        currentTasks['DailyTasks'] = dailyTasks
        
        local sc, newTasks = pcall(function()
            playerTasks:UpdateAsync(player.UserId, currentTasks)
        end)
        if sc then
            print('Reset daily tasks successfully!')
        end
    end
end

function resetDailyGift(player)
    local success, currentDailyGift = pcall(function()
        return playerDailyGift:GetAsync(player.UserId)
    end)
    if success then
        for _, gift in pairs(currentDailyGift) do
            if gift.Received then
                gift.Received = 0
            end
        end
        local sc, newDailyGift = pcall(function()
            playerDailyGift:UpdateAsync(player.UserId, currentDailyGift)
        end)
        if sc then
            print('Reset daily gifts successfully!')
        end
    end
end

function countTime(player)
    while task.wait(1) do
        player.OnlineTime.Value += 1
    end
end

function updateDailyGiftsReceived(player)
    local success, currentDailyGift = pcall(function()
        return playerDailyGift:GetAsync(player.UserId)
    end)
    if success then
        for i = 1, 7 do
            local address = 'Day'..tostring(i)
            local newDay = Instance.new('IntValue')
            newDay.Name = address
            newDay.Parent = player.DailyGiftReceived
            newDay.Value = currentDailyGift[address].Received
        end 
    end
end

function updateDailyTasksReceived(player)
    local success, currentTasks = pcall(function()
        return playerTasks:GetAsync(player.UserId)
    end)
    if success then
        local dailyTasks = currentTasks['DailyTasks']

        for index = 1, table.maxn(dailyTasks) do
            local newDailyTask = Instance.new('IntValue')
            newDailyTask.Name = dailyTasks[index].Name
            newDailyTask.Parent = player.DailyTasksReceived
            newDailyTask.Value = dailyTasks[i].Received
        end
    end
end
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- REMOTES

-- Update Money
remotes.UpdateMoney.OnServerEvent:Connect(function(player, increasingCoin)
    local success, newCoinsValue = pcall(function()
        return playerCoins:IncrementAsync(player.UserId, increasingCoin)
    end)

    if success then
        player.leaderstats.Coins.Value = newCoinsValue
    end
end)

-- Update Diamonds
remotes.UpdateDiamond.OnServerEvent:Connect(function(player, increasingDiamond)
    local success, newDiamondValue = pcall(function()
        return playerDiamonds:IncrementAsync(player.UserId, increasingDiamond)
    end)

    if success then
        player.leaderstats.Diamonds.Value = newDiamondValue
    end
end)

-- Rebirth
remotes.Rebirth.OnServerEvent:Connect(function(player)
    local success, updatedCoins = pcall(function()
        return playerCoins:UpdateAsync(player.UserId, 0)
    end)
    if success then
        player.leaderstats.Coins.Value = updatedCoins
    end

    local success, updatedLevel = pcall(function()
        return playerLevel:UpdateAsync(player.UserId, 1)
    end)
    if success then
        player.Level.Value = updatedLevel
    end

    local success, updatedRebirth = pcall(function()
        return playerRebirth:IncrementAsync(player.UserId, 1)
    end)
    if success then
        player.leaderstats.Rebirth.Value = updatedRebirth
    end

    local playerCharacter = workspace:WaitForChild(player.Name)
    playerCharacter.Humanoid.Health = 0
end)

