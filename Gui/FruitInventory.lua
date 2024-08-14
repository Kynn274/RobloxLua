local player = game.Players.LocalPlayer

local Frames = player.PlayerGui.Frames
local FruitInventory = Frames.FruitInventory
local Frame = FruitInventory.Frame
local Alert = Frames.Alert
local frameTrigger = require(player.PlayerGui.FrameTrigger)

local expand = false
local selected = false
local numberSelected = 0

local icon = require(game.ReplicatedStorage.JSON.Icon)

--Frame.MouseEnter:Connect(function()
--	numberOfFruits = table.maxn(player.Pets:GetChildren())
	
--	Frame.UIStroke.Transparency = 0
--	Frame.Expand.ImageTransparency = 0
--	Frame.Title.TextTransparency = 0
--	Frame.Select.BackgroundTransparency = 0
--	Frame.Sell.BackgroundTransparency = 0
--	Frame.All.BackgroundTransparency = 0
	
--	for _, pet in pairs(Frame.ScrollingFrame:GetChildren()) do
--		if pet:IsA('Frame') then
--			pet.ImageButton.ImageTransparency = 0
--			if pet.ImageButton:FindFirstChild('TextLabel') then
--				pet.ImageButton.TextLabel.TextTransparency = 0
--				pet.ImageButton.UIStroke.Transparency = 0
--			end
--		end
--	end
	
--	--local numberOfFruits = table.maxn(player.Pets:GetChildren())
--	--local maxSize = math.ceil(numberOfFruits / 15)
	
--end)

--Frame.MouseLeave:Connect(function()
--	Frame.UIStroke.Transparency = 0.4
--	Frame.Expand.ImageTransparency = 0.4
--	Frame.Title.TextTransparency = 0.4
--	Frame.Select.BackgroundTransparency = 0.4
--	Frame.Sell.BackgroundTransparency = 0.4
--	Frame.All.BackgroundTransparency = 0.4
	
--	for _, pet in pairs(Frame.ScrollingFrame:GetChildren()) do
--		if pet:IsA('Frame') then
--			pet.ImageButton.ImageTransparency = 0.4
--			if pet.ImageButton:FindFirstChild('TextLabel') then
--				pet.ImageButton.TextLabel.TextTransparency = 0.4
--				pet.ImageButton.UIStroke.Transparency = 0.4
--			end		
--		end
--	end
--end)

