local player = game.Players.LocalPlayer
local library = player.PlayerGui.Frames.Library
local Character = library.Frame.Character
local CharacterDetails = library.Frame.CharacterDetails
local SearchFruit = library.Frame.SearchFruit

local Frame = Character:FindFirstChild('Frame')
local tweenService = game.TweenService

local fruitIcon = require(game.ReplicatedStorage.JSON.Icon).Fruit.FruitIcon
local tableOfRarity = require(game.Workspace.MainFolder_Workspace.Fruits.GachaTree.Data).fruitPets
local petLibrary = player.PetLibrary

local selected = nil
local selectingPet = 0

function createRarityHolder()
	local defaultOrder = {
		['Common'] = 1,
		['Uncommon'] = 2,
		['Rare'] = 3,
		['Epic'] = 4,
		['Legendary'] = 5
	}
	
	-- Sort
	local rarityList = {}
	for _, grpet in pairs(tableOfRarity) do
		table.insert(rarityList, defaultOrder[grpet[1].Rarity], grpet[1].Rarity)
	end
	
	for i = 1, #rarityList do
		if rarityList[i] == nil then
			table.remove(rarityList, i)
			i -= 1
		end
	end
	
	for i = 1, #rarityList do
		local newFruitRarity = Character.FruitRarity:Clone()
		newFruitRarity.Name = rarityList[i]
		newFruitRarity.Parent = Character
		newFruitRarity.Visible = true
		
		local newFruitHolder = Character.FruitHolder:Clone()
		newFruitHolder.Name = rarityList[i]..'Holder'
		newFruitHolder.Parent = Character
		newFruitHolder.Visible = true
		
		newFruitRarity.TextLabel.Text = newFruitRarity.Name
		
		if newFruitRarity.Name == 'Common' then
			newFruitRarity.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		elseif newFruitRarity.Name == 'Uncommon' then
			newFruitRarity.TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
		elseif newFruitRarity.Name == 'Rare' then
			newFruitRarity.TextLabel.TextColor3 = Color3.fromRGB(39, 25, 191)
		elseif newFruitRarity.Name == 'Epic' then
			newFruitRarity.TextLabel.TextColor3 = Color3.fromRGB(200, 0, 255)
		elseif newFruitRarity.Name == 'Legendary' then
			newFruitRarity.TextLabel.TextColor3 = Color3.fromRGB(255, 235, 16)
		end
		createLibrary(tableOfRarity[rarityList[i]], newFruitRarity.Name)
		
		
		newFruitRarity.ImageButton.MouseButton1Click:Connect(function()
			local number = #tableOfRarity[rarityList[i]]
			local row = math.ceil(number / 5)
			
			if newFruitHolder.OpenStatus.Value == 1 then
				tweenService:Create(newFruitHolder, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0, 0)}):Play()
				tweenService:Create(newFruitRarity.ImageButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 180}):Play()
				newFruitHolder.OpenStatus.Value = 0
				task.wait(0.2)
				newFruitHolder.Visible = false
			else
				newFruitHolder.Visible = true
				tweenService:Create(newFruitHolder, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(1, 0.4 * row)}):Play()
				tweenService:Create(newFruitRarity.ImageButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 90}):Play()
				newFruitHolder.OpenStatus.Value = 1
			end			
			
		end)
	end
end

