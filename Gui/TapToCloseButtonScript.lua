local button = script.Parent
local frameTrigger = require(button.Parent.Parent.FrameTrigger)

button.MouseButton1Click:Connect(function()
	frameTrigger.CloseAllFrame()
	button.Visible = false
end)