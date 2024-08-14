local tasks = {
	MainTasks = {
		NewPlayer = {
			Task = {
				{
					description = 'Open the FruitsInventory.',
					status = 0
				},
				{
					description = 'Choose 1 fruit.',
					status = 0
				},
				{
					description = 'Move to the required location.',
					status = 0
				},
				{
					description = 'Dig up the chest to receive more gold and diamonds.',
					status = 0
				},
				{
					description = 'Receive 200 gold from the chest.',
					status = 0
				},
				{
					description = 'Move to the gacha tree.',
					status = 0
				},
				{
					description = 'Get a new fruit.',
					status = 0
				},
			},
			Gifts = {
				Gold = 200,
				Diamond = 5, 
				Pet = {
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
	}
}

return tasks
