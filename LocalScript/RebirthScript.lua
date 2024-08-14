local eButton = game.Workspace.NPC:WaitForChild('ProximityPart').ProximityPrompt
local player = game.Players.LocalPlayer
local playerGUI = player:WaitForChild('PlayerGui')
local Frame = playerGUI:WaitForChild('RebirthDialog').Frame
local textLabel = Frame.TextLabel

local sen1 = 'Greetings, fancy seeing you here. It has been a while since i last had a visitor.'
local sen2 = 'So tell me, dear guest, is there anything I provide that pique your interest?'
local RebirthSen = 'It will cost you 100k coins to rebirth. Do you agree with that price?'
--local YesSen = 'Alright then. Here we go'
local NoSen = 'Okay then, until next time.'

eButton.Triggered:Connect(function()
	Frame.Visible = true
	Frame.Rebirth.Visible = false
	Frame.No.Visible = false
	Frame.Yes.Visible = false
	textLabel.Text = sen1
	Frame.Next.Visible = true
end)

Frame.Next.MouseButton1Click:Connect(function()
	textLabel.Text = sen2
	Frame.Next.Visible = false
	Frame.Rebirth.Visible = true
	Frame.No.Visible = true
end)

Frame.Rebirth.MouseButton1Click:Connect(function()
	textLabel.Text = RebirthSen
	Frame.Yes.Visible = true
	Frame.Rebirth.Visible = false
end)

Frame.Yes.MouseButton1Click:Connect(function()
	Frame.Rebirth.Visible = false
	Frame.No.Visible = false
	Frame.Yes.Visible = false
	--textLabel.Text = YesSen
	task.wait(1)
	Frame.Visible = false
end)

Frame.No.MouseButton1Click:Connect(function()
	Frame.Rebirth.Text = 'Rebirth'
	Frame.Rebirth.Visible = false
	Frame.No.Visible = false
	Frame.Yes.Visible = false
	textLabel.Text = NoSen
	task.wait(1)
	Frame.Visible = false
end)