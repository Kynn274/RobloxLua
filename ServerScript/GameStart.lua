local DataStoreService = game:GetService('DataStoreService')
local DataStore = DataStoreService:GetDataStore('MyDataStore1')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local PetsData = require(ReplicatedStorage.JSON.PetsData)
local AreasData = require(ReplicatedStorage.JSON.AreasData)
local StarterGUI = game:GetService('StarterGui')
local ServerStorage = game:GetService('ServerStorage')
local runService = game["Run Service"]

local pets = ReplicatedStorage:WaitForChild("Pets")
local JSON = game.ReplicatedStorage:WaitForChild("JSON")
local numberOfAreas = 4
local petsData = require(JSON.PetsData)

--while DataStore:GetAsync(tostring(611150838)) ~= nil do
--	DataStore:RemoveAsync(tostring(611150838))
--end

----while DataStore:GetAsync(tostring(2860491774)) ~= nil do
----	DataStore:RemoveAsync(tostring(2860491774))
----end


--while DataStore:GetAsync(tostring(5660832044)) ~= nil do
--	DataStore:RemoveAsync(tostring(5660832044))
--end
--while DataStore:GetAsync(tostring(6151026757)) ~= nil do
--	DataStore:RemoveAsync(tostring(6151026757))
--end

-- New Players' Data 
local Template = {
	Level = 1, -- số cửa mở
	Coins = 0,
	Diamonds = 0,
	Pets = PetsData.Pets,
	DailyGift = require(JSON.DailyGift),
	Tasks = require(JSON.TasksData),
	OnlineTime = 0,
	PreviousDate = {
		year = 2020,
		month = 1, 
		day = 1,
		hour = 0,
		min = 0,
		sec = 0
	},
	LegendaryBoost = 0,
	EpicBoost = 0,
	NumOfDates = 1,
	ReBirth = 0
}

local addAttributes = {
	'Tasks',
	'LegendaryBoost',
	'EpicBoost',
	'DailyGift',
}
-- Set Player Data When Game Starts

function mainfunc(Player)
	--	if DataStore:GetAsync(tostring(Player.UserId)) ~= nil then
	--DataStore:RemoveAsync(tostring(Player.UserId))
	--end
	--Player:Kick("Lol")
	local plr = workspace:WaitForChild(Player.Name)
	local location = game.Workspace.MainFolder_Workspace.Checkpoint.StarterArea.SpawnLocation.Position
	plr.HumanoidRootPart.CFrame = CFrame.new(location.X, location.Y + 1, location.Z)

	pcall(function()		
		local Data = DataStore:GetAsync(tostring(Player.UserId))
		local check = false
		if Data == nil then
			print('New')
			DataStore:SetAsync(tostring(Player.UserId), Template) -- set new data
			check = true
			print(Data)
		else
			local newData = UpdateData(Player) -- get data after updating
			DataStore:SetAsync(tostring(Player.UserId), newData) -- set data
			print('Old')
			print(Data)
		end
		ReplicatedStorage.Remotes.Newplayer:FireClient(Player, check)

		Data = DataStore:GetAsync(tostring(Player.UserId))
		ReplicatedStorage.Remotes.GetPlayerData:FireClient(Player, Data)

		getLeaderstats(Player)
		updatePets(Player)
		Player.Level.Value = Data.Level
		Player.LegendaryBoost.Value = Data.LegendaryBoost
		Player.EpicBoost.Value = Data.EpicBoost

		updateDate(Player)

		--ReplicatedStorage.Remotes.CreateDoors:FireClient(Player)
		ReplicatedStorage.Remotes.CreateLibrary:FireClient(Player)
		ReplicatedStorage.Remotes.CreateTeleport:FireClient(Player)
		ReplicatedStorage.Remotes.CreateFruitInventory:FireClient(Player)
		ReplicatedStorage.Remotes.CreateDropRateBoard:FireClient(Player)
		ReplicatedStorage.Remotes.CreateDailyTasks:FireClient(Player)
		ReplicatedStorage.Remotes.CreateGiftsAndTasks:FireClient(Player)
		--.Remotes.CreatePlayerInfo:FireClient(Player)
		ReplicatedStorage.Remotes.GameLoadingCompleted:FireClient(Player)
	end)
end

game.Players.PlayerAdded:Connect(mainfunc)

-- Update PetsData
function updatePetsData(player)
	local Data = DataStore:GetAsync(tostring(player.UserId)) -- get player data
	local count = table.maxn(Data.Pets) -- the old number of pets
	local listNum = {}
	local count1 = 1
	while count1 <= count do
		table.insert(listNum, Data.Pets[count1].Number)
		count1 += 1
	end

	count1 = 1
	while count1 <= count do
		PetsData.Pets[count1].Number = listNum[count1]
		if listNum[count1] > 0 then
			PetsData.Pets[count1].Status = 1
		end
		count1 += 1
	end
	Data.Pets = PetsData.Pets

	return Data
end

