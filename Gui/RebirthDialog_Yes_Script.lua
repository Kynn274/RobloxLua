local yes=script.Parent
local price=10
yes.MouseButton1Click:Connect(function(player)
	local player = game.Players.LocalPlayer
	local plr=game.Players:WaitForChild(player.Name)
	if plr.leaderstats.Coins.Value >= (price+price*plr.leaderstats.Rebirth.Value) then
		
		game.ReplicatedStorage.Remotes.Rebirth:FireServer()
		
		yes.Parent.TextLabel.Text = "Alright then here we go."
		local death = game.Workspace:WaitForChild(plr.Name)

	elseif plr.leaderstats.Coins.Value < 10 then
		yes.Parent.TextLabel.Text="Sorry but it seems that you are a little poor." 
	end

end)
