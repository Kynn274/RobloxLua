local store = script.Parent
local storeData = require(game.ReplicatedStorage.JSON.StoreData)
local player = game.Players.LocalPlayer
local MPS = game:GetService("MarketplaceService")
local Module3D = require(game.ReplicatedStorage:WaitForChild("Module3D"))

for _, frame in pairs(store.Frame.Selection:GetChildren()) do
	if frame:IsA('Frame') then
		frame.TextButton.MouseButton1Click:connect(function()
			for _, frame in pairs(store.Frame.Selection:GetChildren()) do
				if frame:IsA('Frame') then
					
					frame.TextButton.BackgroundColor3 = Color3.fromRGB(26, 38, 37)
					frame.TextButton.TextColor3 = Color3.fromRGB(254, 254, 254)
					--frame.TextButton.UIStroke.Color = Color3.fromRGB(255, 255, 255)
				end
			end
			for _, frame in pairs(store.Frame:GetChildren()) do
				if frame:IsA('ScrollingFrame') then
					frame.Visible = false
				end
			end
			
			frame.TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			frame.TextButton.TextColor3 = Color3.fromRGB(60, 88, 87)
		--	frame.TextButton.UIStroke.Color = Color3.fromRGB(81, 39, 3)
			frame.Parent.Parent:FindFirstChild(frame.Name..'Products').Visible = true
		end)
	end
end

--for _, frame in pairs(store.Frame:GetChildren()) do
--	if frame:IsA('Frame') then
--		frame.TextButton.MouseButton1Click:connect(function()
--			for _, frame in pairs(store.Frame:GetChildren()) do
--				if frame:IsA('Frame') then
--					frame.BackgroundColor3 = Color3.fromRGB(81, 39, 3)
--					frame.TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
--				end
--				if frame:IsA('ScrollingFrame') then
--					frame.Visible = false
--				end
--			end
--			frame.BackgroundColor3 = Color3.fromRGB(211, 201, 93)
--			frame.TextButton.TextColor3 = Color3.fromRGB(81, 39, 3)
--			frame.Parent:WaitForChild(frame.Name..'Products').Visible = true
--		end)
--	end
--end
local check = false

function updateProducts(name)
	local Product = storeData[name]
	local Store = store.Frame:WaitForChild(name..'Products')
	local number = table.maxn(Product)
	
	
	for i = 1, number do
		local item = Product[i]
		--print(item)
		local newProduct = Store.Item:Clone()
		
		if item.Image ~= '' then
			newProduct.ImageLabel.Image = item.Image
		elseif item.Model ~= '' then
			local productModel = game.ReplicatedStorage.Chest:FindFirstChild(item.Model):Clone()
			local Model3D = Module3D:Attach3D(newProduct.ViewPort.ProductDisplayFrame, productModel)
			Model3D:SetDepthMultiplier(1.2)
			Model3D.Camera.FieldOfView = 5
			Model3D.Visible = true

			game:GetService("RunService").RenderStepped:Connect(function()
				Model3D:SetCFrame(CFrame.Angles(0,tick() % (math.pi * 2),0) * CFrame.Angles(math.rad(-10),0,0))
			end)
		end
		
		newProduct.name.Text = item.Name
		newProduct.Name = item.Name
		--newProduct.Price.Text = '['..tostring(item.Price)..' '..item.Currency..']'
		newProduct.Buy.Text = tostring(item.Price)..' '..item.Currency
		newProduct.Parent = Store
		
		newProduct.MouseEnter:Connect(function()
			check = newProduct.Name
			Store.Parent.Note.Visible = true
			Store.Parent.Note.AnchorPoint = Vector2.new(0.5, 0.5)
			Store.Parent.Note.Position = UDim2.new(0.5, 0, 0.7, 0)
			Store.Parent.Note.TextXAlignment = Enum.TextXAlignment.Left
			Store.Parent.Note.UISizeConstraint.MaxSize = Vector2.new(500, 'inf')
			Store.Parent.Note.TextWrapped = true
			Store.Parent.Note.TextColor3 = Color3.fromRGB(255,255,255)
			Store.Parent.Note.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Store.Parent.Note.BackgroundTransparency = 0.2
			Store.Parent.Note.Text = 'Name: '..newProduct.name.Text..'\n\nDescription: '..item.Description..'\n\nPrice: '..tostring(item.Price)..' '..item.Currency
		end)
		
		newProduct.MouseLeave:Connect(function()
			if check == newProduct.Name then
				Store.Parent.Note.Visible = false
			end
		end)	
		
		newProduct.Buy.MouseButton1Click:Connect(function()
			buyProduct(name, i)
		end)
		
	end
	
	Store.Item.Visible = false
	Store.Item.Interactable = false
end

function buyProduct(kind, indexNum)
	local productDetail = storeData[kind][indexNum]
	if productDetail.Id ~= '' then
		MPS:PromptProductPurchase(player,productDetail.Id)
		local PlayerId=player.UserId
		local GamepassId=productDetail.Id
		local success, errormessage = pcall(function()
			MPS.PromptProductPurchaseFinished:Connect(function(PlayerId, GamepassId, IsPurchased)
				if IsPurchased == true then
					game.ReplicatedStorage.Remotes.ProductsProcessing:FireServer(kind, indexNum)
					--player.leaderstats.Diamonds.Value += productDetail.Value
				end
			end)
		end)

		if not success then
			print("uh oh it failed...error:", errormessage)
		end	
	else
		if productDetail.Currency == 'Diamonds' then
			if player.leaderstats.Diamonds.Value >= productDetail.Price then
				game.ReplicatedStorage.Remotes.ProductsProcessing:FireServer(kind, indexNum)
			end
		elseif productDetail.Currency == 'Coins' then
			if player.leaderstats.Coins.Value >= productDetail.Price then
				game.ReplicatedStorage.Remotes.ProductsProcessing:FireServer(kind, indexNum)
			end
		end		
	end
end


updateProducts('Boost')
updateProducts('Gold')
updateProducts('Diamond')
updateProducts('Fruits')