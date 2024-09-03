local player = game.Players.LocalPlayer
local tweenService = game.TweenService

local Frames = player.PlayerGui.Frames
local FruitInventory = Frames.FruitInventory
local Frame = FruitInventory.Frame
local Alert = Frames.Alert
local frameTrigger = require(player.PlayerGui.FrameTrigger)

local expand = false
local selected = false
local selectSell = 0
local selectUpgrading = 0

local icon = require(game.ReplicatedStorage.JSON.Icon)

--[[
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

for _, pet in pairs(Frame.ScrollingFrame:GetChildren()) do
	if pet:IsA('Frame') then
		print(1)
		-- Choose Upgrade Fruit
		pet.UpgradeButton.Select.MouseButton1Click:Connect(function()
			print(1)
			if pet.UpgradeButton.Chose.Value == 0 then
				pet.UpgradeButton.Chose.Value = 1
				pet.UpgradeButton.Select.Image = icon['Selected']
				selectUpgrading += 1
				print(selectUpgrading)
			else
				pet.UpgradeButton.Chose.Value = 0
				pet.UpgradeButton.Select.Image = icon['Select']
				selectUpgrading -= 1
				print(selectUpgrading)
			end
		end)

		pet.UpgradeButton.MouseButton1Click:Connect(function()
			print(1)

			if pet.UpgradeButton.Chose.Value == 0 then
				pet.UpgradeButton.Chose.Value = 1
				pet.UpgradeButton.Select.Image = icon['Selected']
				selectUpgrading += 1
				print(selectUpgrading)
			else
				pet.UpgradeButton.Chose.Value = 0
				pet.UpgradeButton.Select.Image = icon['Select']
				selectUpgrading -= 1
				print(selectUpgrading)
			end
		end)

		-- Choose Sell Fruit
		pet.SelectButton.Select.MouseButton1Click:Connect(function()
			if pet.SelectButton.Chose.Value == 0 then
				pet.SelectButton.Chose.Value = 1
				pet.SelectButton.Select.Image = icon['Selected']
				selectSell += 1
				print(selectSell)
			else
				pet.SelectButton.Chose.Value = 0
				pet.SelectButton.Select.Image = icon['Select']
				selectSell -= 1
				print(selectSell)
			end
		end)

		pet.SelectButton.MouseButton1Click:Connect(function()
			if pet.SelectButton.Chose.Value == 0 then
				pet.SelectButton.Chose.Value = 1
				pet.SelectButton.Select.Image = icon['Selected']
				selectSell += 1
				print(selectSell)
			else
				pet.SelectButton.Chose.Value = 0
				pet.SelectButton.Select.Image = icon['Select']
				selectSell -= 1
				print(selectSell)
			end
		end)
	end
end

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

--Frame.Select.MouseButton1Click:Connect(function()
--	if selected == false then
--		Frame.Select.Text = 'UnSelect'
--		selected = true
		
--		Frame.Sell.Visible = true
--		Frame.All.Visible = true
		
--		for _, pet in pairs(Frame.ScrollingFrame:GetChildren()) do
--			if pet:IsA('Frame') then
--				pet.SelectButton.Visible = true
--				pet.ImageButton.Interactable = false
				
--				if pet.ImageButton.Equipped.Value == true then
--					pet.ImageButton.Chose.Value = 0
--					pet.SelectButton.Visible = false
--				end
				
--				pet.SelectButton.Select.MouseButton1Click:Connect(function()
--					if pet.ImageButton.Chose.Value == 0 then
--						pet.ImageButton.Chose.Value = 1
--						pet.SelectButton.Select.Image = icon['Selected']
--						selectSell += 1
--						print(selectSell)
--					else
--						pet.ImageButton.Chose.Value = 0
--						pet.SelectButton.Select.Image = icon['Select']
--						selectSell -= 1
--						print(selectSell)
--					end
--				end)
				
--				pet.SelectButton.MouseButton1Click:Connect(function()
--					if pet.ImageButton.Chose.Value == 0 then
--						pet.ImageButton.Chose.Value = 1
--						pet.SelectButton.Select.Image = icon['Selected']
--						selectSell += 1
--						print(selectSell)
--					else
--						pet.ImageButton.Chose.Value = 0
--						pet.SelectButton.Select.Image = icon['Select']
--						selectSell -= 1
--						print(selectSell)
--					end
--				end)
--			end
--		end
		
--	else
--		Frame.Select.Text = 'Select'
--		Frame.Sell.Visible = false
--		Frame.All.Visible = false
--		Frame.All.SelectAll.Value = 0
--		Frame.All.ImageButton.Image = icon['Tick']
--		selectSell = 0
--		selected = false

--		for _, pet in pairs(Frame.ScrollingFrame:GetChildren()) do
--			if pet:IsA('Frame') then
--				pet.ImageButton.Interactable = true
--				pet.ImageButton.Chose.Value = 0
--				pet.SelectButton.Select.Image = icon['Select']
--				pet.SelectButton.Visible = false
--			end
--		end		
--	end
--end)

FruitInventory.Frame.Frame.Sell.MouseButton1Click:Connect(function()
	if FruitInventory.Frame.Frame.Sell.Chosen.Value == 0 then
		Frame.SellFruits.Visible = true
		Frame.All.Visible = true
		Frame.Frame.Sell.Chosen.Value = 1
		Frame.Frame.EquipFruit.Chosen.Value = 0
		Frame.Frame.FusionUpgrade.Chosen.Value = 0
		selectSell = 0
		
		-- Close upgrade mood
		Frame.ScrollingFrame.UIGridLayout.CellSize = UDim2.fromScale(0.2, 0.333)
		tweenService:Create(Frame.UpgradeTable, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0, 0.8)}):Play()
		tweenService:Create(Frame.ScrollingFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(1, 0.85)}):Play()
		Frame.UpgradeTable.Visible = false
		Frame.UpgradeTable.UIStroke.Enabled = false
		selectUpgrading = 0
		
		-- Open sell mood
		for _, pet in pairs(Frame.ScrollingFrame:GetChildren()) do
			if pet:IsA('Frame') then
				pet.SelectButton.Chose.Value = 0
				pet.SelectButton.Visible = true
				pet.SelectButton.Select.Image = icon['Select']
				pet.UpgradeButton.Chose.Value = 0
				pet.UpgradeButton.Visible = false
				pet.UpgradeButton.Select.Image = icon['Select']
				pet.ImageButton.Interactable = false
				
				if pet.ImageButton.Equipped.Value == true then
					pet.SelectButton.Chose.Value = 0
					pet.SelectButton.Visible = false
				end
			end
		end
	end
