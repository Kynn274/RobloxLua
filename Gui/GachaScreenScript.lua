local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local fruitData = require(game.Workspace.MainFolder_Workspace.Fruits.GachaTree.Data)
local price = fruitData.fruitPrice
local currency = fruitData.fruitCurrency

-- 10Times Button
player.PlayerGui.Frames.GachaScreen.Frame['10Times'].MouseEnter:Connect(function()
	player.PlayerGui.Frames.GachaScreen.Frame['10Times']:TweenSize(UDim2.new(0.093, 0,0.068, 0),"Out","Quart",.5,true) -- di pencet
	for i = 0,-5,-5 do
		wait()
		player.PlayerGui.Frames.GachaScreen.Frame['10Times'].Rotation = i
	end
end)

player.PlayerGui.Frames.GachaScreen.Frame['10Times'].MouseLeave:Connect(function()
	player.PlayerGui.Frames.GachaScreen.Frame['10Times']:TweenSize(UDim2.new(0.2, 0,0.1, 0),"Out","Quart",.5,true)
	for i = -5,0,5 do
		wait()
		player.PlayerGui.Frames.GachaScreen.Frame['10Times'].Rotation = i
	end
end)

player.PlayerGui.Frames.GachaScreen.Frame['10Times'].MouseButton1Click:Connect(function()
	player.PlayerGui.Frames.GachaScreen.Frame.MainFrame:TweenPosition(UDim2.new(0.5, 0,0.5, 0), "Out", "Elastic", 1)
	player.PlayerGui.Frames.GachaScreen.Frame:TweenPosition(UDim2.new(0.5, 0,1.5, 0), "Out", "Elastic", 1)
	if player.leaderstats.Coins.Value >= price * 10 then
		game.ReplicatedStorage.Remotes.Gachax10:FireServer()
	end
	player.PlayerGui.Frames.GachaScreen.Frame:TweenPosition(UDim2.new(0.5, 0, 0.45, 0), "Out", "Elastic", 1)
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
	player.PlayerGui.Frames.GachaScreen.Frame['1Time']:TweenSize(UDim2.new(0.2, 0,0.1, 0),"Out","Quart",.5,true)
	for i = -5,0,5 do
		wait()
		player.PlayerGui.Frames.GachaScreen.Frame['1Time'].Rotation = i
	end
end)

player.PlayerGui.Frames.GachaScreen.Frame['1Time'].MouseButton1Click:Connect(function()
	player.PlayerGui.Frames.GachaScreen.Frame.MainFrame:TweenPosition(UDim2.new(0.5, 0,0.5, 0), "Out", "Elastic", 1)
	player.PlayerGui.Frames.GachaScreen.Frame:TweenPosition(UDim2.new(0.5, 0,1.5, 0), "Out", "Elastic", 1)
	if player.leaderstats.Coins.Value >= price then
		game.ReplicatedStorage.Remotes.Gachax1:FireServer()
	end
	player.PlayerGui.Frames.GachaScreen.Frame:TweenPosition(UDim2.new(0.5, 0, 0.45, 0), "Out", "Elastic", 1)
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
	
	local tween = TweenService:Create(MainFrame,tweenInfo,{Position = UDim2.fromScale(0.5,0.45)}):Play()
end) 