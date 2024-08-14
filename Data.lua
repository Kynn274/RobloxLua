local commonDropRate = 40
local uncommonDropRate = 30
local rareDropRate = 20
local epicDropRate = 9
local legendaryDropRate = 1

local commonPet = 3
local uncommonPet = 1
local rarePet = 2
local epicPet = 3
local legendaryPet = 3

local commonChance = commonDropRate/commonPet
local uncommonChance = uncommonDropRate/uncommonPet
local rareChance = rareDropRate/rarePet
local epicChance = epicDropRate/epicPet
local legendaryChance = legendaryDropRate/legendaryPet

return {
	fruitPrice = 150,
	fruitCurrency = "Coins",
	commonDropRate = 40,
	uncommonDropRate = 30,
	rareDropRate = 20,
	epicDropRate = 9,
	legendaryDropRate = 1,
	--Common : 45%
	--Uncommon : 30%
	--Epic : 15%
	--Legendary : 10%
	
	fruitPets = {
		['Common'] = {
			[1] = {
				Name = "Apple",
				chance = commonChance,
				Rarity = "Common",
				Stt = 1, 
				Speed = 15
			},
			[2] = {
				Name = "Coconut",
				chance = commonChance,
				Rarity = "Common",
				Stt = 4,
				Speed = 10
			},
			[3] = {
				Name = "Pear",
				chance = commonChance,
				Rarity = "Common",
				Stt = 5,
				Speed = 12
			},
		},
		['Uncommon'] = {
			[1] = {
				Name = "Banana",
				chance = uncommonChance,
				Rarity = "Uncommon",
				Stt = 2,
				Speed = 20
			},
		},
		['Rare'] = {
			[1] = {
				Name = "Blueberry",
				chance = rareChance,
				Rarity = "Rare",
				Stt = 10,
				Speed = 30 
			},
			[2] = {
				Name = "Raspberry",
				chance = rareChance,
				Rarity = "Rare",
				Stt = 11,
				Speed = 30 
			},
			[3] = {
				Name = "Strawberry",
				chance = rareChance,
				Rarity = "Rare",
				Stt = 12,
				Speed = 30 
			},
		},
		['Epic'] = {
			[1] = {
				Name = "Grape",
				chance = epicChance,
				Rarity = "Epic",
				Stt = 6,
				Speed = 45
			},
			[2] = {
				Name = "Cactus",
				chance = epicChance,
				Rarity = "Epic",
				Stt = 7,
				Speed = 35
			},
			[3] = {
				Name = "Watermelon",
				chance = epicChance,
				Rarity = "Epic",
				Stt = 3,
				Speed = 40
			},
		},
		['Legendary'] = {
			[1] = {
				Name = "DragonFruit",
				chance = legendaryChance,
				Rarity = "Legendary",
				Stt = 8,
				Speed = 80
			},
			[2] = {
				Name = "PineCone",
				chance = legendaryChance,
				Rarity = "Legendary",
				Stt = 9,
				Speed = 70
			},
		}			
		
	}
}

-- Thêm số thứ tự