local module = {}
--Services
local tweenService = game:GetService("TweenService")

local frames = script.Parent:WaitForChild("Frames")

local frameOpenSpeed = 0.8 --Seconds
local frameCloseSpeed = 0.2 --Seconds

local frameOpenEasingStyle = Enum.EasingStyle.Back
local frameOpenEasingDirection = Enum.EasingDirection.Out

local frameClosingEasingStyle = Enum.EasingStyle.Sine
local frameClosingEasingDirection = Enum.EasingDirection.Out

function module.CloseFrame(frameName)
	local frame = frames:FindFirstChild(frameName)
	if frame then
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
		frame.Size = UDim2.fromScale(0,0)
		task.wait(frameCloseSpeed + 0.1)
		frame.Visible = true
		
		local openTween = tweenService:Create(frame, 
			TweenInfo.new(frameOpenSpeed, frameOpenEasingStyle, frameOpenEasingDirection),
			{Size = UDim2.fromScale(1,1)}
		)
		
		openTween:Play()
	end
end

return module