end)

FruitInventory.Frame.Frame.EquipFruit.MouseButton1Click:Connect(function()
	if FruitInventory.Frame.Frame.EquipFruit.Chosen.Value == 0 then
		Frame.Frame.Sell.Chosen.Value = 0
		Frame.Frame.EquipFruit.Chosen.Value = 1
		Frame.Frame.FusionUpgrade.Chosen.Value = 0
		selectSell = 0
		selectUpgrading = 0
		
		for _, pet in pairs(Frame.ScrollingFrame:GetChildren()) do
			if pet:IsA('Frame') then
				pet.ImageButton.Interactable = true
				pet.SelectButton.Chose.Value = 0
				pet.SelectButton.Select.Image = icon['Select']
				pet.SelectButton.Visible = false
				pet.UpgradeButton.Chose.Value = 0
				pet.UpgradeButton.Visible = false
				pet.UpgradeButton.Select.Image = icon['Select']
			end
		end
		
		-- Close sell mood
		Frame.All.Visible = false
		Frame.All.SelectAll.Value = 0
		Frame.All.ImageButton.Image = icon['Tick']
		Frame.SellFruits.Visible = false
				
		-- Close upgrade mood
		Frame.ScrollingFrame.UIGridLayout.CellSize = UDim2.fromScale(0.2, 0.333)
		tweenService:Create(Frame.UpgradeTable, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0, 0.8)}):Play()
		tweenService:Create(Frame.ScrollingFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(1, 0.85)}):Play()
		Frame.UpgradeTable.Visible = false
		Frame.UpgradeTable.UIStroke.Enabled = false
		
	end
