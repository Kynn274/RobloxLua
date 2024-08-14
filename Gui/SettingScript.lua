local GeneralTab = script.Parent.Frame.GeneralTab.ScrollingFrame
local DayNightTab = GeneralTab.DayNightTab
local GachaTree = workspace:WaitForChild("MainFolder_Workspace"):WaitForChild("Fruits"):WaitForChild("GachaTree")
local TreeLeaves = GachaTree:WaitForChild("TreeLeaves")
local SideBody = GachaTree:WaitForChild("SideBody")
local SideBodyColor = SideBody.Color

-- Day/Night Tab

function DayNight()
	if DayNightTab.Cover.Parent.StatusValue.Value == 1 then -- Day Mood
		DayNightTab.Cover.Button.AnchorPoint = Vector2.new(0,0.5)
		DayNightTab.Cover.Button.Position = UDim2.fromScale(0,0.5)
		DayNightTab.Cover.BackgroundColor3 = Color3.fromRGB(136, 136, 136)
		DayNightTab.Cover.BackgroundTransparency = 0.2
		DayNightTab.Cover.Parent.StatusValue.Value = 0
		for _, leaf in pairs(TreeLeaves:GetDescendants()) do
			if leaf:IsA("Part") or leaf:IsA("MeshPart") then
				local pointLight = Instance.new("PointLight")
				pointLight.Color=leaf.Color
				pointLight.Brightness = 40
				pointLight.Range=60
				pointLight.Enabled=true
				pointLight.Parent=leaf
				leaf.Material = Enum.Material.Neon
				SideBody.Color = Color3.fromRGB(255,255,255)
				SideBody.Material = Enum.Material.ForceField
			end
		end
		game.Lighting.ClockTime = 18.25
	else
		DayNightTab.Cover.Button.AnchorPoint = Vector2.new(1,0.5)
		DayNightTab.Cover.Button.Position = UDim2.fromScale(1,0.5)
		DayNightTab.Cover.BackgroundColor3 = Color3.fromRGB(26, 255, 0)
		DayNightTab.Cover.BackgroundTransparency = 0
		DayNightTab.Cover.Parent.StatusValue.Value = 1
		for _, leaf in pairs(TreeLeaves:GetDescendants()) do
			if leaf:IsA("Part") or leaf:IsA("MeshPart") then
				local pointLight = Instance.new("PointLight")
				pointLight.Enabled=false
				leaf.Material = Enum.Material.SmoothPlastic
				SideBody.Color = SideBodyColor
				SideBody.Material = Enum.Material.Wood
			end
		end
		game.Lighting.ClockTime = 10
	end
end

DayNightTab.Cover.MouseButton1Click:Connect(DayNight)
DayNightTab.Cover.Button.MouseButton1Click:Connect(DayNight)