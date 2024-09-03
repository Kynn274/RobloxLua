local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer

local fruits = game.Workspace.MainFolder_Workspace.Fruits
local remotes = replicatedStorage:WaitForChild("Remotes")
local pets = replicatedStorage:WaitForChild("Pets")
local JSON = replicatedStorage:WaitForChild("JSON")

local orb = game.Workspace.MainFolder_Workspace.Fruits.GachaTree:WaitForChild('Orb')
local orbAtt = orb.Attachment
local orbParticleEmitter = orbAtt.ParticleEmitter

-- Gui
local Frames = player.PlayerGui.Frames
local FruitInventory = Frames.FruitInventory
local Frame = FruitInventory.Frame
local Alert = Frames.Alert
local frameTrigger = require(player.PlayerGui.FrameTrigger)

-- Module
local module3D = require(replicatedStorage:WaitForChild("Module3D"))
local icon = require(replicatedStorage.JSON.Icon)

-- Var
local selectSell = 0
local selectUpgrading = 0
local numberEquipped = 0
local limitNum = 4

-- fruitInventory Script
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
		--print(selectSell)
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
		--print(selectSell)

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
				table.insert(list, pet)
			end

			game.ReplicatedStorage.Remotes.SellFruit:FireServer(list, price)
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
				--print(fruitDetail)
				if fruitDetail.rarity.Value == rarity then
					fruit.Visible = true
				else
					fruit.Visible = false
				end
			end
		end
	end
end

function chooseUpgradeFruit(newTemplate)
	if selectUpgrading == 4 then
		Frame.WarnText.Visible = true
		Frame.WarnText.Text = 'Reached the limit number.'
		task.wait(2)
		Frame.WarnText.Visible = false
	else
		if newTemplate.UpgradeButton.Chose.Value == 0 then
			newTemplate.UpgradeButton.Chose.Value = 1
			newTemplate.UpgradeButton.Select.Image = icon['Selected']
			selectUpgrading += 1
			--print(selectUpgrading)
		else
			newTemplate.UpgradeButton.Chose.Value = 0
			newTemplate.UpgradeButton.Select.Image = icon['Select']
			selectUpgrading -= 1
			--print(selectUpgrading)
		end
	end
end

function chooseSellFruit(newTemplate)
	if newTemplate.SelectButton.Chose.Value == 0 then
		newTemplate.SelectButton.Chose.Value = 1
		newTemplate.SelectButton.Select.Image = icon['Selected']
		selectSell += 1
		--print(selectSell)
	else
		newTemplate.SelectButton.Chose.Value = 0
		newTemplate.SelectButton.Select.Image = icon['Select']
		selectSell -= 1
		--print(selectSell)
	end
end

Alert.Frame.Close.MouseButton1Click:Connect(function()
	Alert.Visible = false
end)

Frame.All.MouseButton1Click:Connect(selectAll)
Frame.All.ImageButton.MouseButton1Click:Connect(selectAll)
Frame.SellFruits.MouseButton1Click:Connect(sell)




