//
//  ViewController.swift
//  RuffLife
//
//  Created by Alexandre Cassagne on 21/10/2017.
//  Copyright © 2017 Cassagne. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var lost_found: UISegmentedControl!
	@IBOutlet weak var dog_cat: UISegmentedControl!
	@IBAction func submit(_ sender: Any) {
		let dog = dog_cat.selectedSegmentIndex == 0
		if (lost_found.selectedSegmentIndex == 1) { // found
			performSegue(withIdentifier: "foundSegue", sender: self)
		} else { // lost
			performSegue(withIdentifier: "lostSegue", sender: self)
		}
		print(dog)
		
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

