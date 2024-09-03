local player = game.Players.LocalPlayer
local tweenService = game.TweenService

game.ReplicatedStorage.Remotes.CreateGiftsAndTasks.OnClientEvent:Connect(function()
	local dailyGiftData = require(game.ReplicatedStorage.JSON.DailyGift)
	local dailyGifts = player.PlayerGui:WaitForChild('Frames').DailyGifts.Frame.ScrollingFrame
	
	for i = 1, 7 do
		local address = 'Day'..tostring(i)
		local dayFrame = dailyGifts:FindFirstChild(address)

		if dayFrame then
			if dailyGiftData[address].Gold > 0 then
				local gold = dayFrame.TextButton:FindFirstChild('Gold')
				gold.TextLabel.Text = tostring(dailyGiftData[address].Gold * (1 + player.leaderstats.Rebirth.Value / 2))
			end
			if dailyGiftData[address].Diamond > 0 then
				local diamond = dayFrame.TextButton:FindFirstChild('Diamond')
				diamond.TextLabel.Text = tostring(dailyGiftData[address].Diamond)
			end
			if dailyGiftData[address].Gacha > 0 then
				local gacha = dayFrame.TextButton:FindFirstChild('Gacha')
				gacha.TextLabel.Text = tostring(dailyGiftData[address].Gacha)
			end
		end

		if i <= player.Streak.Value then
			if player.DailyGiftReceived:FindFirstChild(address).Value == 1 then
				dayFrame.TextButton.BackgroundColor3 = Color3.fromRGB(111, 111, 111)
				dayFrame.TextButton.UIStroke.Color = Color3.fromRGB(107, 107, 107)
				dayFrame.TextButton.CompleteMark.Visible = true
				dayFrame.TextButton.Interactable = false
			else
				dayFrame.TextButton.BackgroundColor3 = Color3.fromRGB(84, 255, 75)
				dayFrame.TextButton.UIStroke.Color = Color3.fromRGB(38, 255, 0)
				dayFrame.TextButton.Interactable = true
			end
			dayFrame.Status.Value = 1
		else
			dayFrame.TextButton.BackgroundColor3 = Color3.fromRGB(255, 240, 75)
			dayFrame.TextButton.UIStroke.Color = Color3.fromRGB(255, 247, 0)
			dayFrame.TextButton.Interactable = false
			dayFrame.Status.Value = 0
		end
	end

	for _, dayFrame in pairs(dailyGifts:GetChildren()) do
		if dayFrame:IsA('Frame') then
			dayFrame.MouseEnter:Connect(function()
				if dayFrame.Status.Value == 1 and player.DailyGiftReceived:FindFirstChild(dayFrame.Name).Value == 0 then
					tweenService:Create(dayFrame.TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.5, 0.5)}):Play()
				end
			end)
			
			dayFrame.MouseLeave:Connect(function()
				if dayFrame.Status.Value == 1 and player.DailyGiftReceived:FindFirstChild(dayFrame.Name).Value == 0 then
					tweenService:Create(dayFrame.TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.6, 0.6)}):Play()
				end
			end)
			
			dayFrame.TextButton.MouseButton1Click:Connect(function()
				if dayFrame.Status.Value == 1 and player.DailyGiftReceived:FindFirstChild(dayFrame.Name).Value == 0 then
					game.ReplicatedStorage.Remotes.ClaimDailyGifts:FireServer(dayFrame.Name)
				end
				
				dayFrame.TextButton.BackgroundColor3 = Color3.fromRGB(111, 111, 111)
				dayFrame.TextButton.UIStroke.Color = Color3.fromRGB(107, 107, 107)
				dayFrame.TextButton.CompleteMark.Visible = true
				dayFrame.TextButton.Interactable = false
			end)
		end
	end
end)