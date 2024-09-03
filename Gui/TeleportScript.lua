-- Service
local player = game.Players.LocalPlayer
local tweenService = game.TweenService

-- Model
local CheckPoints = game.Workspace.MainFolder_Workspace.Checkpoint

-- Data
local areasData = require(game.ReplicatedStorage.JSON.AreasData)

-- UI
--local darkScreen = player.PlayerGui:WaitForChild('DarkScreen')
local frames = player.PlayerGui:WaitForChild('Frames')
local purchaseDoor = player.PlayerGui:WaitForChild('PurchaseDoor')

-- Var
local clicked = 0

function teleEffect()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local Remotes = ReplicatedStorage:WaitForChild("Remotes")
	local BlackHole = ReplicatedStorage:FindFirstChild("BlackHole")
	local DarkMistAtt = BlackHole.DarkMist

	local tweenInfo1 = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tweenInfo2 = TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)


	local teleEffect = player.PlayerGui:WaitForChild("TeleEffect")
	local TPFrame = teleEffect:FindFirstChild("TPFrame")
	local lf1 = TPFrame:FindFirstChild("LeftFrame1")
	local lf2 = TPFrame:FindFirstChild("LeftFrame2")
	local rf1 = TPFrame:FindFirstChild("RightFrame1")
	local rf2 = TPFrame:FindFirstChild("RightFrame2")
	local WholeScreen = TPFrame:FindFirstChild("WholeScreen")
	local DarkMistAttClone = DarkMistAtt:Clone()
	local playerInWorkspace = game.Workspace:WaitForChild(player.Name)
	playerInWorkspace.HumanoidRootPart.Anchored = true
	DarkMistAttClone.Parent = playerInWorkspace.UpperTorso
	DarkMistAttClone.ParticleEmitter:Emit(10)

	local tweenlf2 = tweenService:Create(lf2,tweenInfo2,{Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
	local tweenrf2 = tweenService:Create(rf2,tweenInfo2,{Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
	task.wait(0.25)
	local tweenlf1 = tweenService:Create(lf1,tweenInfo1,{Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
	local tweenrf1 = tweenService:Create(rf1,tweenInfo1,{Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
	task.wait(0.25)
	local tweenWholeScreen = tweenService:Create(WholeScreen,tweenInfo2,{BackgroundTransparency = 0}):Play()
	task.wait(0.8)
	local tweenlf1 = tweenService:Create(lf1,tweenInfo1,{Position = UDim2.new(-0.5, 0, 0.5, 0)}):Play()
	local tweenrf1 = tweenService:Create(rf1,tweenInfo1,{Position = UDim2.new(1.5, 0, 0.5, 0)}):Play()
	task.wait(0.25)
	local tweenlf1 = tweenService:Create(lf2,tweenInfo1,{Position = UDim2.new(-0.5, 0, 0.5, 0)}):Play()
	local tweenrf1 = tweenService:Create(rf2,tweenInfo1,{Position = UDim2.new(1.5, 0, 0.5, 0)}):Play()
	task.wait(0.25)
	task.wait(1.2)
	playerInWorkspace.HumanoidRootPart.Anchored = false
	local tweenWholeScreen = tweenService:Create(WholeScreen,tweenInfo2,{BackgroundTransparency = 1}):Play()
end

function openedArea(area)
	-- Chuyển màu
	area.Content.Frame.BackgroundTransparency = 1 -- hình không còn bị mờ
	area.Content.TextButton.Text = 'Go' -- chữ dịch chuyển
	area.Content.TextButton.UIGradient.Color = ColorSequence.new(Color3.fromRGB(128, 255, 244), Color3.fromRGB(13, 255, 0)) -- nút có màu xanh

	-- Hiệu ứng rê chuột
	area.Content.TextButton.MouseEnter:Connect(function()
		tweenService:Create(area.Content.TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.6, 0.3)}):Play()
	end)
	area.Content.TextButton.MouseLeave:Connect(function()
		tweenService:Create(area.Content.TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.8, 0.4)}):Play()
	end)
	area.Content.TextButton.MouseButton1Click:Connect(function()
		if area.Content.TextButton.Text == 'Go' then
			local frameTrigger = require(player.PlayerGui.FrameTrigger)
			frameTrigger.CloseFrame('Teleport')
			teleEffect()
			game.ReplicatedStorage.Remotes.Tele:FireServer(area.Name)
			frameTrigger.OpenFrame('Teleport')
		end
	end)	
end

function buyDoor(area)
	local purchaseArea = player.PlayerGui.PurchaseDoor
	local areaDetail = areasData[area.Name]
	
	purchaseDoor.Frame.TextLabel.Text = 'Would you like to purchase this area for '..areaDetail.Price..' Coins?'
	
	purchaseDoor.Frame.Visible = true
	tweenService:Create(purchaseDoor.Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.fromScale(0.5, 0.5)}):Play()
	frames.TextButton.Visible = false
		
	purchaseDoor.Frame.Buy.MouseButton1Click:Once(function()
		purchaseDoor.Frame.Buy.Interactable = false

		if areaDetail.Price <= player.leaderstats.Coins.Value then
			purchaseDoor.Frame.TextLabel.Text = 'Welcome to '..areaDetail.Name
			purchaseDoor.Frame.Buy.Visible = false
			purchaseDoor.Frame.Nah.Visible = false
			
			task.wait(2)
			openedArea(area)

			local nextArea = player.PlayerGui.Frames.Teleport.Frame.ScrollingFrame:FindFirstChild(areaDetail.NextArea)
			if nextArea then
				preOpenArea(nextArea)
			end

			tweenService:Create(purchaseDoor.Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.fromScale(0.5, 1.5)}):Play()
			task.wait(0.2)

			purchaseDoor.Frame.Visible = false
			purchaseDoor.Frame.Buy.Visible = true
			purchaseDoor.Frame.Nah.Visible = true
			frames.TextButton.Visible = true

			local coins = player.leaderstats.Coins.Value - areaDetail.Price
			local level = player.Level.Value + 1
			
			game.ReplicatedStorage.Remotes.PurchaseDoor:FireServer(coins, level)
			task.wait(5)
			
		else
			purchaseDoor.Frame.TextLabel.Text = 'Sorry but it seems that you are a little poor'
			purchaseDoor.Frame.Buy.Visible = false
			purchaseDoor.Frame.Nah.Visible = false

			task.wait(2)
			tweenService:Create(purchaseDoor.Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.fromScale(0.5, 1.5)}):Play()
			task.wait(0.2)
			
			purchaseDoor.Frame.Visible = false
			purchaseDoor.Frame.Buy.Visible = true
			purchaseDoor.Frame.Nah.Visible = true
			frames.TextButton.Visible = true
		end
		purchaseDoor.Frame.Buy.Interactable = true
	end)
	
	purchaseDoor.Frame.Nah.MouseButton1Click:Connect(function()
		tweenService:Create(purchaseDoor.Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.fromScale(0.5, 1.5)}):Play()
		task.wait(0.2)
		purchaseDoor.Frame.Visible = false
		frames.TextButton.Visible = true
	end)
	