-- Gacha Script
local function onTemplateClick(clickedTemplate)
	local fruitInventory = player.PlayerGui.Frames.FruitInventory
	local petDisplayGui = player.PlayerGui.PetsDisplayGUI
	local petsHolder = petDisplayGui.SelectedFruits.ScrollingFrame
	
	if clickedTemplate.Equipped.Value == false then
		if numberEquipped < limitNum then
			-- Đổi màu trong FruitInventory
			clickedTemplate.Frame.Visible = true
			clickedTemplate.Equipped.Value = true
			clickedTemplate.BackgroundColor3 = Color3.fromRGB(85, 255, 0)
			clickedTemplate.Parent.SelectButton.Visible = false
			clickedTemplate.Parent.SelectButton.Chose.Value = 0
			clickedTemplate.Parent.UpgradeButton.Visible = false
			clickedTemplate.Parent.UpgradeButton.Chose.Value = 0
		
			-- Gửi lệnh equipPet
			remotes.EquipPet:FireServer(clickedTemplate.Parent.Name)
				
			-- Tạo trong petsDisplay
			local newPetDisplay = petsHolder.Pet:Clone()
			newPetDisplay.Name = clickedTemplate.Parent.Name
			--newPetDisplay.Image = clickedTemplate.Image
			newPetDisplay.Parent = petsHolder
			newPetDisplay.Visible = true
			
			local pet = replicatedStorage.Pets:FindFirstChild(newPetDisplay.Name):Clone()
			local Model3D = module3D:Attach3D(newPetDisplay.PetDisplayFrame, pet)
			Model3D:SetDepthMultiplier(1.2)
			Model3D.Camera.FieldOfView = 5
			Model3D.Visible = true
			
			game:GetService("RunService").RenderStepped:Connect(function()
				Model3D:SetCFrame(CFrame.Angles(0,tick() % (math.pi * 2),0) * CFrame.Angles(math.rad(-10),0,0))
			end)
			
			numberEquipped += 1
			
			if numberEquipped > 0 then
				petDisplayGui.SelectedFruits.Size = UDim2.fromScale(numberEquipped * 0.15, 0.15)
				petDisplayGui.SelectedFruits.Visible = true
				petDisplayGui.SelectedFruits.ScrollingFrame.UIGridLayout.CellSize = UDim2.fromScale(1 / numberEquipped, 0.8)
			end
		end
	else		
		-- Trường hợp chọn lập
		clickedTemplate.Frame.Visible = false
		clickedTemplate.Equipped.Value = false
		clickedTemplate.BackgroundColor3 = Color3.fromRGB(116, 116, 116)
		if fruitInventory.Frame.Select.Text == 'UnSelect' then
			clickedTemplate.Select.Visible = true
		end
		clickedTemplate.Chose.Value = 0
		numberEquipped -= 1
		
		remotes.UnequipPets:FireServer(clickedTemplate.Parent.Name)
		petDisplayGui.SelectedFruits.ScrollingFrame:FindFirstChild(clickedTemplate.Parent.Name):Destroy()
		
		if numberEquipped == 0 then
			petDisplayGui.SelectedFruits.Visible = false
		else
			petDisplayGui.SelectedFruits.Size = UDim2.fromScale(numberEquipped * 0.15, 0.15)
			petDisplayGui.SelectedFruits.ScrollingFrame.UIGridLayout.CellSize = UDim2.fromScale(1 / numberEquipped, 0.8)
		end
	end
end

