-- Service
local player = game.Players.LocalPlayer
local tweenService = game.TweenService

-- UI
local frames = player.PlayerGui:WaitForChild('Frames')
local purchaseDoor = player.PlayerGui:WaitForChild('PurchaseDoor')

for _, bt in pairs(purchaseDoor.Frame:GetChildren()) do
	if bt:IsA('TextButton') then
		bt.MouseEnter:Connect(function()
			tweenService:Create(bt, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.35, 0.15), Rotation = 3}):Play()
		end)
		bt.MouseLeave:Connect(function()
			tweenService:Create(bt, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.4, 0.2), Rotation = 0}):Play()
		end)
	end
end