local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local Zone = require(ReplicatedStorage.Zone)

local Atmosphere = Lighting.Atmosphere
local AtmosphereZones = workspace.Environment.AtmosphereZones
local LightingZones = workspace.Environment.LightingZones


local defaultAtmosphere = {
	Density = Atmosphere.Density,
	Offset = Atmosphere.Offset,
	Color = Atmosphere.Color,
	Decay = Atmosphere.Decay,
	Glare = Atmosphere.Glare,
	Haze = Atmosphere.Haze
}

local defaultLighting = {
	Ambient = Lighting.Ambient,
	Brightness = Lighting.Brightness,
	ColorShift_Bottom = Lighting.ColorShift_Bottom,
	ColorShift_Top = Lighting.ColorShift_Top,
	EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
	EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
	GlobalShadows = Lighting.GlobalShadows,
	OutdoorAmbient = Lighting.OutdoorAmbient,
	ShadowSoftness = Lighting.ShadowSoftness
}

local function CreateZone(container)
	local customZone = Zone.new(container)
	customZone:bindToGroup("EnterOnlyOneAtATime")

	customZone.localPlayerEntered:Connect(function()
		local atmosphereTransition = TweenService:Create(Atmosphere, TweenInfo.new(1), container:GetAttributes())
		atmosphereTransition:Play()

		-- Check for corresponding LightingZone with the same name
		local lightingZone = LightingZones:FindFirstChild(container.Name)
		if lightingZone then
			local lightingAttributes = lightingZone:GetAttributes()
			local lightingTransition = TweenService:Create(Lighting, TweenInfo.new(1), lightingAttributes)
			lightingTransition:Play()
		end
	end)

	customZone.localPlayerExited:Connect(function()
		local atmosphereTransition = TweenService:Create(Atmosphere, TweenInfo.new(1), defaultAtmosphere)
		atmosphereTransition:Play()

		local lightingTransition = TweenService:Create(Lighting, TweenInfo.new(1), defaultLighting)
		lightingTransition:Play()
	end)

	local connection

	local function DestroyZone()
		customZone:unbindFromGroup("EnterOnlyOneAtATime")
		customZone:destroy()

		connection:Disconnect()
		connection = nil
	end

	connection = container.AncestryChanged:Connect(function()
		if container.Parent ~= AtmosphereZones then
			DestroyZone()
		end
	end)

	container.Destroying:Connect(DestroyZone)
end

for _, container in ipairs(AtmosphereZones:GetChildren()) do
	CreateZone(container)
end

AtmosphereZones.ChildAdded:Connect(CreateZone)