local function createTemplate(chosenPet)
	local scrollingFrame = player.PlayerGui.Frames.FruitInventory.Frame.ScrollingFrame
	local template = scrollingFrame:FindFirstChild('Template')
	local petInfo = player.PetLibrary:FindFirstChild(chosenPet.Name)
	
	local newTemplate = template:Clone()
	
	newTemplate.Name = chosenPet.Name
	newTemplate.Visible = true
	newTemplate.Parent = scrollingFrame
	
	newTemplate.ImageButton.Image = petInfo.avatar.Value
	newTemplate.ImageButton.HoverImage = petInfo.avatar.Value
	
	local Speed = Instance.new('IntValue')
	Speed.Name = 'Speed'
	Speed.Parent = newTemplate.ImageButton
	Speed.Value = petInfo.damage.Value
	
	local TextLabel = Instance.new('TextLabel')
	TextLabel.Parent = newTemplate.ImageButton
	TextLabel.Name = 'TextLabel'
	TextLabel.Size = UDim2.new(1,0,0.5,0)
	TextLabel.Text = tostring(Speed.Value)
	TextLabel.TextScaled = true
	
	if petInfo.rarity.Value == 'Common' then
		TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		--print(1)
	elseif petInfo.rarity.Value == 'Uncommon' then
		TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
		--print(2)
	elseif petInfo.rarity.Value == 'Rare' then
		TextLabel.TextColor3 = Color3.fromRGB(85, 85, 255)
	elseif petInfo.rarity.Value == 'Epic' then
		TextLabel.TextColor3 = Color3.fromRGB(200, 0, 255)
		--print(3)
	elseif petInfo.rarity.Value == 'Legendary' then
		TextLabel.TextColor3 = Color3.fromRGB(255, 235, 16)
		--print(4)
	end
	
	TextLabel.BackgroundTransparency = 1
	TextLabel.FontFace = Font.fromName('FredokaOne')
	TextLabel.AnchorPoint = Vector2.new(0.5,0.5)
	TextLabel.Position = UDim2.new(0.5,0,1,0)
	
	local UICorner = Instance.new('UICorner')
	UICorner.Parent = TextLabel
	UICorner.Name = 'UICorner'
	UICorner.CornerRadius = UDim.new(0, 15)
	
	local UIStroke = Instance.new('UIStroke')
	UIStroke.Parent = TextLabel
	UIStroke.Name = 'UIStroke'
	UIStroke.Color = Color3.fromRGB(0, 0, 0)
	UIStroke.Thickness = 2
	
	local Viewport = Instance.new('Frame')
	Viewport.Name = 'Viewport'
	Viewport.Parent = newTemplate.ImageButton
	Viewport.BackgroundTransparency = 1
	Viewport.Size = UDim2.new(1, 0, 1, 0)
		
	local petModel3D = module3D:Attach3D(newTemplate.ImageButton:WaitForChild("Viewport"), pets:FindFirstChild(chosenPet.Name):Clone())
	petModel3D:SetDepthMultiplier(2)
	petModel3D.Camera.FieldOfView = 5
	
	runService.RenderStepped:Connect(function()
		petModel3D:SetCFrame(CFrame.Angles(0,tick() % (math.pi * 2),0) * CFrame.Angles(math.rad(-10),0,0))
	end)
	
	-- template's Button Click
	newTemplate.ImageButton.MouseButton1Click:Connect(function()
		onTemplateClick(newTemplate.ImageButton)
	end)
	
	-- Choose Upgrade Fruit
	newTemplate.UpgradeButton.Select.MouseButton1Click:Connect(function()
		chooseUpgradeFruit(newTemplate)
	end)	
	newTemplate.UpgradeButton.MouseButton1Click:Connect(function()
		chooseUpgradeFruit(newTemplate)
	end)

	-- Choose Sell Fruit
	newTemplate.SelectButton.Select.MouseButton1Click:Connect(function()
		chooseSellFruit(newTemplate)
	end)

	newTemplate.SelectButton.MouseButton1Click:Connect(function()
		chooseSellFruit(newTemplate)
	end)
end

local function changeOrbColor(color)
	--local treeLeaves = workspace:WaitForChild("MainFolder_Workspace"):WaitForChild("Fruits"):WaitForChild("GachaTree"):WaitForChild("TreeLeaves")
	--local tree = workspace:WaitForChild("MainFolder_Workspace"):WaitForChild("Fruits"):WaitForChild("GachaTree"):WaitForChild("MainBody")

	local originalColor = orb.Color
	orbParticleEmitter.Color = ColorSequence.new(color)
	orbParticleEmitter:Emit(100)

	tweenService:Create(orb, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Color = color}):Play()
	--[[orb.Attachment.ParticleEmitter.Enabled = true

	for _, leaf in pairs(treeLeaves:GetDescendants()) do
		if leaf:IsA("Part") or leaf:IsA("MeshPart") then
			local originalColor = leaf.Color

			if leaf.Color ~= color then
				leaf.Color = color

				local particleEmitter = Instance.new("ParticleEmitter")
				particleEmitter.Texture = "rbxassetid://18345190928" 
				particleEmitter.Rate = 10
				particleEmitter.Speed = NumberRange.new(10, 15)
				particleEmitter.Lifetime = NumberRange.new(1, 2)
				particleEmitter.SpreadAngle = Vector2.new(360, 360)
				particleEmitter.Size = NumberSequence.new(1)
				particleEmitter.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(0.5, 0.2),
					NumberSequenceKeypoint.new(1, 1)
				})
				particleEmitter.Parent = leaf

				particleEmitter:Emit(100)

				task.delay(3, function()
					particleEmitter:Destroy()
				end)
			end

			local highlight = Instance.new("Highlight")
			highlight.Adornee = leaf
			highlight.FillColor = color
			highlight.FillTransparency = 0.5
			highlight.OutlineTransparency = 1
			highlight.Parent = leaf

			local tweenInfo = TweenInfo.new(3)
			local tween = tweenService:Create(highlight, tweenInfo, {FillTransparency = 1})
			tween:Play()
			tween.Completed:Connect(function()
				highlight:Destroy()
			end)
		end
	end]]--
