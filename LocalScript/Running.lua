local player = game.Players.LocalPlayer

local userInputService = game:GetService("UserInputService")

local speed = 40

userInputService.InputBegan:Connect(function(key)
	if key.KeyCode == Enum.KeyCode.LeftShift then
		player.Character.Humanoid.WalkSpeed = speed
	end
end)

userInputService.InputEnded:Connect(function(key)
	if key.KeyCode == Enum.KeyCode.LeftShift then
		player.Character.Humanoid.WalkSpeed = 16
	end
end)