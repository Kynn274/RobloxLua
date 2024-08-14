local store = script.Parent
local storeData = require(game.ReplicatedStorage.JSON.StoreData)
local player = game.Players.LocalPlayer

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
	
	for _, item in pairs(Product) do
		--print(item)
		local newProduct = Store.Item:Clone()
		newProduct.ImageLabel.Image = item.Image
		newProduct.name.Text = item.Name
		newProduct.Name = item.Name
		newProduct.Price.Text = '['..tostring(item.Price)..' '..item.Currency..']'
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
		
	end
	
	Store.Item.Visible = false
	Store.Item.Interactable = false
end

updateProducts('Boost')
updateProducts('Gold')
updateProducts('Diamond')
