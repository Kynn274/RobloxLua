local player = game.Players.LocalPlayer
local replicatedStorage = game.ReplicatedStorage
local tweenService = game.TweenService
local runService = game["Run Service"]
local SPS=script.Parent
local instructionScreen = player.PlayerGui:WaitForChild("InstructionScreen")
local frames = player.PlayerGui.Frames
local textButton = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui"):WaitForChild("TextButton")
local menu = player.PlayerGui:WaitForChild("Menu")
local gachatree=game.Workspace:WaitForChild("MainFolder_Workspace"):WaitForChild("Fruits"):WaitForChild("GachaTree"):WaitForChild("HumanoidRootPart")

local TasksData = require(replicatedStorage.JSON.TasksData)
local fruitInventory = frames.FruitInventory
local checkedIcon = 'rbxassetid://18636654710'
local t = true

local message1 = 'Greeting dear player and welcome to Fruit Simulator.'
local message2 = 'It is our pleasure that you have chosen to play our game.'
local message3 = 'We hope you will have a fun time playing and collecting in Fruit Simulator. We wish you the best of luck. \nFrom Zen Team Studio.'
local message4 = 'Would you like to start the turtorial'

instructionScreen.WelcomeMess.Yes.MouseEnter:Connect(function()
	tweenService:Create(instructionScreen.WelcomeMess.Yes, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.3, 0.15)}):Play()
end)
instructionScreen.WelcomeMess.Yes.MouseLeave:Connect(function()
	tweenService:Create(instructionScreen.WelcomeMess.Yes, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.4, 0.2)}):Play()
end)

instructionScreen.WelcomeMess.No.MouseEnter:Connect(function()
	tweenService:Create(instructionScreen.WelcomeMess.No, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.3, 0.15)}):Play()
end)
instructionScreen.WelcomeMess.No.MouseLeave:Connect(function()
	tweenService:Create(instructionScreen.WelcomeMess.No, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.4, 0.2)}):Play()
end)

instructionScreen.WelcomeMess.Next.MouseEnter:Connect(function()
	tweenService:Create(instructionScreen.WelcomeMess.Next, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.2, 0.2)}):Play()
end)
instructionScreen.WelcomeMess.Next.MouseLeave:Connect(function()
	tweenService:Create(instructionScreen.WelcomeMess.Next, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.3, 0.3)}):Play()
end)

instructionScreen.WelcomeMess.Next.MouseButton1Click:Connect(function()
	if instructionScreen.WelcomeMess.TextLabel.Text == message1 then
		instructionScreen.WelcomeMess.TextLabel.Text = message2
	elseif instructionScreen.WelcomeMess.TextLabel.Text == message2 then
		instructionScreen.WelcomeMess.TextLabel.Text = message3
	elseif instructionScreen.WelcomeMess.TextLabel.Text == message3 then
		instructionScreen.WelcomeMess.TextLabel.Text=message4
		instructionScreen.WelcomeMess.Yes.Visible=true
		instructionScreen.WelcomeMess.No.Visible=true
		instructionScreen.WelcomeMess.Next.Visible=false
	end
end)

instructionScreen.WelcomeMess.Yes.MouseButton1Click:Connect(function()
	tweenService:Create(instructionScreen.WelcomeMess, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Visible = false}):Play()
	Step0()
end)

instructionScreen.WelcomeMess.No.MouseButton1Click:Connect(function()
	tweenService:Create(instructionScreen.WelcomeMess, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Visible = false}):Play()
	startGame()
end)
function Step0()
	tweenService:Create(instructionScreen.Step0, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Visible = true}):Play()
	instructionScreen.Step0.TextLabel.Text ='First you need to equip a pet.Now then click on the Fruit Inventory'

	menu.FruitInventory.MouseButton1Click:Connect(function()
		tweenService:Create(instructionScreen.Step0, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Visible = false}):Play()
		Step1()
		
	end)
end
function Step1()
	tweenService:Create(instructionScreen.Step1, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Visible = true}):Play()
	instructionScreen.Step1.TextLabel.Text = 'Click on Apple to equip it.'

	local fruitInventory=player.PlayerGui:WaitForChild("Frames"):WaitForChild("FruitInventory")
		for _, fruit in pairs(fruitInventory.Frame.ScrollingFrame:GetChildren()) do
			if fruit:IsA('Frame') then
				fruit.ImageButton.MouseButton1Click:Connect(function()
					tweenService:Create(instructionScreen.Step1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Visible = false}):Play()
					tweenService:Create(fruitInventory, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Visible = false}):Play()
					Step2()
				end)
			end
		end
