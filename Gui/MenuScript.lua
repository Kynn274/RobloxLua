-- Service
local player = game.Players.LocalPlayer
local tweenService = game.TweenService
local runService = game["Run Service"]

-- UI
local menu = player.PlayerGui:WaitForChild('Menu')
local frames = player.PlayerGui:WaitForChild('Frames')

-- Module
local frameTrigger = require(player.PlayerGui:WaitForChild('FrameTrigger'))

-- Var
local open = 1

for _, button in pairs(menu:GetDescendants()) do
	if button:IsA('GuiButton') then		
		if button.Parent:IsA('Frame') and button.Name ~= 'Expand' then
			button.MouseButton1Click:Connect(function()
				frameTrigger.OpenFrame(button.Parent.Name)
				frames.OpenOnScreen.Value = button.Parent.Name
				frames.TextButton.Visible = true
				
				for _, frame in pairs(menu.Frame:GetDescendants()) do
					if frame:IsA('GuiButton') then
						frame.Interactable = false
					end
				end
				
			end)
			button.MouseEnter:Connect(function()
				tweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.9, 0.9)}):Play()
			end)
			
			button.MouseLeave:Connect(function()
				tweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.9, 0.9)}):Play()
			end)
		else
			button.MouseButton1Click:Connect(function()
				if button.Name ~= 'Expand' then
					frameTrigger.OpenFrame(button.Name)
					frames.OpenOnScreen.Value = button.Name
					frames.TextButton.Visible = true
					
					for _, frame in pairs(menu.Frame:GetDescendants()) do
						if frame:IsA('GuiButton') then
							frame.Interactable = false
						end
					end
				end
			end)
			if button.Name == 'FruitInventory' then
				button.MouseEnter:Connect(function()
					tweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.26, 0.26)}):Play()
				end)
				
				button.MouseLeave:Connect(function()
					tweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.25, 0.25)}):Play()
				end)
			elseif button.Name == 'Teleport' then
				button.MouseEnter:Connect(function()
					tweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.16, 0.16)}):Play()
				end)

				button.MouseLeave:Connect(function()
					tweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.15, 0.15)}):Play()
				end)
			end
		end
		
	end
end

menu.Frame.Expand.MouseEnter:Connect(function()
	tweenService:Create(menu.Frame.Expand, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.6, 0.6)}):Play()
end)

menu.Frame.Expand.MouseLeave:Connect(function()
	tweenService:Create(menu.Frame.Expand, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.5, 0.5)}):Play()
end)

menu.Frame.Expand.MouseButton1Click:Connect(function()
	if open == 1 then
		tweenService:Create(menu.Frame.Expand, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 180}):Play()
		
		tweenService:Create(menu.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.15, 0.15)}):Play()
		tweenService:Create(menu.Frame.SlideFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0, 1)}):Play()
		open = 0
	else
		tweenService:Create(menu.Frame.Expand, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}):Play()

		tweenService:Create(menu.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(1.05, 0.15)}):Play()
		tweenService:Create(menu.Frame.SlideFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(1, 1)}):Play()
		open = 1
	end
end)

