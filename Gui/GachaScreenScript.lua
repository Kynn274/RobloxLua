local player = game.Players.LocalPlayer
local tweenService = game:GetService("TweenService")

-- Module
local fruitData = require(game.Workspace.MainFolder_Workspace.Fruits.GachaTree.Data)
local price = fruitData.fruitPrice
local currency = fruitData.fruitCurrency

-- Gui
local purchaseDoor = player.PlayerGui:WaitForChild('PurchaseDoor')
local frames = player.PlayerGui:WaitForChild('Frames')

-- 10Times Button
player.PlayerGui.Frames.GachaScreen.Frame['10Times'].MouseEnter:Connect(function()
	player.PlayerGui.Frames.GachaScreen.Frame['10Times']:TweenSize(UDim2.new(0.093, 0,0.068, 0),"Out","Quart",.5,true) -- di pencet
	for i = 0,-5,-5 do
		wait()
		player.PlayerGui.Frames.GachaScreen.Frame['10Times'].Rotation = i
	end
end)

player.PlayerGui.Frames.GachaScreen.Frame['10Times'].MouseLeave:Connect(function()
	player.PlayerGui.Frames.GachaScreen.Frame['10Times']:TweenSize(UDim2.new(0.3, 0,0.15, 0),"Out","Quart",.5,true)
	for i = -5,0,5 do
		wait()
		player.PlayerGui.Frames.GachaScreen.Frame['10Times'].Rotation = i
	end
end)

player.PlayerGui.Frames.GachaScreen.Frame['10Times'].MouseButton1Click:Connect(function()
	player.PlayerGui.Frames.GachaScreen.Frame.MainFrame:TweenPosition(UDim2.new(0.5, 0,0.5, 0), "Out", "Elastic", 1)
	player.PlayerGui.Frames.GachaScreen.Frame['10Times']:TweenSize(UDim2.new(0.3, 0,0.15, 0),"Out","Quart",.5,true)
	for i = -5,0,5 do
		wait()
		player.PlayerGui.Frames.GachaScreen.Frame['10Times'].Rotation = i
	end
	
	if player.leaderstats.Coins.Value >= price * 10 then
		tweenService:Create(player.PlayerGui.Frames.GachaScreen, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Visible = false}):Play()
		game.ReplicatedStorage.Remotes.Gachax10:FireServer()
		task.wait(3.5)
		tweenService:Create(player.PlayerGui.Frames.GachaScreen, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Visible = true}):Play()
	else
		purchaseDoor.Frame.Visible = true
		tweenService:Create(purchaseDoor.Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.fromScale(0.5, 0.5)}):Play()
		
		purchaseDoor.Frame.TextLabel.Text = 'Sorry but it seems that you are a little poor'
		purchaseDoor.Frame.Buy.Visible = false
		purchaseDoor.Frame.Nah.Visible = false

		task.wait(2)
		tweenService:Create(purchaseDoor.Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.fromScale(0.5, 1.5)}):Play()
		task.wait(0.2)

		purchaseDoor.Frame.Visible = false
		purchaseDoor.Frame.Buy.Visible = true
		purchaseDoor.Frame.Nah.Visible = true
	end
end)

-- 1Time Button
player.PlayerGui.Frames.GachaScreen.Frame['1Time'].MouseEnter:Connect(function()
	player.PlayerGui.Frames.GachaScreen.Frame['1Time']:TweenSize(UDim2.new(0.093, 0,0.068, 0),"Out","Quart",.5,true) -- di pencet
	for i = 0,-5,-5 do
		wait()
		player.PlayerGui.Frames.GachaScreen.Frame['1Time'].Rotation = i
	end
end)

player.PlayerGui.Frames.GachaScreen.Frame['1Time'].MouseLeave:Connect(function()
	player.PlayerGui.Frames.GachaScreen.Frame['1Time']:TweenSize(UDim2.new(0.3, 0,0.15, 0),"Out","Quart",.5,true)
	for i = -5,0,5 do
		wait()
		player.PlayerGui.Frames.GachaScreen.Frame['1Time'].Rotation = i
	end
end)

player.PlayerGui.Frames.GachaScreen.Frame['1Time'].MouseButton1Click:Connect(function()
	player.PlayerGui.Frames.GachaScreen.Frame.MainFrame:TweenPosition(UDim2.new(0.5, 0,0.5, 0), "Out", "Elastic", 1)
	player.PlayerGui.Frames.GachaScreen.Frame['1Time']:TweenSize(UDim2.new(0.3, 0,0.15, 0),"Out","Quart",.5,true)
	for i = -5,0,5 do
		wait()
		player.PlayerGui.Frames.GachaScreen.Frame['1Time'].Rotation = i
	end
	
	if player.leaderstats.Coins.Value >= price then
		tweenService:Create(player.PlayerGui.Frames.GachaScreen, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Visible = false}):Play()
		game.ReplicatedStorage.Remotes.Gachax1:FireServer() 
		task.wait(3.5)
		tweenService:Create(player.PlayerGui.Frames.GachaScreen, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Visible = true}):Play()
	else
		purchaseDoor.Frame.Visible = true
		tweenService:Create(purchaseDoor.Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.fromScale(0.5, 0.5)}):Play()

		purchaseDoor.Frame.TextLabel.Text = 'Sorry but it seems that you are a little poor'
		purchaseDoor.Frame.Buy.Visible = false
		purchaseDoor.Frame.Nah.Visible = false

		task.wait(2)
		tweenService:Create(purchaseDoor.Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.fromScale(0.5, 1.5)}):Play()
		task.wait(0.2)

		purchaseDoor.Frame.Visible = false
		purchaseDoor.Frame.Buy.Visible = true
		purchaseDoor.Frame.Nah.Visible = true
	end
