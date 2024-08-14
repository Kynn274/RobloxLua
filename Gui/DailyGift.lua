-- Cơ chế 
-- Quà nhận liên tục mỗi ngày --> người chơi không đăng nhập 1 ngày quà reset lại từ đầu 
-- Quà nhận đến ngày 7 thì quay lại từ đầu
-- Số lượng tiền trong quà tặng ti lệ theo số rebirth


-- quà chưa được nhận màu vàng
-- quà được nhận màu xanh lá cây
-- quà đã nhận màu xám
-- cố định loại vật phẩm

local DailyGift = script.Parent
local Frame = DailyGift.Frame
local Icon = require(game.ReplicatedStorage.JSON.Icon)
-- Dữ liệu tạm thời
--local DailyGiftData = require(game.ReplicatedStorage.JSON.DailyGift)

game.ReplicatedStorage.Remotes.LoadDailyGift.OnClientEvent:Connect(function(DailyGift)
	for _, gift in pairs(DailyGift) do
		local bt = Frame:FindFirstChild(gift.Name)

		if bt then
			if gift.Status == 0 then
				bt.BackgroundColor3 = Color3.fromRGB(191, 174, 227)
				bt.Interactable = false
			elseif gift.Status == 1 and gift.Received == 0 then
				bt.BackgroundColor3 = Color3.fromRGB(26, 255, 0)
				bt.Interactable = true
			elseif gift.Status == 1 and gift.Received == 1 then
				bt.BackgroundColor3 = Color3.fromRGB(106, 106, 106)
				bt.Interactable = false
			end

			if gift.Gold > 0 then 
				bt.Gold.TextLabel.Text = tostring(gift.Gold)
				bt.Gold.Image = Icon['Gold']
			end

			if gift.Diamond > 0 then 
				bt.Diamond.TextLabel.Text = tostring(gift.Diamond)
				bt.Diamond.Image = Icon['Diamond']
			end

			if gift.Gacha > 0 then 
				bt.Gacha.TextLabel.Text = tostring(gift.Gacha)
				bt.Gacha.Image = Icon['Gacha']
			end
			
			bt.MouseButton1Click:Connect(function()
				if gift.Status == 1 and gift.Received == 0 then
					bt.BackgroundColor3 = Color3.fromRGB(106, 106, 106)
					bt.Interactable = false
					
					-- gọi remote để nhận quà
					game.ReplicatedStorage.Remotes.ClaimGift:FireServer(gift.Name)
				end
			end)
		end
	end
end)