end)

FruitInventory.Frame.Frame.FusionUpgrade.MouseButton1Click:Connect(function()
	if FruitInventory.Frame.Frame.FusionUpgrade.Chosen.Value == 0 then
		Frame.Frame.Sell.Chosen.Value = 0
		Frame.Frame.EquipFruit.Chosen.Value = 0
		Frame.Frame.FusionUpgrade.Chosen.Value = 1
		
		-- Open Upgrade mood
		Frame.UpgradeTable.Visible = true
		Frame.UpgradeTable.UIStroke.Enabled = true
		Frame.ScrollingFrame.UIGridLayout.CellSize = UDim2.fromScale(0.333, 0.333)
		tweenService:Create(Frame.UpgradeTable, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.45, 0.8)}):Play()
		tweenService:Create(Frame.ScrollingFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.5, 0.85)}):Play()
		selectUpgrading = 0
		
		-- Close Sell mood
		Frame.All.Visible = false
		Frame.All.SelectAll.Value = 0
		Frame.All.ImageButton.Image = icon['Tick']
		Frame.SellFruits.Visible = false
		selectSell = 0
		
		-- Open Upgrade mood
		for _, pet in pairs(Frame.ScrollingFrame:GetChildren()) do
			if pet:IsA('Frame') then
				pet.ImageButton.Interactable = false
				pet.SelectButton.Chose.Value = 0
				pet.SelectButton.Select.Image = icon['Select']
				pet.SelectButton.Visible = false
				pet.UpgradeButton.Chose.Value = 0
				pet.UpgradeButton.Visible = true
				pet.UpgradeButton.Select.Image = icon['Select']

				if pet.ImageButton.Equipped.Value == true then
					pet.UpgradeButton.Chose.Value = 0
					pet.UpgradeButton.Visible = false
				end
				
			end
		end
	end
end)



function selectAll()
	local numberOfFruits = table.maxn(player.Pets:GetChildren())
	
	if Frame.All.SelectAll.Value == 0 then
		for _, pet in pairs(Frame.ScrollingFrame:GetChildren()) do
			if pet:IsA('Frame') and pet.Visible == true then
				pet.SelectButton.Chose.Value = 1
				pet.SelectButton.Select.Image = icon['Selected']
				selectSell += 1
			end
		end
		Frame.All.SelectAll.Value = 1
		Frame.All.ImageButton.Image = icon['Ticked']
		print(selectSell)
	else
		for _, pet in pairs(Frame.ScrollingFrame:GetChildren()) do
			if pet:IsA('Frame') then
				pet.SelectButton.Chose.Value = 0
				pet.SelectButton.Select.Image = icon['Select']
			end
		end
		selectSell = 0
		Frame.All.SelectAll.Value = 0
		Frame.All.ImageButton.Image = icon['Tick']
		print(selectSell)

	end
end

-- price/pet = petDamage * 80%
function sell()
	print('ye')
	Alert.Visible = true
	Alert.Size = UDim2.fromScale(2, 2)
	
	if selectSell == 0 then
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
				if pet.SelectButton.Chose.Value == 1 then
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
					if pet.SelectButton.Chose.Value == 1 then
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
					if pet.SelectButton.Chose.Value == 1 then
						if player.PetLibrary:FindFirstChild(pet.Name) then
							pet:Destroy()
						end
					end
				end
			end
			
			if Frame.All.SelectAll.Value == 1 then
				Frame.All.SelectAll.Value = 0
				Frame.All.ImageButton.Image = icon['Tick']
			end
			
			selectSell = 0
			Alert.Visible = false
		end)
	end
end

