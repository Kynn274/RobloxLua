local module = {}
--Services
local tweenService = game:GetService("TweenService")

local frames = script.Parent:WaitForChild("Frames")
local Camera = game.Workspace:WaitForChild("Camera")
local Lighting = game:WaitForChild("Lighting")
local Blur = Lighting.Blur

local frameOpenSpeed = 0.6 --Seconds
local frameCloseSpeed = 0.1 --Seconds
local TweenTime = 0.2

local frameOpenEasingStyle = Enum.EasingStyle.Back
local frameOpenEasingDirection = Enum.EasingDirection.Out

local frameClosingEasingStyle = Enum.EasingStyle.Sine
local frameClosingEasingDirection = Enum.EasingDirection.Out

function module.CloseFrame(frameName)
	local frame = frames:FindFirstChild(frameName)
	if frame then
		tweenService:Create(Camera,TweenInfo.new(TweenTime), {FieldOfView = 70}):Play()
		tweenService:Create(Blur, TweenInfo.new(TweenTime),{Size = 0}):Play()
		local closeTween = tweenService:Create(frame, 
			TweenInfo.new(frameCloseSpeed, frameClosingEasingStyle, frameClosingEasingDirection),
			{Size = UDim2.fromScale(0,0)}
		)
		closeTween:Play()
		closeTween.Completed:Connect(function()
			frame.Visible = false
		end)
	end
end

function module.CloseAllFrame()
	for _, frame in pairs(frames:GetChildren()) do
		if frame:IsA("Frame") then
			coroutine.wrap(module.CloseFrame)(frame.Name)
		end
	end
end

function module.OpenFrame(frameName)
	module.CloseAllFrame()

	local frame = frames:FindFirstChild(frameName)
	if frame then
		tweenService:Create(Camera,TweenInfo.new(TweenTime), {FieldOfView = 60}):Play()
		tweenService:Create(Blur, TweenInfo.new(TweenTime),{Size = 25}):Play()
		frame.Size = UDim2.fromScale(0,0)
		task.wait(frameCloseSpeed + 0.1)
		frame.Visible = true

		local openTween = tweenService:Create(frame, 
			TweenInfo.new(frameOpenSpeed, frameOpenEasingStyle, frameOpenEasingDirection),
			{Size = UDim2.fromScale(2,2)}
		)

		openTween:Play()
	end
end

return module