-- Update TasksData
function updateTasksData(player)
	local Data = DataStore:GetAsync(tostring(player.UserId))
	local tasksSource = require(JSON.TasksData)

	for _, tasksType in pairs(tasksSource) do
		print(tasksType.Name)
		if Data.Tasks[tasksType.Name] then
			print(true)
			if #Data.Tasks[tasksType.Name] < #tasksSource[tasksType.Name] then
				for i = #Data.Tasks[tasksType.Name] + 1, #tasksSource.tasksType.Name do
					setmetatable(Data.Tasks[tasksType.Name], tasksSource[tasksType.Name][i])
				end
			elseif #Data.Tasks[tasksType.Name] > #tasksSource[tasksType.Name] then
				for i = 1, #Data.Tasks[tasksType.Name] do
					if table.find(tasksSource[tasksType.Name], Data.Tasks[tasksType.Name][i].Name) == nil then
						table.remove(Data.Tasks[tasksType.Name], i)
					end
				end
			end
		--else
		--	setmetatable(Data.Tasks, {tasksType.Name = tasksType})
		end
	end

	return Data
end

-- Update Player Data
function UpdateData(player)
	local Data = DataStore:GetAsync(tostring(player.UserId))
	--for _, attribute in pairs(addAttributes) do
	--	if not Data.attribute then
	--		setmetatable(Data, {attribute = Template[attribute]})
	--	end
	--end

	Data = updatePetsData(player)
	--Data = updateTasksData(player)
	print(Data)
	return Data
end

-- Update Pets
local module3D = require(ReplicatedStorage:WaitForChild("Module3D"))
local runService = game:GetService("RunService")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

function updatePets(player)
	local Data = DataStore:GetAsync(tostring(player.UserId))
	local scrollingFrame = player.PlayerGui.Frames.FruitInventory.Frame.ScrollingFrame

	local maxnum = table.maxn(Data.Pets)
	local count = 1
	for _, pet in pairs(Data.Pets) do
		local count1 = 1

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

		while count1 <= pet.Number do	
			local val = Instance.new("StringValue")
			val.Name = tostring(pet.Name)
			val.Parent = player.Pets

			count1 += 1
		end
	end
	remotes.LoadPets:FireClient(player)
end

-- Get Leaderstats
function getLeaderstats(player)
	local Data = DataStore:GetAsync(tostring(player.UserId))
	player.leaderstats.Coins.Value = Data.Coins
	player.leaderstats.Diamonds.Value = Data.Diamonds
	player.leaderstats.Rebirth.Value = Data.ReBirth
end

-- Set Data
function setPlayerData(player, Data)
	DataStore:SetAsync(tostring(player.UserId), Data)
	ReplicatedStorage.Remotes.GetPlayerData:FireClient(player, Data)
	print(Data)
end

-- Update Money
function addMoney(player, coin)
	local Data = DataStore:GetAsync(tostring(player.UserId))
	Data.Coins = coin
	Data.Diamonds = player.leaderstats.Diamonds.Value
	player.leaderstats.Coins.Value = coin
	--print(Data)
	setPlayerData(player, Data)
	task.wait(1)
end

-- Update Diamond
function addDiamond(player, diamond)
	local Data = DataStore:GetAsync(tostring(player.UserId))
	Data.Diamonds = diamond
	player.leaderstats.Diamonds.Value = diamond
end

-- Update Time
function updateTime(player, Time)
	local Data = DataStore:GetAsync(tostring(player.UserId))
	Data.OnlineTime = Time
	--print(Data)
	setPlayerData(player, Data)
end

-- Request Pets
ReplicatedStorage.Remotes.RequestForPets.OnServerEvent:Connect(function(player)
	local Data = DataStore:GetAsync(tostring(player.UserId))
	ReplicatedStorage.Remotes.PetLibrary:FireClient(player, Data.Pets)
end)

-- Update Currency Event
game.ReplicatedStorage.Remotes.UpdateMoney.OnServerEvent:Connect(addMoney)
game.ReplicatedStorage.Remotes.UpdateDiamond.OnServerEvent:Connect(addDiamond)

-- Rebirth
ReplicatedStorage.Remotes.Rebirth.OnServerEvent:Connect(function(player)
	player.leaderstats.Coins.Value = 0
	player.leaderstats.Rebirth.Value += 1
	player.Level.Value = 1

	local Data = DataStore:GetAsync(tostring(player.UserId))
	Data.ReBirth = player.leaderstats.Rebirth.Value
	Data.Coins = player.leaderstats.Coins.Value
	Data.Level = 1
	setPlayerData(player, Data)

	local playerinw=workspace:WaitForChild(player.Name)
	local t=true

	coroutine.wrap(check)(t,player)

	playerinw.Humanoid.Health -= 100
end)

