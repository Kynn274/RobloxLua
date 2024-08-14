local player = game.Players.LocalPlayer
local tasksAndRewards = script.Parent
local frameTrigger = require(player.PlayerGui.FrameTrigger)
local Frames = player.PlayerGui.Frames

for _, bt in pairs(tasksAndRewards.Holder:GetChildren()) do
	if bt:IsA('GuiButton') then
		bt.MouseEnter:Connect(function()
			bt.Note.Size = UDim2.new(1.2,0,0.4,0)
			bt.Note.Text = bt.Name
			bt.Note.Visible = true
			bt.Note.TextScaled = true
		end)
		bt.MouseLeave:Connect(function()
			bt.Note.Visible = false
		end)
		bt.MouseButton1Click:Connect(function()
			frameTrigger.OpenFrame(bt.Name)
			Frames.TextButton.Visible = true
		end)
	end
end