end

game.ReplicatedStorage.Remotes.RequestPurchaseDoor.OnClientEvent:Connect(function(door)
	local area = frames.Teleport.Frame.ScrollingFrame:FindFirstChild(areasData[door].NextArea)
	buyDoor(area)
end)

function preOpenArea(area)
	area.Content.Frame.BackgroundTransparency = 0.3 -- hình bị mờ
	area.Content.TextButton.Text = 'Buy' -- chữ dịch chuyển
	area.Content.TextButton.UIGradient.Color = ColorSequence.new(Color3.fromRGB(17, 164, 255), Color3.fromRGB(0, 47, 255)) -- nút có màu xanh dương

	-- Hiệu ứng rê chuột
	area.Content.TextButton.MouseEnter:Connect(function()
		tweenService:Create(area.Content.TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.6, 0.3)}):Play()
	end)
	area.Content.TextButton.MouseLeave:Connect(function()
		tweenService:Create(area.Content.TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.8, 0.4)}):Play()
	end)
	area.Content.TextButton.MouseButton1Click:Connect(function()
		if area.Content.TextButton.Text == 'Buy' then
			buyDoor(area)
		end
	end)
end

game.ReplicatedStorage.Remotes.CreateTeleport.OnClientEvent:Connect(function()
	local teleport = player.PlayerGui.Frames.Teleport
	local scrollingFrame = teleport.Frame.ScrollingFrame
	
	local checkpointsTable = CheckPoints:GetChildren()
	
	table.sort(checkpointsTable, function(area1, area2)
		local areaData1 = areasData[area1.Name]
		local areaData2 = areasData[area2.Name]
		return areaData1.Location < areaData2.Location
	end)
		
	for _, area in pairs(checkpointsTable) do -- từng khu vực
		local areaData = areasData[area.Name]
		
		local newArea = scrollingFrame.Frame:Clone()
		newArea.Name = area.Name
		newArea.Parent = scrollingFrame
		newArea.Content.ImageLabel.Image = areaData.Image
		newArea.Content.AreaName.Text = newArea.Name
		
		if player.Level.Value >= areaData.Location then -- Khu vực có thể tele
			openedArea(newArea)
		elseif player.Level.Value + 1 == areaData.Location then -- Khu vực mở tiếp theo
			preOpenArea(newArea)
		elseif player.Level.Value < areaData.Location then
			newArea.Content.Frame.BackgroundTransparency = 0.3 -- hình bị mờ
			newArea.Content.TextButton.Text = 'Locked' -- chữ dịch chuyển
			newArea.Content.TextButton.UIGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0)) -- nút có màu xám đen
		end
	end
	
	scrollingFrame.Frame:Destroy()
end)

frames.Teleport.Frame.CloseButton.MouseButton1Click:Connect(function()
	local frameTrigger = require(player.PlayerGui.FrameTrigger)
	frameTrigger.CloseFrame('Teleport')
end)