end

local function fetchFruit(fruitName, chosenPet)
	local fruitSystemSS = player.PlayerGui.FruitSystem
	local fruitViewport = fruitSystemSS.FruitViewport 
	
	for _, v in pairs(player.PlayerGui:GetChildren()) do
		if v:IsA("ScreenGui") and v ~= fruitSystemSS then
			v.Enabled = false
		end
	end
	
	fruitSystemSS.Enabled = true
	for _, v in pairs(fruitViewport:GetChildren()) do
		if v:IsA("Camera") or v:IsA("BasePart") or v:IsA("Model") then
			v:Destroy()
		end
	end

	fruitViewport.Size = UDim2.fromScale(0,0)
	
	local camera = Instance.new("Camera")
	camera.Parent = fruitViewport
	camera.CFrame = CFrame.new(0,0,4)
	fruitViewport.CurrentCamera = camera
	--tweenService:Create(fruitViewport, TweenInfo.new(0.7), {Size = UDim2.new(0.291, 0,0.408, 0)}):Play()
	--task.wait(0.7)

	tweenService:Create(fruitViewport, TweenInfo.new(0.3, Enum.EasingStyle.Sine,Enum.EasingDirection.Out), {Rotation = 0}):Play()
	task.wait(0.3)
	tweenService:Create(fruitViewport, TweenInfo.new(0.7), {Size = UDim2.fromScale(0,0)}):Play()
	task.wait(0.3)
	
	for _, v in pairs(fruitViewport:GetChildren()) do
		if v:IsA("ScreenGui") and v ~= fruitSystemSS then
			v:Destroy()
		end
	end
	
	local petModel = pets:FindFirstChild(chosenPet.Name):Clone()
	petModel:PivotTo(CFrame.new(0,0,0))
	petModel.Parent = fruitViewport
	local cameraPet = Instance.new("Camera")
	cameraPet.Parent = fruitViewport
	cameraPet.CFrame = CFrame.new(0,0,-3.3) * CFrame.Angles(0,math.rad(180),0)
	fruitViewport.CurrentCamera = cameraPet
	fruitViewport.NameLabel.Text = chosenPet.Name
	fruitViewport.NameLabel.Visible = true
	fruitViewport.RarityLabel.Text = chosenPet.Rarity
	fruitViewport.RarityLabel.Visible = true

	if fruitViewport.RarityLabel.Text == "Common" then
		changeOrbColor(Color3.new(1, 1, 1)) -- White
		--print(1)
	elseif fruitViewport.RarityLabel.Text == "Uncommon" then
		changeOrbColor(Color3.new(0, 1, 0)) -- Green
	elseif fruitViewport.RarityLabel.Text == "Rare" then
		changeOrbColor(Color3.new(0.333333, 0.333333, 1)) -- Blue
	elseif fruitViewport.RarityLabel.Text == "Epic" then
		changeOrbColor(Color3.new(0.835294, 0, 0.835294))
		--print(3)-- Purple
	elseif fruitViewport.RarityLabel.Text == "Legendary" then
		changeOrbColor(Color3.new(1, 1, 0.0901961))
		--print(4)-- Yellow
	end
	task.wait(2)

	tweenService:Create(fruitViewport, TweenInfo.new(0.7), {Size = UDim2.new(0.291, 0,0.408, 0)}):Play()
	if fruitViewport.RarityLabel.Text == "Common" then
		fruitViewport.RarityLabel.TextColor3 = Color3.new(1, 1, 1) -- White
	elseif fruitViewport.RarityLabel.Text == "Uncommon" then
		fruitViewport.RarityLabel.TextColor3 = Color3.new(0, 1, 0) -- Green
	elseif fruitViewport.RarityLabel.Text == "Rare" then
		fruitViewport.RarityLabel.TextColor3 = Color3.new(0.333333, 0.333333, 1) -- Blue
	elseif fruitViewport.RarityLabel.Text == "Epic" then
		fruitViewport.RarityLabel.TextColor3 = Color3.new(0.92549, 0, 0.92549) -- Purple
	elseif fruitViewport.RarityLabel.Text == "Legendary" then
		fruitViewport.RarityLabel.TextColor3 = Color3.new(1, 0.921569, 0.0627451) -- Yellow
	end
	
	task.wait(1.5)
	--orbParticleEmitter.Enabled = false
	tweenService:Create(fruitViewport, TweenInfo.new(0.3), {Size = UDim2.fromScale(0,0)}):Play()
	task.wait(0.3)
	fruitViewport.NameLabel.Visible = false
	fruitViewport.RarityLabel.Visible = false
	
	changeOrbColor(Color3.new(1, 1, 1))
	task.wait(2)
	--orbParticleEmitter.Enabled=false

	-- Đổi
	createTemplate(chosenPet)
	for _, v in pairs(player:WaitForChild("PlayerGui"):GetChildren()) do
		if v:IsA("ScreenGui") and v ~= fruitSystemSS then
			v.Enabled = true
		end
	end
