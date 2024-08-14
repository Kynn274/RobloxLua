local frameTrigger = require(script.Parent.Parent.FrameTrigger)
local Frames = script.Parent

for _, frame in pairs(Frames:GetChildren()) do
	if frame:IsA("Frame") then
		if frame.Frame:FindFirstChild('CloseButton') then
			frame.Frame.CloseButton.MouseButton1Click:Connect(function()
				frameTrigger.CloseFrame(frame.Name)
				Frames.TextButton.Visible = false
			end)
		end
	end
end