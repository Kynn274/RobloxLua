local StartGui = game:GetService("StarterGui") --Variable for the StarterGui

repeat --Self Explanitory
	local disabled = pcall(function() --Creates a Pcall (Protected Call) to catch errors in case the reset button hasn't loaded
		StartGui:SetCore("ResetButtonCallback", false) --Disables the reset button
	end)
	task.wait(1) --wait 1 second until another attempt to disabled the reset button
until disabled