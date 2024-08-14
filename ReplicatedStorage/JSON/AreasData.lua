local AreasData = {
	['StarterArea'] = {	
		Name = 'StarterArea',
		Price = 0,
		Location = 1,
		NextArea = 'Desert',
		PreArea = '',
		Door = '',
		Image = 'rbxassetid://18928590631'
	},
	
	['Desert'] = {
		Name = 'Desert',
		Price = 1000,
		Location = 2,
		NextArea = 'SnowField',
		PreArea = 'StarterArea',
		Door = 'StarterArea',
		Image = 'rbxassetid://18928603592'
	},
		
	['SnowField'] = {	
		Name = 'SnowField',
		Price = 10000,
		Location = 3,
		NextArea = 'IceLand',
		PreArea = 'Desert',
		Door = 'Desert',
		Image = 'rbxassetid://18928609812'
	},
	
	['IceLand'] = {
		Name = 'IceLand',
		Price = 50000, 
		Location = 4,
		NextArea = '',
		PreArea = 'SnowField',
		Door = 'SnowField',
		Image = 'rbxassetid://18928613872'
	}	
}

return AreasData


