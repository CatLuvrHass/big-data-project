#!/bin/bash


mongo 127.0.0.1/people --eval 'db.id.aggregate(     

	[         
		{
		$group:             
			{             
			_id: "$Name",             
			Height: { $min: "$Height" }
			}         
		},
	
		{"$sort": { "Height": 1 } 
	
		},

		{"$limit":1}  

	] 

)'

