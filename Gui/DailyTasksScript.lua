local player = game.Players.LocalPlayer
local tweenService = game.TweenService

game.ReplicatedStorage.Remotes.CreateDailyTasks.OnClientEvent:Connect(function()
	-- UI
	local dailyTasks = player.PlayerGui:WaitForChild('Frames').DailyTasks
	local frame = dailyTasks.Frame
	local scrollingFrame = frame.ScrollingFrame
	
	-- Module
	local tasksData = require(game.ReplicatedStorage.JSON.TasksData)
	local Module3D = require(game.ReplicatedStorage.Module3D)
	local dailyTasksData = tasksData.DailyTasks
	local number = #dailyTasksData
	
	-- Var
	local dailyTasks = {}
	local onGoing
	
	for _, t in pairs(dailyTasksData) do
		if t.Name then
			table.insert(dailyTasks, t)
		end
	end
	table.sort(dailyTasks, function(a1, a2)
		return a1.STT < a2.STT
	end)
	
	-- set layout
	for i = 1, #dailyTasks do
		local Task = dailyTasks[i]
		if player.DailyTasksReceived:FindFirstChild(Task.Name).Value == 0 then
			local newFrame = scrollingFrame.Frame:Clone()
			newFrame.Parent = scrollingFrame
			newFrame.Name = Task.Name
			newFrame.Item.Description.Text = Task.Task
			newFrame.Visible = true

			local gift = Task.Gifts
			if gift.Coins.Value > 0 then
				local newGift = newFrame.Item.Gifts.Frame:Clone()
				newGift.Parent = newFrame.Item.Gifts
				newGift.Name = 'Coins'
				newGift.Visible = true
				newGift.ImageLabel.TextLabel.Text = tostring(gift.Coins.Value)
				newGift.ImageLabel.Image = gift.Coins.Image
			end

			if gift.Diamonds.Value > 0 then
				local newGift = newFrame.Item.Gifts.Frame:Clone()
				newGift.Parent = newFrame.Item.Gifts
				newGift.Name = 'Diamonds'
				newGift.Visible = true
				newGift.ImageLabel.TextLabel.Text = tostring(gift.Diamonds.Value)
				newGift.ImageLabel.Image = gift.Diamonds.Image
			end

			if player.OnlineTime.Value >= Task.Time then
				onGoing = dailyTasks[i]
				if player.DailyTasksReceived:FindFirstChild(Task.Name).Value == 1 then
					newFrame.Item.TextButton.BackgroundColor3 = Color3.fromRGB(204, 204, 204)
					newFrame.Item.BackgroundColor3 = Color3.fromRGB(229, 229, 229)
					newFrame.Item.TextButton.Interactable = false
				else
					newFrame.Item.TextButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
					newFrame.Item.TextButton.Interactable = true
				end
			else
				newFrame.Item.TextButton.BackgroundColor3 = Color3.fromRGB(204, 204, 204)
				newFrame.Item.TextButton.Interactable = false
			end

			newFrame.Item.TextButton.MouseEnter:Connect(function()
				tweenService:Create(newFrame.Item.TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(1.05, 0.35)}):Play()
			end)

			newFrame.Item.TextButton.MouseLeave:Connect(function()
				tweenService:Create(newFrame.Item.TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(1.2, 0.4)}):Play()
			end)

			newFrame.Item.TextButton.MouseButton1Click:Connect(function()
				game.ReplicatedStorage.Remotes.ClaimTasksGift:FireServer('DailyTasks', Task.Name)
				tweenService:Create(newFrame.Item, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0, 0)}):Play()
				task.wait(0.2)
				newFrame.Visible = false
			end)
			coroutine.wrap(processingDailyTasks)(player, Task)
		end
	end
	
end)

function processingDailyTasks(player, Task)
	local dailyTasks = player.PlayerGui:WaitForChild('Frames').DailyTasks
	local frame = dailyTasks.Frame
	local scrollingFrame = frame.ScrollingFrame
	
	while task.wait(1) do
		if player.OnlineTime.Value >= Task.Time then
			local dailyTask = scrollingFrame:FindFirstChild(Task.Name)
			if dailyTask then
				dailyTask.Item.TextButton.Interactable = true
				dailyTask.Item.TextButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
			end
		end
	end
end