function showDetails(frame)
	print(frame)
	print(selected)
	if selectingPet == 0 then
		frame.ImageButton.UIStroke.Thickness = 5
		frame.ImageButton.UIStroke.Color = Color3.fromRGB(255, 255, 0)
		frame.ImageButton.got.Value = 1
		selected = frame
		
		CharacterDetails.Visible = true
		tweenService:Create(Character, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.55, 0.8)}):Play()
		--tweenService:Create(SearchFruit, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.5, 0.08)}):Play()
		tweenService:Create(CharacterDetails, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.35, 0.8)}):Play()
		for _, grid in pairs(Character:GetDescendants()) do
			if grid:IsA('UIGridLayout') then
				grid.CellSize = UDim2.fromScale(0.25, 1)
			end
		end		
		
		local petInfo = petLibrary:FindFirstChild(frame.Name)
		CharacterDetails.ScrollingFrame.Avatar.Image = petInfo.avatar.Value
		CharacterDetails.ScrollingFrame.TextFrame.NameLabel.Text = 'Name: '..petInfo.Name
		CharacterDetails.ScrollingFrame.TextFrame.RarityLabel.Text = 'Rarity: '..petInfo.rarity.Value
		CharacterDetails.ScrollingFrame.TextFrame.SpeedLabel.Text = 'Speed: '..petInfo.damage.Value
		CharacterDetails.ScrollingFrame.TextFrame.NumberLabel.Text = 'Number: '..petInfo.number.Value
		CharacterDetails.ScrollingFrame.TextFrame.StatusLabel.Text = 'Status: Available'

		selectingPet = 1
	else
		if frame.Name == selected.Name then
			selectingPet = 0
			frame.ImageButton.UIStroke.Thickness = 3
			frame.ImageButton.UIStroke.Color = Color3.fromRGB(255, 255, 255)
			frame.ImageButton.got.Value = 0
			selected = nil
			
			tweenService:Create(Character, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.96, 0.8)}):Play()
			--tweenService:Create(SearchFruit, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.9, 0.08)}):Play()
			tweenService:Create(CharacterDetails, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0, 0.8)}):Play()
			task.wait(0.2)
			CharacterDetails.Visible = false
			for _, grid in pairs(Character:GetDescendants()) do
				if grid:IsA('UIGridLayout') then
					grid.CellSize = UDim2.fromScale(0.2, 1)
				end
			end
			
		else
			frame.ImageButton.UIStroke.Thickness = 5
			frame.ImageButton.UIStroke.Color = Color3.fromRGB(255, 255, 0)
			frame.ImageButton.got.Value = 1
			selected.ImageButton.UIStroke.Thickness = 3
			selected.ImageButton.UIStroke.Color = Color3.fromRGB(255, 255, 255)
			selected.ImageButton.got.Value = 0
			selected = frame
			
			local petInfo = petLibrary:FindFirstChild(frame.Name)
			CharacterDetails.ScrollingFrame.Avatar.Image = petInfo.avatar.Value
			CharacterDetails.ScrollingFrame.TextFrame.NameLabel.Text = 'Name: '..petInfo.Name
			CharacterDetails.ScrollingFrame.TextFrame.RarityLabel.Text = 'Rarity: '..petInfo.rarity.Value
			CharacterDetails.ScrollingFrame.TextFrame.SpeedLabel.Text = 'Speed: '..petInfo.damage.Value
			CharacterDetails.ScrollingFrame.TextFrame.NumberLabel.Text = 'Number: '..petInfo.number.Value
			CharacterDetails.ScrollingFrame.TextFrame.StatusLabel.Text = 'Status: Available'	
		end
	end
	
end

function createLibrary(groupPet, rarity)
	-- Fruits
	for _, pet in pairs(groupPet) do
		local petName = pet.Name
		local petHolder = Character:FindFirstChild(rarity..'Holder')
		local frame = petHolder.Frame
		
		local newPet = frame:Clone()
		newPet.Name = petName
		newPet.Parent = petHolder
		newPet.ImageButton.Image = fruitIcon[petName]
		newPet.ImageButton.HoverImage = fruitIcon[petName]
		newPet.ImageButton.TextLabel.Visible = false
		newPet.ImageButton.Interactable = false
		newPet.Visible = true
		
		local petInfo = petLibrary:FindFirstChild(petName)
		if petInfo.status.Value == 1 or petInfo.number.Value > 0 then
			newPet.ImageButton.unavailableImage.Visible = false
			newPet.ImageButton.TextLabel.Visible = true
			newPet.ImageButton.TextLabel.Text = petName
			newPet.ImageButton.Interactable = true
			
			newPet.ImageButton.MouseEnter:Connect(function()
				tweenService:Create(newPet.ImageButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.5, 0.5)}):Play()
			end)

			newPet.ImageButton.MouseLeave:Connect(function()
				tweenService:Create(newPet.ImageButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.6, 0.6)}):Play()
			end)

			newPet.ImageButton.MouseButton1Click:Connect(function()
				showDetails(newPet)
			end)
		end
	end
