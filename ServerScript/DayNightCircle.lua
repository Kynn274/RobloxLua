local lighting = game.Lighting

local beginTime = {
	day = 1,
	month = 1,
	year = 1970,
	hour = 0,
	minute = 0,
	second = 0,
}

local today = {
	day = 1,
	month = 7,
	year = 2024,
	hour = 0,
	minute = 0,
	second = 0
}

game.Players.PlayerAdded:Connect(function(player)
	local m = workspace:GetServerTimeNow()
	local gapSec = m - dayGap(beginTime, today)
	
	local Time = Instance.new('Folder')
	Time.Parent = player
	Time.Name = 'Time'
	
	local Hour = Instance.new('IntValue')
	Hour.Parent = Time
	Hour.Name = 'hour'
	Hour.Value = math.floor(gapSec / 3600)
	
	local Minute = Instance.new('IntValue')
	Minute.Parent = Time
	Minute.Name = 'minute'
	Minute.Value = math.floor(gapSec % 3600 / 60)
	
	local Second = Instance.new('IntValue')
	Second.Parent = Time
	Second.Name = 'second'
	Second.Value = math.floor(gapSec % 3600 % 60)
	
	lighting.ClockTime = Hour.Value + Minute.Value / 60 + Second.Value / 3600
	
	coroutine.wrap(serverTime)(player)
	
end)

-- Test 2p 1 ngày
-- 120s 1 ngày
-- 5s 1h
-- 1s 0.2h

local dayTime = 480

function serverTime(player)
	local Time = player.Time
	local hour = Time.hour
	local minute = Time.minute
	local second = Time.second
	
	while task.wait(1) do
		second.Value += 1
		if second.Value == 60 then
			second.Value = 0
			minute.Value += 1
		end
		
		if minute.Value == 60 then
			minute.Value = 0
			hour.Value += 1
		end
		
		if hour.Value == 24 then
			hour.Value = 0
		end
		
		lighting.ClockTime += 24 / dayTime -- 0.05
		if lighting.ClockTime > 24 then
			lighting.ClockTime %= 24
		end
		
		local modul3 = (hour.Value * 60 + minute.Value - dayTime / 60 / 2) % (dayTime / 60 * 3)
		if modul3 >= dayTime / 60 * 2 then
			lighting.Sky.MoonTextureId = 'rbxassetid://74957272719959'
		else
			lighting.Sky.MoonTextureId = 'rbxasset://sky/moon.jpg'
		end
	end
end

function numberOfDate(date)
	local dayFollowingYear = math.floor(date.year / 4) * 366 + (date.year - math.floor(date.year / 4)) * 365
	local dayFollowingMonth = 0
	for i = 1, date.month - 1 do
		if i == 1 or i == 3 or i == 5 or i == 7 or i == 8 or i == 10 or i ==12 then
			dayFollowingMonth += 31
		elseif i == 4 or i == 6 or i == 9 or i == 11 then
			dayFollowingMonth += 30
		elseif i == 2 then
			if date.year % 400 == 0 or date.year % 4 == 0 and date.year % 100 ~= 0 then
				dayFollowingMonth += 29
			else 
				dayFollowingMonth += 28
			end
		end
	end
	return dayFollowingMonth + dayFollowingYear + date.day
end

function dayGap(beginTime, today)
	local gapDay = numberOfDate(today) - numberOfDate(beginTime) - 1
	local hourFollowingDay = gapDay * 24
	local hour = hourFollowingDay + today.hour
	local minute = today.minute
	local second = today.second
	
	local totalSecond = hour * 3600 + minute * 60 + second
	return totalSecond
end