Frame.Expand.MouseButton1Click:Connect(function()
	if expand == false then
		Frame.Size = UDim2.fromScale(0.8, 0.65)
		Frame.Title.Size = UDim2.fromScale(0.15, 0.15)
		Frame.Expand.Rotation = 90
		Frame.Select.Position = UDim2.fromScale(0.98, 0.02)
		Frame.Select.Size = UDim2.fromScale(0.15, 0.1)
		
		Frame.Sell.Position = UDim2.fromScale(0.8, 0.02)
		Frame.Sell.Size = UDim2.fromScale(0.1, 0.1)

		Frame.All.Position = UDim2.fromScale(0.67, 0.02)
		Frame.All.Size = UDim2.fromScale(0.25, 0.1)
		
		expand = true		
		Frame.ScrollingFrame.Size = UDim2.fromScale(0.95, 0.8)
		Frame.ScrollingFrame.CanvasSize = UDim2.fromScale(0, 1)
		Frame.ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Frame.ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
		Frame.ScrollingFrame.UIGridLayout.FillDirection = Enum.FillDirection.Horizontal
		Frame.ScrollingFrame.UIGridLayout.CellSize = UDim2.fromScale(0.2, 0.33)
		Frame.ScrollingFrame.UIPadding.PaddingTop = UDim.new(0, 0)
		Frame.ScrollingFrame.UIPadding.PaddingBottom = UDim.new(0, 0)
		Frame.ScrollingFrame.UIPadding.PaddingRight = UDim.new(0, 0)
		Frame.ScrollingFrame.UIPadding.PaddingLeft = UDim.new(0, 0)
		for _, pet in pairs(Frame.ScrollingFrame:GetChildren()) do
			if pet:IsA('Frame') then
				pet.ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeXX
				pet.ImageButton.Size = UDim2.fromScale(0.75, 0.75)
			end
		end
	else
		Frame.Size = UDim2.fromScale(0.8, 0.25)
		Frame.Title.Size = UDim2.fromScale(0.15, 0.25)
		Frame.Expand.Rotation = -90
		Frame.Select.Position = UDim2.fromScale(0.98, 0.05)
		Frame.Select.Size = UDim2.fromScale(0.15, 0.2)
		
		Frame.Sell.Position = UDim2.fromScale(0.8, 0.05)
		Frame.Sell.Size = UDim2.fromScale(0.1, 0.2)
		
		Frame.All.Position = UDim2.fromScale(0.67, 0.05)
		Frame.All.Size = UDim2.fromScale(0.2, 0.2)
		
		expand = false		
		Frame.ScrollingFrame.Size = UDim2.fromScale(0.95, 0.65)
		Frame.ScrollingFrame.CanvasSize = UDim2.fromScale(1, 0)
		Frame.ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
		Frame.ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
		Frame.ScrollingFrame.UIGridLayout.FillDirection = Enum.FillDirection.Vertical
		Frame.ScrollingFrame.UIGridLayout.CellSize = UDim2.fromScale(0.2, 1)
		Frame.ScrollingFrame.UIPadding.PaddingTop = UDim.new(0.15, 0)
		Frame.ScrollingFrame.UIPadding.PaddingBottom = UDim.new(0.15, 0)
		Frame.ScrollingFrame.UIPadding.PaddingRight = UDim.new(0, 0)
		Frame.ScrollingFrame.UIPadding.PaddingLeft = UDim.new(0, 0)
		for _, pet in pairs(Frame.ScrollingFrame:GetChildren()) do
			if pet:IsA('Frame') then
				pet.ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
				pet.ImageButton.Size = UDim2.fromScale(1, 1)
			end
		end
	end
end)

Frame.Select.MouseButton1Click:Connect(function()
	if selected == false then
		Frame.Select.Text = 'UnSelect'
		selected = true
		
		Frame.Sell.Visible = true
		Frame.All.Visible = true
		
		for _, pet in pairs(Frame.ScrollingFrame:GetChildren()) do
			if pet:IsA('Frame') then
				pet.ImageButton.Select.Visible = true
				--pet.ImageButton.Interactable = false
				if pet.ImageButton.Equipped.Value == true then
					pet.ImageButton.Chose.Value = 0
					pet.ImageButton.Select.Visible = false
				end
				
				pet.ImageButton.Select.MouseButton1Click:Connect(function()
					if pet.ImageButton.Chose.Value == 0 then
						pet.ImageButton.Chose.Value = 1
						pet.ImageButton.Select.Image = icon['Selected']
						numberSelected += 1
						print(numberSelected)
					else
						pet.ImageButton.Chose.Value = 0
						pet.ImageButton.Select.Image = icon['Select']
						numberSelected -= 1
						print(numberSelected)
					end
				end)
			end
		end
		
	else
		Frame.Select.Text = 'Select'
		Frame.Sell.Visible = false
		Frame.All.Visible = false
		Frame.All.SelectAll.Value = 0
		Frame.All.ImageButton.Image = icon['Tick']
		numberSelected = 0
		selected = false

		for _, pet in pairs(Frame.ScrollingFrame:GetChildren()) do
			if pet:IsA('Frame') then
				pet.ImageButton.Chose.Value = 0
				pet.ImageButton.Select.Image = icon['Select']
				pet.ImageButton.Select.Visible = false
			end
		end		
	end
end)

