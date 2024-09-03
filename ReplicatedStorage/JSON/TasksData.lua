local tasks = {
	MainTasks = {
		Name = 'MainTasks',
		['New Player Task'] = {
			Task = {
				{
					description = 'Click on Menu.',
					status = 0
				},
				{
					description = 'Open the FruitsInventory.',
					status = 0
				},
				{
					description = 'Choose 1 fruit.',
					status = 0
				},
				{
					description = 'Click on the navigated chest',
					status = 0
				},

				{
					description = 'Receive 150 gold from the chest.',
					status = 0
				},
				{
					description = 'Interact with the gacha tree.',
					status = 0
				},
				{
					description = 'Get a  fruit.',
					status = 0
				},
			},
			Gifts = {
				Coins = 200,
				Diamonds = 5, 
				Pets = {
					{
						PetName = 'Banana',
						Number = 1
					}
				}
			},
			Image = '',
			Status = 0,
			Name = 'New Player Task',
			Received = 0
		}
	},
	
	DailyTasks = {
		Name = 'DailyTasks',
		['Online 10 minutes'] = {
			Name = 'Online 10 minutes',
			Task = 'Online 10 minutes.',
			Time = 600,
			STT = 1,
			Status = 0,
			Received = 0,
			Gifts = {
				Coins = {
					Value = 100,
					Model = 'UncommonChest',
					Image = 'rbxassetid://127725706226509',
				},
				Diamonds = {
					Value = 0,
					Model = 'EpicChest',
					Image = 'rbxassetid://122704075649076',
				},
				Pets = {}
			}			
		},
		['Online 30 minutes'] = {
			Name = 'Online 30 minutes',
			Task = 'Online 30 minutes.',
			Time = 1800,
			STT = 2,
			Status = 0,
			Received = 0,
			Gifts = {
				Coins = {
					Value = 200,
					Model = 'UncommonChest',
					Image = 'rbxassetid://127725706226509',
				},
				Diamonds = {
					Value = 0,
					Model = 'EpicChest',
					Image = 'rbxassetid://122704075649076',
				},
				Pets = {}
			}			
		},
		['Online 1 hour'] = {
			Name = 'Online 1 hour',
			Task = 'Online 1 hour.',
			Time = 3600,
			STT = 3,
			Status = 0,
			Received = 0,
			Gifts = {
				Coins = {
					Value = 300,
					Model = 'UncommonChest',
					Image = 'rbxassetid://127725706226509',
				},
				Diamonds = {
					Value = 10,
					Model = 'EpicChest',
					Image = 'rbxassetid://122704075649076',
				},
				Pets = {}
			}			
		},
		['Online 2 hours'] = {
			Name = 'Online 2 hours',
			Task = 'Online 2 hours.',
			Time = 7200,
			STT = 4,
			Status = 0,
			Received = 0,
			Gifts = {
				Coins = {
					Value = 500,
					Model = 'UncommonChest',
					Image = 'rbxassetid://127725706226509',
				},
				Diamonds = {
					Value = 15,
					Model = 'EpicChest',
					Image = 'rbxassetid://122704075649076',
				},
				Pets = {}
			}			
		},
		['Online 3 hours'] = {
			Name = 'Online 3 hours',
			Task = 'Online 3 hours.',
			Time = 10800,
			STT = 5,
			Status = 0,
			Received = 0,
			Gifts = {
				Coins = {
					Value = 500,
					Model = 'UncommonChest',
					Image = 'rbxassetid://127725706226509',
				},
				Diamonds = {
					Value = 20,
					Model = 'EpicChest',
					Image = 'rbxassetid://122704075649076',
				},
				Pets = {}
			}			
		},
		['Online 6 hours'] = {
			Name = 'Online 6 hours',
			Task = 'Online 6 hours.',
			Time = 21600,
			STT = 6,
			Status = 0,
			Received = 0,
			Gifts = {
				Coins = {
					Value = 1000,
					Model = 'UncommonChest',
					Image = 'rbxassetid://127725706226509',
				},
				Diamonds = {
					Value = 50,
					Model = 'EpicChest',
					Image = 'rbxassetid://122704075649076',
				},
				Pets = {}
			}			
		},
		['Online 12 hours'] = {
			Name = 'Online 12 hours',
			Task = 'Online 12 hours.',
			Time = 43200,
			STT = 7,
			Status = 0,
			Received = 0,
			Gifts = {
				Coins = {
					Value = 2000,
					Model = 'UncommonChest',
					Image = 'rbxassetid://127725706226509',
				},
				Diamonds = {
					Value = 100,
					Model = 'EpicChest',
					Image = 'rbxassetid://122704075649076',
				},
				Pets = {}
			}			
		},
	}
}

return tasks