end)

-- Exit Button
player.PlayerGui.Frames.GachaScreen.Frame.Exit.MouseEnter:Connect(function()
	player.PlayerGui.Frames.GachaScreen.Frame.Exit:TweenSize(UDim2.new(0.112, 0,0.112, 0),"Out","Quad",.1,true)
end)

player.PlayerGui.Frames.GachaScreen.Frame.Exit.MouseLeave:Connect(function()
	player.PlayerGui.Frames.GachaScreen.Frame.Exit:TweenSize(UDim2.new(0.127, 0,0.127, 0),"Out","Quad",.1,true)
end)

player.PlayerGui.Frames.GachaScreen.Frame.Exit.MouseButton1Click:Connect(function()
	player.PlayerGui.Frames.GachaScreen.Frame:TweenPosition(UDim2.new(0.5, 0,1.5, 0), "Out", "Elastic", 1)
	player.PlayerGui.Frames.GachaScreen.Visible = false
end)


game.ReplicatedStorage.Remotes.GachaWindowOpen.OnClientEvent:Connect(function()
	local GachaScreen = player.PlayerGui.Frames.GachaScreen
	local MainFrame = GachaScreen.Frame
	
	GachaScreen.Visible = true
	GachaScreen.Size = UDim2.fromScale(2, 2)
	
	local tweenInfo = TweenInfo.new(
		1,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out,
		0,
		false,
		0 
	)
	
	local tween = tweenService:Create(MainFrame,tweenInfo,{Position = UDim2.fromScale(0.5,0.45)}):Play()
end) 

game.ReplicatedStorage.Remotes.CreateDropRateBoard.OnClientEvent:Connect(function()
	local PlayerGui = player.PlayerGui
	local GachaScreen = PlayerGui.Frames.GachaScreen
	local Pets = game.ReplicatedStorage:WaitForChild("Pets")
	local Module3D = require(game.ReplicatedStorage:WaitForChild("Module3D"))
	local FruitData = require(game.Workspace.MainFolder_Workspace.Fruits.GachaTree.Data)
	
	for _, pet in ipairs(Pets:GetChildren()) do
		local newFrame = GachaScreen.Frame.ScrollingFrame.Frame:Clone()
		newFrame.Parent = GachaScreen.Frame.ScrollingFrame
		newFrame.Name = pet.Name
		newFrame.PetDisplayFrame.UIStroke.UIGradient.Rotation = -45
		newFrame.PetDisplayFrame.UIStroke.Thickness = 5
		--print(1)

		local Pet = player.PetLibrary:FindFirstChild(pet.Name)
		if Pet.rarity.Value == "Common" then
			newFrame.PetDisplayFrame.UIStroke.UIGradient.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1))
			newFrame.PetDisplayFrame.DropRateFrame.DropRateText.Text = tostring(string.format("%.2f",FruitData.fruitPets.Common[1].chance)) .. "%" 
		elseif Pet.rarity.Value == "Uncommon" then
			newFrame.PetDisplayFrame.UIStroke.UIGradient.Color = ColorSequence.new(Color3.new(0.0196078, 1, 0.0196078), Color3.new(1, 1, 1))
			newFrame.PetDisplayFrame.DropRateFrame.DropRateText.Text = tostring(string.format("%.2f",FruitData.fruitPets.Uncommon[1].chance)) .. "%" 
		elseif Pet.rarity.Value == "Rare" then
			newFrame.PetDisplayFrame.UIStroke.UIGradient.Color = ColorSequence.new(Color3.new(0, 0.133333, 1), Color3.new(1, 1, 1))
			newFrame.PetDisplayFrame.DropRateFrame.DropRateText.Text = tostring(string.format("%.2f",FruitData.fruitPets.Rare[1].chance)) .. "%" 
		elseif Pet.rarity.Value == "Epic" then
			newFrame.PetDisplayFrame.UIStroke.UIGradient.Color = ColorSequence.new(Color3.new(0.74902, 0, 1), Color3.new(1, 1, 1))
			newFrame.PetDisplayFrame.DropRateFrame.DropRateText.Text = tostring(string.format("%.2f",FruitData.fruitPets.Epic[1].chance)) .. "%" 
		elseif Pet.rarity.Value == "Legendary" then
			newFrame.PetDisplayFrame.UIStroke.UIGradient.Color = ColorSequence.new(Color3.new(1, 0.968627, 0), Color3.new(1, 1, 1))
			newFrame.PetDisplayFrame.DropRateFrame.DropRateText.Text = tostring(string.format("%.2f",FruitData.fruitPets.Legendary[1].chance)) .. "%" 
		end

		local newpet = pet:Clone()
		local Model3D = Module3D:Attach3D(newFrame.PetDisplayFrame,newpet)
		Model3D:SetDepthMultiplier(1.2)
		Model3D.Camera.FieldOfView = 5
		Model3D.Visible = true

		game:GetService("RunService").RenderStepped:Connect(function()
			Model3D:SetCFrame(CFrame.Angles(0,tick() % (math.pi * 2),0) * CFrame.Angles(math.rad(-10),0,0))
		end)
	end

	player.PlayerGui.Frames.GachaScreen.Frame.ScrollingFrame.Frame.Visible = false
end)