end

function startGame()
	print('start')
	task.wait(1)
	for _, screenGui in pairs(player.PlayerGui:GetChildren()) do
		if screenGui:IsA('ScreenGui') then
			screenGui.Enabled = true	
		end
	end
	
	instructionScreen.Enabled = false
end

function Step5()
	tweenService:Create(instructionScreen.Step5, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Visible = true}):Play()
	instructionScreen.Step5.TextLabel.Text = 'Get a fruit'
	local button = frames.GachaScreen.Frame:WaitForChild("1Time")
	button.MouseButton1Click:Connect(function()
		tweenService:Create(instructionScreen.Step5, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Visible = false}):Play()
		startGame()
		SPS.PlayerInstruction.Enabled=false
	end)

end
function follow(arrow)
	t = true
	local gachaarea=game.Workspace:WaitForChild("MainFolder_Workspace"):WaitForChild("GachaArea"):WaitForChild("GachaArea")
	while t do
		arrow.Position=Vector3.new(game.Workspace:WaitForChild(player.Name):WaitForChild("HumanoidRootPart").CFrame.Position.X-3,348,game.Workspace:WaitForChild(player.Name):WaitForChild("HumanoidRootPart").CFrame.Position.Z-0.5)
		local pos=Vector3.new(gachaarea.Position.X,arrow.Position.Y,gachaarea.Position.Z)
		arrow.CFrame=CFrame.lookAt(arrow.Position,pos)
		arrow.Orientation=Vector3.new(arrow.Orientation.X,arrow.Orientation.Y,90)
		task.wait(0.01)
	end
	if t == false then
		arrow.Transparency=1
	end
end

function Step4()
	tweenService:Create(instructionScreen.Step4, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Visible = true}):Play()

	instructionScreen.Step4.TextLabel.Text = 'Go into Gacha Area'
	
	local arrow=workspace.ArrowGuide
	arrow.Transparency=0
	coroutine.wrap(follow)(arrow)
	local gachaarea=game.Workspace:WaitForChild("MainFolder_Workspace"):WaitForChild("GachaArea"):WaitForChild("GachaArea")

	gachaarea.Touched:Connect(function()
		t = false
		tweenService:Create(instructionScreen.Step4, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Visible = false}):Play()
		Step5()
	end)


end

function Step3()
	
	tweenService:Create(instructionScreen.Step4, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Visible = true}):Play()
	instructionScreen.Step4.TextLabel.Text='Great job! Now collect 150 coins'
		
	while player do
		if player.leaderstats.Coins.Value >= 150 then
			tweenService:Create(instructionScreen.Step4, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Visible = false}):Play()
			Step4()
			break
		end
		task.wait(0.5)
	end
end

function light(arrow)
	while t do
		task.wait(0.5)
		arrow.Transparency=0.75
		task.wait(0.5)
		arrow.Transparency=0
	end
	if t == false then
		arrow.Transparency = 1
	end
end
function disappear(arrow)
	arrow.Transparency = 1
end
function Step2()
	local arrow = game.Workspace.MainFolder_Workspace.StarterGuide
	arrow.Transparency = 0
	coroutine.wrap(light)(arrow)
	
	tweenService:Create(instructionScreen.Step2, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Visible = true}):Play()

	instructionScreen.Step2.TextLabel.Text='Click on the navigated chest'
	local testDrop = game.Workspace.MainFolder_Workspace.Drops.StarterArea:WaitForChild('Test drop')
	
	testDrop.ClickDetector.MouseClick:Connect(function()
		t = false
	
		tweenService:Create(instructionScreen.Step2, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Visible = false}):Play()
		Step3()

	end)

end

function WelcomeMessage()
	tweenService:Create(instructionScreen.WelcomeMess, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Visible = true}):Play()
	instructionScreen.WelcomeMess.TextLabel.Text = message1
end

function Instruction()
	print('cmm')
	for _, screenGui in pairs(player.PlayerGui:GetChildren()) do
		if screenGui:IsA('ScreenGui') then
			screenGui.Enabled = false	
		end
	end
	menu.Enabled = true
	instructionScreen.Enabled = true
	frames.Enabled = true
	player.PlayerGui.Currency.Enabled = true
	WelcomeMessage()
end

game.ReplicatedStorage.Remotes.Newplayer.OnClientEvent:Connect(Instruction)