end

function updateLibrary()
	-- Fruits
	for _, pet in pairs(player.PetLibrary:GetChildren()) do
		--print(pet)
		if pet.status.Value == 1 or pet.number.Value > 0 then
			local rarityHolder = Character:FindFirstChild(pet.rarity.Value..'Holder')
			local frame = rarityHolder:FindFirstChild(pet.Name)
			
			if frame.ImageButton.unavailableImage.Visible == true then
				frame.ImageButton.unavailableImage.Visible = false
				frame.ImageButton.TextLabel.Visible = true
				frame.ImageButton.TextLabel.Text = pet.Name
				frame.ImageButton.Interactable = true
				
				frame.ImageButton.MouseEnter:Connect(function()
					tweenService:Create(frame.ImageButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.5, 0.5)}):Play()
				end)
				
				frame.ImageButton.MouseLeave:Connect(function()
					tweenService:Create(frame.ImageButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.6, 0.6)}):Play()
				end)
				
				frame.ImageButton.MouseButton1Click:Connect(function()
					showDetails(frame)
				end)
			end
		end
	end
end

function loadAgain()
	local Character = player.PlayerGui.Frames.Library.Frame.Character
	for _, pet in pairs(Character:GetDescendants()) do
		if pet:IsA('Frame') and player.PetLibrary:FindFirstChild(pet.Name) then
			pet.ImageButton.MouseButton1Click:Connect(function()
				showDetails(pet)
			end)
		end
	end
end

function searchFruit()
	local text = string.lower(SearchFruit.TextBox.Text)
	local item = nil	
	
	if text ~= '' then
		for _, fruit in pairs(Character:GetDescendants()) do
			if fruit:IsA('Frame') and string.lower(fruit.Name) == text then
				item = fruit
				break
			end
		end
		
		for _, frame in pairs(Character:GetChildren()) do
			if frame:IsA('Frame') then
				frame.Visible = false
			end
		end
		
		if item ~= nil then
			item.Parent.Visible = true
			local rarity = petLibrary:FindFirstChild(item.Name).rarity.Value
			
			Character:FindFirstChild(rarity).Visible = true
			
			for _, fruit in pairs(item.Parent:GetChildren()) do
				if fruit:IsA('Frame') then
					fruit.Visible = false
				end
			end
			
			item.Visible = true
		end
	
	else
		for _, frame in pairs(Character:GetDescendants()) do
			if frame:IsA('Frame') then
				if frame.Name ~= 'FruitHolder' and frame.Name ~= 'FruitRarity' and frame.Name ~= 'Frame' then
					frame.Visible = true
				end
			end
		end
	end
end


game.ReplicatedStorage.Remotes.PetLibrary.OnClientEvent:Connect(updateLibrary)
game.ReplicatedStorage.Remotes.CreateLibrary.OnClientEvent:Connect(createRarityHolder)
SearchFruit.ImageButton.MouseButton1Click:Connect(searchFruit)
SearchFruit.ImageButton.MouseEnter:Connect(function()
	tweenService:Create(SearchFruit.ImageButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.7, 0.7)}):Play()
end)
SearchFruit.ImageButton.MouseLeave:Connect(function()
	tweenService:Create(SearchFruit.ImageButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.8, 0.8)}):Play()
end)