function check(t,player)
	wait(1)

	--getLeaderstats(Player)

	while t==true do
		print(1123)
		local playerinw=workspace:WaitForChild(player.Name)

		if playerinw.Humanoid.Health == 100 then
			task.wait(0.5)

			local location = game.Workspace.MainFolder_Workspace.Checkpoint.StarterArea.SpawnLocation.Position
			playerinw.HumanoidRootPart.CFrame = CFrame.new(location.X, location.Y + 1, location.Z)

			local Data = DataStore:GetAsync(tostring(player.UserId))

			ReplicatedStorage.Remotes.GetPlayerData:FireClient(player, Data)
			getLeaderstats(player)
			updatePets(player)
			player.Level.Value = Data.Level
			player.LegendaryBoost.Value = Data.LegendaryBoost
			player.EpicBoost.Value = Data.EpicBoost
			--updateLibrary(player)
			ReplicatedStorage.Remotes.CreateFruitInventory:FireClient(player)
			ReplicatedStorage.Remotes.CreateLibrary:FireClient(player)
			ReplicatedStorage.Remotes.CreateTeleport:FireClient(player)
			ReplicatedStorage.Remotes.CreateDropRateBoard:FireClient(player)
			ReplicatedStorage.Remotes.CreateDailyTasks:FireClient(player)
			--ReplicatedStorage.Remotes.CreatePlayerInfo:FireClient(player)
			ReplicatedStorage.Remotes.CreateGiftsAndTasks:FireClient(player)
			t=false
		end
		task.wait(0.1)
	end
end

-- Login Streak
function countDate(Today, PreviousDate)
	local time1 = os.time(PreviousDate)
	local time2 = os.time(Today)-- at a different time

	local function round (num)
		return math.floor(num + 0.5)
	end

	local difference = time2 - time1
	local seconds = difference
	local days = round(difference / 86400)
	local months = round(days / 12)
	local years = round(days / 365)

	return days
end

function previousDate(Today)
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

function updateDailyGiftsReceived(player)
	local Data = DataStore:GetAsync(tostring(player.UserId))
	for i = 1, 7 do
		local address = 'Day'..tostring(i)
		local newDay = Instance.new('IntValue')
		newDay.Name = address
		newDay.Parent = player.DailyGiftReceived
		newDay.Value = Data.DailyGift[address].Received
	end 
end

function updateDailyTasksReceived(player)
	local Data = DataStore:GetAsync(tostring(player.UserId))
	--print(Data)
	local num = table.maxn(Data.Tasks.DailyTasks)
	--print(num)

	for i = 1, num do
		local newDailyTask = Instance.new('IntValue')
		newDailyTask.Name = Data.Tasks.DailyTasks[i].Name
		newDailyTask.Parent = player.DailyTasksReceived
		newDailyTask.Value = Data.Tasks.DailyTasks[i].Received
	end
end

function resetDailyTasks(player)
	local Data = DataStore:GetAsync(tostring(player.UserId))
	local num = table.maxn(Data.Tasks.DailyTasks)

	for i = 1, num do
		Data.Tasks.DailyTasks[i].Received = 0
	end

	DataStore:SetAsync(tostring(player.UserId), Data)
end

function updateDate(player)
	local Today = {
		year = tonumber(os.date("%Y")),
		month = tonumber(os.date("%m")),
		day = tonumber(os.date("%d")),
		hour = tonumber(os.date("%H")),
		min = tonumber(os.date("%M")),
		sec = tonumber(os.date("%S"))
	}

	local Data = DataStore:GetAsync(tostring(player.UserId))
	local previousDay = previousDate(Today)
	local check = compare2Date(Data.PreviousDate, previousDay)

	if check then -- La ngay hom qua
		Data.NumOfDates += 1
		Data.OnlineTime = 0
		Data.PreviousDate = Today	
		resetDailyTasks(player)
	else
		if not compare2Date(Today, Data.PreviousDate) then -- Khong phai hom nay
			Data.NumOfDates = 1
			Data.OnlineTime = 0
			Data.PreviousDate = Today

			resetDailyTasks(player)

			for i = 1, #Data.DailyGift do
				print('yes')

				Data.DailyGift[i].Received = 0
			end
		end		
	end

	if Data.NumOfDates == 8 then
		Data.NumOfDates = 1
		for i = 1, #Data.DailyGift do
			Data.DailyGift[i].Received = 0
		end
	end

	player.Streak.Value = Data.NumOfDates
	player.OnlineTime.Value = Data.OnlineTime

	coroutine.wrap(countTime)(player)

	print(Data)
	DataStore:SetAsync(tostring(player.UserId), Data)
	updateDailyGiftsReceived(player)
	updateDailyTasksReceived(player)
end

-- Count Time
function countTime(player)
	while task.wait(1) do
		player.OnlineTime.Value += 1
	end
end

-- Reset player
ReplicatedStorage.Remotes.ResetPlayer.OnServerEvent:Connect(function(player)
	while DataStore:GetAsync(tostring(player.UserId)) ~= nil do
		DataStore:RemoveAsync(tostring(player.UserId))
	end
	mainfunc(player)
end)

game.Players.PlayerRemoving:Connect(function(player)
	local Data = DataStore:GetAsync(tostring(player.UserId))
	Data.OnlineTime = player.OnlineTime.Value
	DataStore:SetAsync(tostring(player.UserId), Data)
	print(Data)
end)

--DataStore:RemoveAsync(tostring(6151026757))
--DataStore:RemoveAsync(tostring(2860491774))
--DataStore:RemoveAsync(tostring(611150838))

