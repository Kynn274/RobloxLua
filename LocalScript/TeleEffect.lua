--local Players = game:GetService("Players")
--local ReplicatedStorage = game:GetService("ReplicatedStorage")
--local TweenService = game:GetService("TweenService")
--local Workspace = game:GetService("Workspace")

--local Remotes = ReplicatedStorage:WaitForChild("Remotes")
--local VFX1 = Workspace:WaitForChild("VFX1")
--local ClickDetector = VFX1.ClickDetector
--local BlackHole = ReplicatedStorage:FindFirstChild("BlackHole")
--local DarkMistAtt = BlackHole.DarkMist

--local tweenInfo1 = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
--local tweenInfo2 = TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)


--Remotes.Teleport.OnClientEvent:Connect(function(player)
--	local IntotheSmoke = Players.LocalPlayer.PlayerGui:WaitForChild("IntotheSmoke")
--	local TPFrame = IntotheSmoke:FindFirstChild("TPFrame")
--	local lf1 = TPFrame:FindFirstChild("LeftFrame1")
--	local Oldlf1Position = lf1.Position
--	--print("lf1Pos when first take :" ..tostring(Oldlf1Position))
--	local lf2 = TPFrame:FindFirstChild("LeftFrame2")
--	local Oldlf2Position = lf2.Position
--	local rf1 = TPFrame:FindFirstChild("RightFrame1")
--	local Oldrf1Position = rf1.Position
--	local rf2 = TPFrame:FindFirstChild("RightFrame2")
--	local Oldrf2Position = rf2.Position
--	local WholeScreen = TPFrame:FindFirstChild("WholeScreen")
--	local DarkMistAttClone = DarkMistAtt:Clone()
--	local playerName = script.Parent.Parent.Name
--	local playerInWorkspace = Workspace:WaitForChild(playerName)
--	playerInWorkspace.HumanoidRootPart.Anchored = true
--	DarkMistAttClone.Parent = playerInWorkspace.UpperTorso
--	DarkMistAttClone.ParticleEmitter:Emit(10)
	
--	local tweenlf2 = TweenService:Create(lf2,tweenInfo2,{Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
--	local tweenrf2 = TweenService:Create(rf2,tweenInfo2,{Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
--	wait(0.25)
--	local tweenlf1 = TweenService:Create(lf1,tweenInfo1,{Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
--	local tweenrf1 = TweenService:Create(rf1,tweenInfo1,{Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
--	wait(0.25)
--	local tweenWholeScreen = TweenService:Create(WholeScreen,tweenInfo2,{BackgroundTransparency = 0}):Play()
--	wait(0.8)
	
--	local tweenlf1 = TweenService:Create(lf1,tweenInfo1,{Position = UDim2.new(-0.5, 0, 0.5, 0)}):Play()
--	local tweenrf1 = TweenService:Create(rf1,tweenInfo1,{Position = UDim2.new(1.5, 0, 0.5, 0)}):Play()
--	wait(0.25)
--	local tweenlf1 = TweenService:Create(lf2,tweenInfo1,{Position = UDim2.new(-0.5, 0, 0.5, 0)}):Play()
--	local tweenrf1 = TweenService:Create(rf2,tweenInfo1,{Position = UDim2.new(1.5, 0, 0.5, 0)}):Play()
--	wait(0.25)
--	wait(1.2)
--	playerInWorkspace.HumanoidRootPart.Anchored = false
--	local tweenWholeScreen = TweenService:Create(WholeScreen,tweenInfo2,{BackgroundTransparency = 1}):Play()
--end)