game.ReplicatedStorage.Remotes.CreateFruitInventory.OnClientEvent:Connect(function()
	local FruitData = require(game.Workspace.MainFolder_Workspace.Fruits.GachaTree.Data).fruitPets
	local defaultOrder = {
		['Common'] = 1,
		['Uncommon'] = 2,
		['Rare'] = 3,
		['Epic'] = 4,
		['Legendary'] = 5
	}

	-- Sort
	local rarityList = {}
	for _, grpet in pairs(FruitData) do
		table.insert(rarityList, defaultOrder[grpet[1].Rarity], grpet[1].Rarity)
	end
	for i = 1, #rarityList do
		if rarityList[i] == nil then
			table.remove(rarityList, i)
			i -= 1
		end
	end
	
	local filter = FruitInventory.Frame.Filter
	local expand = filter.Expand
	local frame = filter.Frame
		
	for i = 1, #rarityList do
		local newButton = frame.TextButton:Clone()
		newButton.Parent = frame
		newButton.Name = rarityList[i]
		newButton.Text = rarityList[i]	
		
		newButton.MouseEnter:Connect(function()
			newButton.BackgroundTransparency = 0
			newButton.TextColor3 = Color3.fromRGB(0, 0, 0)
		end)
		newButton.MouseLeave:Connect(function()
			newButton.BackgroundTransparency = 1
			newButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		end)
		newButton.MouseButton1Click:Connect(function()
			filter.TextLabel.Text = newButton.Name
			tweenService:Create(expand, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 180}):Play()
			tweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(1, 0)}):Play()
			frame.AutomaticSize = Enum.AutomaticSize.None
			filter.Opened.Value = 0
			chooseGroupPet(newButton.Name)
		end)
	end
	
	local All = frame.TextButton
	All.Name = 'All'
	All.Text = 'All'
	All.MouseEnter:Connect(function()
		All.BackgroundTransparency = 0
		All.TextColor3 = Color3.fromRGB(0, 0, 0)
	end)
	All.MouseLeave:Connect(function()
		All.BackgroundTransparency = 1
		All.TextColor3 = Color3.fromRGB(255, 255, 255)
	end)
	All.MouseButton1Click:Connect(function()
		filter.TextLabel.Text = All.Name
		tweenService:Create(expand, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 180}):Play()
		tweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(1, 0)}):Play()
		frame.AutomaticSize = Enum.AutomaticSize.None
		filter.Opened.Value = 0
		chooseAll()
	end)
	
	filter.MouseButton1Click:Connect(function()
		if filter.Opened.Value == 0 then
			tweenService:Create(expand, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 90}):Play()
			tweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(1, 0.8)}):Play()
			frame.AutomaticSize = Enum.AutomaticSize.Y
			filter.Opened.Value = 1
		else
			tweenService:Create(expand, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 180}):Play()
			tweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(1, 0)}):Play()
			frame.AutomaticSize = Enum.AutomaticSize.None
			filter.Opened.Value = 0
		end
	end)
	
	expand.MouseButton1Click:Connect(function()
		if filter.Opened.Value == 0 then
			tweenService:Create(expand, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 90}):Play()
			tweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(1, 0.8)}):Play()
			frame.AutomaticSize = Enum.AutomaticSize.Y
			filter.Opened.Value = 1
		else
			tweenService:Create(expand, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 180}):Play()
			tweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(1, 0)}):Play()
			frame.AutomaticSize = Enum.AutomaticSize.None
			filter.Opened.Value = 0
		end
	end)
end)

function chooseAll()
	for _, fruit in pairs(FruitInventory.Frame.ScrollingFrame:GetChildren()) do
		if fruit:IsA('Frame') and player.PetLibrary:FindFirstChild(fruit.Name) then
			fruit.Visible = true
		end
	end
end

function chooseGroupPet(rarity)
	for _, fruit in pairs(FruitInventory.Frame.ScrollingFrame:GetChildren()) do
		if fruit:IsA('Frame') then
			local fruitDetail = player.PetLibrary:FindFirstChild(fruit.Name)
			if fruitDetail then
				print(fruitDetail)
				if fruitDetail.rarity.Value == rarity then
					fruit.Visible = true
				else
					fruit.Visible = false
				end
			end
		end
	end
end



Alert.Frame.Close.MouseButton1Click:Connect(function()
	Alert.Visible = false
end)

Frame.All.MouseButton1Click:Connect(selectAll)
Frame.All.ImageButton.MouseButton1Click:Connect(selectAll)
Frame.SellFruits.MouseButton1Click:Connect(sell)
]]--
