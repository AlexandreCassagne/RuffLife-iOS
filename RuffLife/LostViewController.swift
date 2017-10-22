//
//  LostViewController.swift
//  RuffLife
//
//  Created by Alexandre Cassagne on 21/10/2017.
//  Copyright © 2017 Cassagne. All rights reserved.
//

import UIKit
import MapKit
import AWSDynamoDB

class LostViewController: UIViewController {
    var dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dynamoDBObjectMapper.load(RuffLife.self, hashKey: 0, rangeKey:nil).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            } else if let resultModel = task.result as? RuffLife {
                // Do something with task.result.
                print(resultModel.Breed!)
            }
            return nil
        })
    }

}
