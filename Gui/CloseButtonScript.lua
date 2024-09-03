local player = game.Players.LocalPlayer
local tweenService = game.TweenService

-- UI
local frameTrigger = require(player:WaitForChild('PlayerGui').FrameTrigger)
local frames = player:WaitForChild('PlayerGui').Frames
local menu = player:WaitForChild('PlayerGui').Menu

for _, frame in pairs(frames:GetChildren()) do
	if frame:IsA("Frame") then
		if frame.Frame:FindFirstChild('CloseButton') then
			frame.Frame.CloseButton.MouseEnter:Connect(function()
				tweenService:Create(frame.Frame.CloseButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.16, 0.16)}):Play()
			end)
			
			frame.Frame.CloseButton.MouseLeave:Connect(function()
				tweenService:Create(frame.Frame.CloseButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.15, 0.15)}):Play()
			end)
			
			frame.Frame.CloseButton.MouseButton1Click:Connect(function()
				frameTrigger.CloseFrame(frame.Name)
				frames.OpenOnScreen.Value = ''
				frames.TextButton.Visible = false
				
				for _, fr in pairs(menu.Frame:GetDescendants()) do
					if fr:IsA('GuiButton') then
						fr.Interactable = true
					end
				end
			end)
		end
	end
end

