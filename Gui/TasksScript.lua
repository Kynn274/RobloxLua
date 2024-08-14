local Tasks = script.Parent
local player = game.Players.LocalPlayer
local tasksData = require(game.ReplicatedStorage.JSON.TasksData)
local tweenService = game.TweenService 

local open = false
local checkedIcon = 'rbxassetid://18636654710'

	
for _, tasks in pairs(Tasks.Frame.MainTasks:GetChildren()) do
	if tasks:IsA('GuiButton') then
		tasks.MouseEnter:Connect(function()
			tasks.UIStroke.Enabled = false
		end)
		tasks.MouseLeave:Connect(function()
			tasks.UIStroke.Enabled = true
		end)
	end
end

function updateTasks(taskname)
	local tasks = tasksData[taskname]
	local holder = Tasks.Frame:WaitForChild(taskname)
	
	for _, it in pairs(tasks) do
		local newTask = holder.TextButton:Clone()
		newTask.TextFrame.Title.Text = it.Name
		newTask.ImageLabel.Image = it.Image
		newTask.Name = it.Name
		newTask.Parent = holder
		newTask.GiftFrame.TextLabel.Text = 'Rewards: '
		newTask.Content.UIGridLayout.CellSize = UDim2.new(1, 0, 0, Tasks.Frame.AbsolutePosition.Y*0.3)
		
		if it.Gifts.Gold > 0 then
			newTask.GiftFrame.TextLabel.Text = newTask.GiftFrame.TextLabel.Text..'+ '..it.Gifts.Gold .. ' Gold'
		end
		if it.Gifts.Diamond > 0 then
			newTask.GiftFrame.TextLabel.Text = newTask.GiftFrame.TextLabel.Text..' + '..it.Gifts.Diamond .. ' Diamonds'
		end
		newTask.GiftFrame.TextLabel.Text = newTask.GiftFrame.TextLabel.Text..' ...'
		--local pet = it.Gifts.Pet
		--print(pet)
		--for _, p in pairs(pet) do
		--	local text = newTask.GiftFrame.TextLabel.Text..' + '..tostring(p.Number)..' '..p.PetName
		--	if string.len(text) > 450 and string.len(newTask.GiftFrame.TextLabel.Text) <= 450 then
		--		newTask.GiftFrame.TextLabel.Text = newTask.GiftFrame.TextLabel.Text..'...'
		--	elseif string.len(text) <= 450 then
		--		newTask.GiftFrame.TextLabel.Text = text
		--	end
		--end	
		
		if it.Status == 0 then
			newTask.BackgroundColor3 = Color3.fromRGB(78, 176, 155)
			newTask.UIStroke.Color = Color3.fromRGB(60, 135, 119)
		elseif it.Status == 1 and it.Received == 0 then
			newTask.BackgroundColor3 = Color3.fromRGB(13, 253, 0)
			newTask.UIStroke.Color = Color3.fromRGB(9, 135, 0)
		elseif it.Status == 1 and it.Received == 1 then
			newTask.BackgroundColor3 = Color3.fromRGB(103, 103, 103)
			newTask.UIStroke.Color = Color3.fromRGB(0, 0, 0)
			newTask.Interactable = false
		end
		
		newTask.Content.Visible = false
		local content = it.Task
		local num = table.maxn(content)
		for i = 1, num do
			local newStep = newTask.Content.Step:Clone()
			newStep.Parent = newTask.Content
			newStep.Name = 'Step'..tostring(i)
			newStep.TextLabel.Text = content[i].description
			if content[i].status == 1 then
				newStep.ImageLabel.Image = checkedIcon
			end			
		end
		newTask.Content.Step.Visible = false
		
		local rewards = Instance.new('Frame')
		rewards.Name = 'Rewards'
		rewards.Parent = newTask.Content
		rewards.BackgroundTransparency = 1
		rewards.AutomaticSize = Enum.AutomaticSize.Y
		
		local Text = Instance.new('TextLabel')
		Text.Parent = rewards
		Text.AnchorPoint = Vector2.new(0, 0.5)
		Text.Size = UDim2.fromScale(1, 1)
		Text.Position = UDim2.fromScale(0, 0.5)
		Text.FontFace = Font.fromName('FredokaOne')
		Text.TextWrapped = true
		Text.TextScaled = true
		Text.TextColor3 = Color3.fromRGB(255, 255, 255)
		Text.Text = 'Rewards: '
		Text.BackgroundTransparency = 1
		Text.TextXAlignment = Enum.TextXAlignment.Left
		Text.TextYAlignment = Enum.TextYAlignment.Center
		
		local count = 0
		if it.Gifts.Gold > 0 then
			Text.Text = Text.Text..'\n  Gold: '..tostring(it.Gifts.Gold)
			count += 1
		end
		
		if it.Gifts.Diamond > 0 then
			Text.Text = Text.Text..'\n  Diamond: '..tostring(it.Gifts.Diamond)
			count += 1
		end
		
		local pet = it.Gifts.Pet
		if table.maxn(pet) > 0 then
			Text.Text = Text.Text..'\n  Pets: '
			count += 1
		end
		
		for _, p in pairs(pet) do
			Text.Text = Text.Text..'\n  + '..tostring(p.Number)..' '..p.PetName
			count += 1
		end	
		
		Text.Size = UDim2.new(1, 0, 0.5 * count, 0)
		
		newTask.MouseEnter:Connect(function()
			newTask.UIStroke.Enabled = false
		end)
		newTask.MouseLeave:Connect(function()
			newTask.UIStroke.Enabled = true
		end)
		newTask.MouseButton1Click:Connect(function()
			if it.Status == 0 then
				if open == true then
					newTask.Content.Visible = false
					tweenService:Create(newTask.Content, TweenInfo.new(0.3), {AutomaticSize = 0}):Play()
					open = false
				else
					newTask.Content.Visible = true
					tweenService:Create(newTask.Content, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {AutomaticSize = 2}):Play()
					open = true
					
				end
			--elseif it.Status == 1 and it.Received == 0 then 
				
			end
		end)
	end
	holder.TextButton.Visible = false
end

updateTasks('MainTasks')