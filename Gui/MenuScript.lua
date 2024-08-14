local player = game.Players.LocalPlayer

local tweenService = game.TweenService
local runService = game["Run Service"]

local menu = player.PlayerGui:WaitForChild('Menu')
local frames = player.PlayerGui:WaitForChild('Frames')
local frameTrigger = require(player.PlayerGui:WaitForChild('FrameTrigger'))

local open = false

menu.MenuButton.MouseEnter:Connect(function()
	tweenService:Create(menu.MenuButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.15, 0.15)}):Play()
end)
menu.MenuButton.MouseLeave:Connect(function()
	tweenService:Create(menu.MenuButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.2, 0.2)}):Play()
end)

menu.Teleport.MouseEnter:Connect(function()
	tweenService:Create(menu.Teleport, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.075, 0.075)}):Play()
end)
menu.Teleport.MouseLeave:Connect(function()
	tweenService:Create(menu.Teleport, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.1, 0.1)}):Play()
end)


runService.RenderStepped:Connect(function()
	menu.MenuButton.UIStroke.UIGradient.Rotation += 2
end)

runService.RenderStepped:Connect(function()
	menu.Teleport.UIStroke.UIGradient.Rotation += 2
end)

menu.MenuButton.MouseButton1Click:Connect(function()
	if open == false then
		menu.Frame.Visible = true
		for _, bt in pairs(menu.Frame:GetChildren()) do
			tweenService:Create(bt, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.3, 0.3)}):Play()
			task.wait(0.15)
			
			bt.MouseEnter:Connect(function()
				tweenService:Create(bt, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.2, 0.2)}):Play()
				bt.Note.Size = UDim2.new(1.5,0,0.5,0)
				bt.Note.Text = bt.Name
				bt.Note.Visible = true
				bt.Note.TextScaled = true
			end)
			
			bt.MouseLeave:Connect(function()
				tweenService:Create(bt, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.3, 0.3)}):Play()
				bt.Note.Visible = false
			end)
			
			bt.MouseButton1Click:Connect(function()
				frameTrigger.CloseAllFrame()
				frameTrigger.OpenFrame(bt.Name)
				player.PlayerGui.Frames.TextButton.Visible = true
			end)
		end
		menu.Frame.Visible = true
		open = true
	else
		for _, bt in pairs(menu.Frame:GetChildren()) do
			tweenService:Create(bt, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0, 0)}):Play()
			task.wait(0.15)
		end
		menu.Frame.Visible = false
		open = false
	end
end)

menu.Teleport.MouseButton1Click:Connect(function()
	frames.Teleport.Visible = true
	frames.TextButton.Visible = true
	tweenService:Create(menu.Teleport, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.1, 0.1)}):Play()
	tweenService:Create(frames.Teleport, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(2, 2)}):Play()
end)