end

function findMaxRarity(currentMaxRarity, newRarity)
	local rarityTable = {
		['Common'] = 1,
		['Uncommon'] = 2,
		['Rare'] = 3,
		['Epic'] = 4, 
		['Legendary'] = 5
	}
	
	if currentMaxRarity == nil then
		currentMaxRarity = newRarity
	elseif rarityTable[currentMaxRarity] < rarityTable[newRarity] then
		currentMaxRarity = newRarity
	end
	
	return currentMaxRarity
end

function showFruits(tableOfFruits)
	local number = table.maxn(tableOfFruits)
	local fruitSystem = player.PlayerGui.FruitSystem
	local frame = fruitSystem.Frame
	local fruitViewportHolder = frame.Frame
	local maxRarity = nil
	
	for _, v in pairs(player.PlayerGui:GetChildren()) do
		if v:IsA("ScreenGui") then
			if v ~= fruitSystem then
				v.Enabled = false
			else
				v.Enabled = true
			end
		end
	end
	
	fruitSystem.Enabled = true
	for _, v in pairs(fruitViewportHolder.FruitViewport:GetChildren()) do
		if v:IsA("Camera") or v:IsA("BasePart") or v:IsA("Model") then
			v:Destroy()
		end
	end
		
	for _, fruit in pairs(tableOfFruits) do
		local petModel = pets:FindFirstChild(fruit.Name):Clone()
		local newfruitViewportHolder = fruitViewportHolder:Clone()
		newfruitViewportHolder.Parent = frame
		newfruitViewportHolder.Name = fruit.Name
		
		local newfruitViewport = newfruitViewportHolder.FruitViewport
		petModel:PivotTo(CFrame.new(0,0,0))
		petModel.Parent = newfruitViewport
		
		local cameraPet = Instance.new("Camera")
		cameraPet.Parent = newfruitViewport
		cameraPet.CFrame = CFrame.new(0,0,-3.3) * CFrame.Angles(0,math.rad(180),0)
		newfruitViewport.CurrentCamera = cameraPet
		newfruitViewport.NameLabel.Text = fruit.Name
		newfruitViewport.NameLabel.Visible = true
		newfruitViewport.RarityLabel.Text = fruit.Rarity
		newfruitViewport.RarityLabel.Visible = true
		newfruitViewportHolder.Visible = true
		
		--tweenService:Create(newfruitViewport, TweenInfo.new(0.4), {Size = UDim2.fromScale(1, 1)}):Play()
		newfruitViewport.Size = UDim2.fromScale(1, 1)
		if newfruitViewport.RarityLabel.Text == "Common" then
			newfruitViewport.RarityLabel.TextColor3 = Color3.new(1, 1, 1) -- White
		elseif newfruitViewport.RarityLabel.Text == "Uncommon" then
			newfruitViewport.RarityLabel.TextColor3 = Color3.new(0, 1, 0) -- Green
		elseif newfruitViewport.RarityLabel.Text == "Rare" then
			newfruitViewport.RarityLabel.TextColor3 = Color3.new(0.333333, 0.333333, 1) -- Blue
		elseif newfruitViewport.RarityLabel.Text == "Epic" then
			newfruitViewport.RarityLabel.TextColor3 = Color3.new(0.92549, 0, 0.92549) -- Purple
		elseif newfruitViewport.RarityLabel.Text == "Legendary" then
			newfruitViewport.RarityLabel.TextColor3 = Color3.new(1, 0.921569, 0.0627451) -- Yellow
		end
		
		maxRarity = findMaxRarity(maxRarity, fruit.Rarity)
		createTemplate(fruit)
	end
	
	if maxRarity == "Common" then
		changeOrbColor(Color3.new(1, 1, 1)) -- White
		--print(1)
	elseif maxRarity == "Uncommon" then
		changeOrbColor(Color3.new(0, 1, 0)) -- Green
	elseif maxRarity == "Rare" then
		changeOrbColor(Color3.new(0.333333, 0.333333, 1)) -- Blue
	elseif maxRarity == "Epic" then
		changeOrbColor(Color3.new(0.835294, 0, 0.835294))
		--print(3)-- Purple
	elseif maxRarity == "Legendary" then
		changeOrbColor(Color3.new(1, 1, 0.0901961))
		--print(4)-- Yellow
	end
	
	task.wait(2)
	frame.Visible = true
	if number == 1 then
		frame.UIGridLayout.CellSize = UDim2.fromScale(1, 1)
		tweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.291, 0.408)}):Play()
	elseif number == 10 then
		frame.UIGridLayout.CellSize = UDim2.fromScale(0.2, 0.5)
		tweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.9, 0.5)}):Play()
	end
	
	task.wait(1)
	if number == 1 then
		tweenService:Create(frame, TweenInfo.new(0.5), {Size = UDim2.fromScale(0,0)}):Play()
		task.wait(0.5)	
	elseif number == 10 then
		tweenService:Create(frame, TweenInfo.new(1), {Size = UDim2.fromScale(0,0)}):Play()
		task.wait(1)	
	end
	
	
	changeOrbColor(Color3.new(1, 1, 1))
	task.wait(2)
	orbParticleEmitter.Enabled=false
	
	frame.Visible = false

	for _, fruit in pairs(tableOfFruits) do
		frame:FindFirstChild(fruit.Name):Destroy()
	end
	
	for _, v in pairs(player.PlayerGui:GetChildren()) do
		if v:IsA("ScreenGui") then
			if v ~= fruitSystem and v.Name ~= 'ScreenGui' and v.Name ~= 'InstructionScreen' then
				v.Enabled = true
			else
				v.Enabled = false
			end		
		end
	end
end

remotes.FetchFruit.OnClientEvent:Connect(showFruits)
remotes.LoadPets.OnClientEvent:Connect(function()
	for _, fruit in pairs(player.Pets:GetChildren()) do
		createTemplate(fruit)
	end
	numberEquipped = 0
	game.Workspace.MainFolder_Workspace.PlayerPets:FindFirstChild(player.Name):ClearAllChildren()
end)
