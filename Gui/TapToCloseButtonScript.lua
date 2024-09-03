-- Service
local player = game.Players.LocalPlayer
local runService = game["Run Service"]

-- UI
local button = script.Parent
local frames = player.PlayerGui:WaitForChild('Frames')
local menu = player.PlayerGui:WaitForChild('Menu')
-- Module
local frameTrigger = require(button.Parent.Parent.FrameTrigger)

-- Var
local item

while task.wait(0.5) do 
	item = frames:FindFirstChild(frames.OpenOnScreen.Value)
	if item then
		item.Frame.MouseLeave:Once(function()
			button.Interactable = true
			button.MouseButton1Click:Connect(function()
				frameTrigger.CloseAllFrame()

				frames.OpenOnScreen.Value = ''
				button.Visible = false
				
				for _, fr in pairs(menu.Frame:GetDescendants()) do
					if fr:IsA('GuiButton') then
						fr.Interactable = true
					end
				end
			end)
		end)
		
		item.Frame.MouseEnter:Once(function()
			button.Interactable = false
		end)
	end
end


