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
--Đổi
local module3D = require(replicatedStorage:WaitForChild("Module3D"))

local numberEquipped = 0
local limitNum = 4

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
			clickedTemplate.Select.Visible = false
			clickedTemplate.Chose.Value = 0
		
			-- Gửi lệnh equipPet
			remotes.EquipPet:FireServer(clickedTemplate.Parent.Name)
				
			-- Tạo trong petsDisplay
			local newPetDisplay = petsHolder.Pet:Clone()
			newPetDisplay.Name = clickedTemplate.Parent.Name
			newPetDisplay.Image = clickedTemplate.Image
			newPetDisplay.Parent = petsHolder
			newPetDisplay.Visible = true
		
			numberEquipped += 1
			
			if numberEquipped > 0 then
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
	
	newTemplate.ImageButton.MouseButton1Click:Connect(function()
		onTemplateClick(newTemplate.ImageButton)
	end)
	
end

local function changeOrbColor(color)
	--local treeLeaves = workspace:WaitForChild("MainFolder_Workspace"):WaitForChild("Fruits"):WaitForChild("GachaTree"):WaitForChild("TreeLeaves")
	--local tree = workspace:WaitForChild("MainFolder_Workspace"):WaitForChild("Fruits"):WaitForChild("GachaTree"):WaitForChild("MainBody")

	local originalColor = orb.Color
	orbParticleEmitter.Color = ColorSequence.new(color)
	orbParticleEmitter:Emit(100)

	tweenService:Create(orb, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Color = color}):Play()
	--orb.Attachment.ParticleEmitter.Enabled = true

	--for _, leaf in pairs(treeLeaves:GetDescendants()) do
	--	if leaf:IsA("Part") or leaf:IsA("MeshPart") then
	--		local originalColor = leaf.Color

	--		if leaf.Color ~= color then
	--			leaf.Color = color

	--			local particleEmitter = Instance.new("ParticleEmitter")
	--			particleEmitter.Texture = "rbxassetid://18345190928" 
	--			particleEmitter.Rate = 10
	--			particleEmitter.Speed = NumberRange.new(10, 15)
	--			particleEmitter.Lifetime = NumberRange.new(1, 2)
	--			particleEmitter.SpreadAngle = Vector2.new(360, 360)
	--			particleEmitter.Size = NumberSequence.new(1)
	--			particleEmitter.Transparency = NumberSequence.new({
	--				NumberSequenceKeypoint.new(0, 0),
	--				NumberSequenceKeypoint.new(0.5, 0.2),
	--				NumberSequenceKeypoint.new(1, 1)
	--			})
	--			particleEmitter.Parent = leaf

	--			particleEmitter:Emit(100)

	--			task.delay(3, function()
	--				particleEmitter:Destroy()
	--			end)
	--		end

	--		local highlight = Instance.new("Highlight")
	--		highlight.Adornee = leaf
	--		highlight.FillColor = color
	--		highlight.FillTransparency = 0.5
	--		highlight.OutlineTransparency = 1
	--		highlight.Parent = leaf

	--		local tweenInfo = TweenInfo.new(3)
	--		local tween = tweenService:Create(highlight, tweenInfo, {FillTransparency = 1})
	--		tween:Play()
	--		tween.Completed:Connect(function()
	--			highlight:Destroy()
	--		end)
	--	end
	--end
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
		if v:IsA("ScreenGui") and v ~= fruitSystem then
			v.Enabled = false
		end
	end
	
	fruitSystem.Enabled = true
	for _, v in pairs(fruitViewportHolder.FruitViewport:GetChildren()) do
		if v:IsA("Camera") or v:IsA("BasePart") or v:IsA("Model") then
			v:Destroy()
		end
	end
	
	frame.Visible = true
	if number == 1 then
		tweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.291, 0.408)}):Play()
		frame.UIGridLayout.CellSize = UDim2.fromScale(1, 1)
	elseif number == 10 then
		tweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.9, 0.5)}):Play()
		frame.UIGridLayout.CellSize = UDim2.fromScale(0.2, 0.5)
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
	if number == 1 then
		tweenService:Create(frame, TweenInfo.new(0.3), {Size = UDim2.fromScale(0,0)}):Play()
		task.wait(0.3)	
	elseif number == 10 then
		tweenService:Create(frame, TweenInfo.new(0.7), {Size = UDim2.fromScale(0,0)}):Play()
		task.wait(0.7)	
	end
	
	
	changeOrbColor(Color3.new(1, 1, 1))
	task.wait(2)
	orbParticleEmitter.Enabled=false
	
	frame.Visible = false

	for _, fruit in pairs(tableOfFruits) do
		frame:FindFirstChild(fruit.Name):Destroy()
	end
	
	for _, v in pairs(player.PlayerGui:GetChildren()) do
		if v:IsA("ScreenGui") and v ~= fruitSystem and v.Name ~= 'ScreenGui' then
			v.Enabled = true
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

--remotes:WaitForChild('EquipRebirthPet').OnClientEvent:Connect(EquipRebirth)


--task.wait(5)
--for _, v in pairs(player.Pets:GetChildren()) do
--	coroutine.wrap(createTemplate)(v.Name)
--	print(v)
--end