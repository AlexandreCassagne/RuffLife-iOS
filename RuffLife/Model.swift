//
//  Model.swift
//  RuffLife
//
//  Created by Alexandre Cassagne on 21/10/2017.
//  Copyright © 2017 Cassagne. All rights reserved.
//

import UIKit
import AWSDynamoDB

class RuffLife: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
	// User
	@objc var FirstName: String?
	@objc var LastName: String?
	@objc var PhoneNumber: String?

	// Dog
	@objc var Color: String?
	@objc var Breed: String?
	
	@objc var ImageURL: String?
	
	// Location
	var lat: NSNumber?
	var lon: NSNumber?
	
	var PetID: NSNumber?
	
	class func dynamoDBTableName() -> String {
		return "RuffLife"
	}
	
	class func hashKeyAttribute() -> String {
		return "PetID"
	}
	
}
