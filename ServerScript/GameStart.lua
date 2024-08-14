local DataStoreService = game:GetService('DataStoreService')
local DataStore = DataStoreService:GetDataStore('MyDataStore1')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local PetsData = require(ReplicatedStorage.JSON.PetsData)
local AreasData = require(ReplicatedStorage.JSON.AreasData)
local StarterGUI = game:GetService('StarterGui')
local ServerStorage = game:GetService('ServerStorage')
local pets = ReplicatedStorage:WaitForChild("Pets")
local JSON = game.ReplicatedStorage:WaitForChild("JSON")
local numberOfAreas = 4
local petsData = require(JSON.PetsData)

--while DataStore:GetAsync(tostring(611150838)) ~= nil do
--	DataStore:RemoveAsync(tostring(611150838))
--end

--while DataStore:GetAsync(tostring(2860491774)) ~= nil do
--	DataStore:RemoveAsync(tostring(2860491774))
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
	OnlineTime = 0,
	PreviousDate = {
		year = 2020,
		month = 1, 
		day = 1,
		hour = 0,
		min = 0,
		sec = 0
	}, 
	NumOfDates = 1,
	ReBirth = 0
}


-- Set Player Data When Game Starts

function mainfunc(Player)
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
		
		--createDoor(Player)
		updatePets(Player)
		
		Player.Level.Value = Data.Level
		updateDate(Player)
		
		ReplicatedStorage.Remotes.CreateDoors:FireClient(Player)
		ReplicatedStorage.Remotes.CreateLibrary:FireClient(Player)
		ReplicatedStorage.Remotes.CreateTeleport:FireClient(Player)
		ReplicatedStorage.Remotes.GameLoadingCompleted:FireClient(Player)
	end)
end

game.Players.PlayerAdded:Connect(mainfunc)

-- Update Player Data
function UpdateData(Player)
	local Data = DataStore:GetAsync(tostring(Player.UserId)) -- get player data
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

-- Update Currency Event
game.ReplicatedStorage.Remotes.UpdateMoney.OnServerEvent:Connect(addMoney)
game.ReplicatedStorage.Remotes.UpdateDiamond.OnServerEvent:Connect(addDiamond)

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
			--updateLibrary(player)
			ReplicatedStorage.Remotes.CreateLibrary:FireClient(player, Data.Pets)
			ReplicatedStorage.Remotes.CreateTeleport:FireClient(player)

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
	
	local difference = countDate(Today, Data.PreviousDate)
		
	if difference >= 1 then
		if difference > 1 then
			-- Số ngày chơi liên tiếp reset bằng 1
			Data.NumOfDates = 1
			Data.PreviousDate = Today
			for _, gift in pairs(Data.DailyGift) do
				gift.Received = 0					
			end
			
		elseif difference == 1 then
			-- Số ngày chơi liêu tiếp tăng lên
			Data.NumOfDates += 1
			Data.PreviousDate = Today
			
			if Data.NumOfDates > 7 then
				Data.NumOfDates = 1
				for _, gift in pairs(Data.DailyGift) do
					gift.Received = 0					
				end
			end
		end
				
		
	--elseif difference == 0 then
		-- Đếm thời gian chơi game trong ngày
	end
	
	local i = 1
	for _, gift in pairs(Data.DailyGift) do
		if Data.NumOfDates >= i then
			gift.Status = 1
		else
			gift.Status = 0
		end
		i += 1
	end
	
	print(Data)
	DataStore:SetAsync(tostring(player.UserId), Data)
	ReplicatedStorage.Remotes.LoadDailyGift:FireClient(player, Data.DailyGift)
end

-- Reset player
ReplicatedStorage.Remotes.ResetPlayer.OnServerEvent:Connect(function(player)
	while DataStore:GetAsync(tostring(player.UserId)) ~= nil do
		DataStore:RemoveAsync(tostring(player.UserId))
	end
	mainfunc(player)
end)

--ReplicatedStorage.Remotes.TimeToServer.OnServerEvent:Connect(updateTime)


--DataStore:RemoveAsync(tostring(6151026757))
--DataStore:RemoveAsync(tostring(2860491774))
--DataStore:RemoveAsync(tostring(611150838))

