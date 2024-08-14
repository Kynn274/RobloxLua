local player = game.Players.LocalPlayer
local diamondText = script.Parent.Diamond.TextLabel
local goldText = script.Parent.Gold.TextLabel
local frameTrigger = require(player.PlayerGui.FrameTrigger)

function update(Data)
	diamondText.Text = tostring(Data.Diamonds)
	wait(0.1)
	goldText.Text = tostring(Data.Coins)
	
	--local maxlen = math.max(diamondText.TextBounds.X, goldText.TextBounds.X + 50) + 100
	--diamondText.Parent.Size = UDim2.new(0, maxlen, 0.15, 0)
	--goldText.Parent.Size = UDim2.new(0, maxlen, 0.15, 0)
	--diamondText.Size = UDim2.new(0, maxlen, 0.15, 0)
	--goldText.Size = UDim2.new(0, maxlen, 0.15, 0)
	
	if player.leaderstats.Rebirth.Value > 0 then
		goldText.Parent.Boost.BackgroundColor3 = Color3.fromRGB(58, 58, 58)
		goldText.Parent.Boost.BackgroundTransparency = 0.2
		goldText.Parent.Boost.Visible = true
		goldText.Parent.Boost.Text = 'x '..tostring(1 + player.leaderstats.Rebirth.Value / 2)
		goldText.Parent.Boost.TextColor3 = Color3.fromRGB(255,255,255)
	end
end

for _, it in pairs(script.Parent:GetChildren()) do
	if it:IsA('ImageLabel') then
		it.PlusButton.MouseButton1Click:Connect(function()
			frameTrigger.OpenFrame('Shop')
			for _, frame in pairs(player.PlayerGui.Frames.Store.Frame:GetChildren()) do
				if frame:IsA('ScrollingFrame') then
					frame.Visible = false
				end
			end
			if player.PlayerGui.Frames.Store.Frame:WaitForChild(it.Name..'Products') then
				for _, frame in pairs(player.PlayerGui.Frames.Store.Frame:GetChildren()) do
					if frame:IsA('Frame') then
						frame.BackgroundColor3 = Color3.fromRGB(81, 39, 3)
						frame.TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
					end
					if frame:IsA('ScrollingFrame') then
						frame.Visible = false
					end
				end
				player.PlayerGui.Frames.Store.Frame:WaitForChild(it.Name).BackgroundColor3 = Color3.fromRGB(211, 201, 93)
				player.PlayerGui.Frames.Store.Frame:WaitForChild(it.Name).TextButton.TextColor3 = Color3.fromRGB(81, 39, 3)
				player.PlayerGui.Frames.Store.Frame:WaitForChild(it.Name..'Products').Visible = true
				player.PlayerGui.Frames.TextButton.Visible = true
			end
		end)
	end
end

game.ReplicatedStorage.Remotes.GetPlayerData.OnClientEvent:Connect(update)