function selectAll()
	local numberOfFruits = table.maxn(player.Pets:GetChildren())
	
	if Frame.All.SelectAll.Value == 0 then
		for _, pet in pairs(Frame.ScrollingFrame:GetChildren()) do
			if pet:IsA('Frame') then
				pet.ImageButton.Chose.Value = 1
				pet.ImageButton.Select.Image = icon['Selected']
			end
		end
		numberSelected = numberOfFruits
		Frame.All.SelectAll.Value = 1
		Frame.All.ImageButton.Image = icon['Ticked']
		print(numberSelected)
	else
		for _, pet in pairs(Frame.ScrollingFrame:GetChildren()) do
			if pet:IsA('Frame') then
				pet.ImageButton.Chose.Value = 0
				pet.ImageButton.Select.Image = icon['Select']
		end
			end
		numberSelected = 0
		Frame.All.SelectAll.Value = 0
		Frame.All.ImageButton.Image = icon['Tick']
		print(numberSelected)

	end
end

-- price/pet = petDamage * 80%
function sell()
	print('ye')
	Alert.Visible = true
	Alert.Size = UDim2.fromScale(1, 1)
	
	if numberSelected == 0 then
		Alert.Frame.PurchaseText.Text = 'There is no selected fruit.'
		Alert.Frame.Close.Size = UDim2.fromScale(0.9, 0.2)
		Alert.Frame.Close.AnchorPoint = Vector2.new(0.5, 1)
		Alert.Frame.Close.Position = UDim2.fromScale(0.5, 0.9)
		Alert.Frame.Buy.Visible = false
	else
		print(1)
		Alert.Frame.Buy.Size = UDim2.fromScale(0.4, 0.2)
		Alert.Frame.Buy.AnchorPoint = Vector2.new(0, 1)
		Alert.Frame.Buy.Position = UDim2.fromScale(0.05, 0.9)
		
		Alert.Frame.Buy.Visible = true
		Alert.Frame.Close.Size = UDim2.fromScale(0.4, 0.2)
		Alert.Frame.Close.AnchorPoint = Vector2.new(1, 1)
		Alert.Frame.Close.Position = UDim2.fromScale(0.95, 0.9)
		
		local price = 0
		
		for _, pet in pairs(FruitInventory.Frame.ScrollingFrame:GetChildren()) do
			if pet:IsA('Frame') then
				if pet.ImageButton.Chose.Value == 1 then
					if player.PetLibrary:FindFirstChild(pet.Name) then
						price += math.round((player.PetLibrary:FindFirstChild(pet.Name).damage.Value * 80 / 100 + 30))
						print(price)
					end
				end
			end
		end
		
		Alert.Frame.PurchaseText.Text = 'Would you like to sell your fruits for '..tostring(price)..' coins?'
		
		Alert.Frame.Buy.MouseButton1Click:Connect(function()
			for _, pet in pairs(FruitInventory.Frame.ScrollingFrame:GetChildren()) do
				if pet:IsA('Frame') then
					if pet.ImageButton.Chose.Value == 1 then
						if player.PetLibrary:FindFirstChild(pet.Name) then
							player.PetLibrary:FindFirstChild(pet.Name).number.Value -= 1
							player.Pets:FindFirstChild(pet.Name):Destroy()
						end
					end
				end
			end
			
			local list = {}
			
			for _, pet in pairs(player.PetLibrary:GetChildren()) do
				table.insert(list, pet.number.Value)
			end
			
			game.ReplicatedStorage.Remotes.SellFruit:FireServer(list, player.leaderstats.Coins.Value + price)
			for _, pet in pairs(FruitInventory.Frame.ScrollingFrame:GetChildren()) do
				if pet:IsA('Frame') then
					if pet.ImageButton.Chose.Value == 1 then
						if player.PetLibrary:FindFirstChild(pet.Name) then
							pet:Destroy()
						end
					end
				end
			end
						
			numberSelected = 0
			Alert.Visible = false
			
		end)
	end
end

Alert.Frame.Close.MouseButton1Click:Connect(function()
	Alert.Visible = false
end)

Frame.All.MouseButton1Click:Connect(selectAll)
Frame.All.ImageButton.MouseButton1Click:Connect(selectAll)
Frame.Sell.MouseButton1Click:Connect(sell)

