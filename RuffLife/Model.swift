//
//  Model.swift
//  RuffLife
//
//  Created by Alexandre Cassagne on 21/10/2017.
//  Copyright © 2017 Cassagne. All rights reserved.
//

import UIKit
import AWSDynamoDB

class Model: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
	// User
	var FirstName: String?
	var LastName: String?
	var PhoneNumber: String?

	// Dog
	var Color: String?
	var Breed: String?
	
	var ImageURL: String?
	
	// Location
	var lat: Double?
	var lon: Double?
	
	var PetID: Int?
	
	class func dynamoDBTableName() -> String {
		return "RuffLife"
	}
	
	class func hashKeyAttribute() -> String {
		return "PetID"
	}
	
}
