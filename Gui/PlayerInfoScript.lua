local player = game.Players.LocalPlayer
local tweenService = game.TweenService

local areasData = require(game.ReplicatedStorage.JSON.AreasData)

game.ReplicatedStorage.Remotes.CreatePlayerInfo.OnClientEvent:Connect(function()
	local playerInfo = player.PlayerGui:WaitForChild('PlayerInfo')
	local frame = playerInfo.Frame
	
	print(1)
	--frame.PlayerName.Frame.name.Text = player.Name
	coroutine.wrap(updateHealth)(player, frame.PlayerHealth)
	--coroutine.wrap(updateNextArea)(player, frame.PlayerNextArea)
end)

function updateHealth(player, playerHealth)
	while task.wait(1) do
		local health = game.Workspace:WaitForChild(player.Name).Humanoid.Health
		
		tweenService:Create(playerHealth.Frame.Fill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(health / 100, 1)}):Play()
		playerHealth.Frame.Detail.Text = health..' / '..100
	end
end

--function findNextArea(player)
--	local name
--	for _, area in pairs(areasData) do
--		if area.Location == player.Level.Value + 1 then
--			name = area.Name
--			return name
--		end
--	end
--end

--function updateNextArea(player, playerNextArea)
--	while task.wait(1) do
--		local coins = player.leaderstats.Coins.Value
--		local name = findNextArea(player)
--		local price = areasData[name].Price
		
--		tweenService:Create(playerNextArea.Frame.Fill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(math.min(coins, price) / price, 1)}):Play()
--		playerNextArea.Frame.Detail.Text = math.min(coins, price)..' / '..price
--	end
--end