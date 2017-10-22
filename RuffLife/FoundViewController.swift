//
//  FoundViewController.swift
//  RuffLife
//
//  Created by Alexandre Cassagne on 21/10/2017.
//  Copyright © 2017 Cassagne. All rights reserved.
//

import UIKit
import AWSDynamoDB
import CoreLocation

class FoundViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
	
	var locationCoordinate: CLLocationCoordinate2D?
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let l = locations[0]
		locationCoordinate = l.coordinate
		location.text = "\(locationCoordinate!.latitude, locationCoordinate!.latitude)"
		print(location)
	}

	var url: String?
	
	var uploadImage: UploadImage?
	var imagePicker = UIImagePickerController()
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}
	
	private func startAzure() {
		let a = Azure()
		print("Starting azure...")
		a.request(url: self.url!) { predictions in
			print("Got callback.")
			let top = predictions[0] as! [String: Any]
			print(top)
			let p = top["Probability"] as! Double
			let breed = top["Tag"] as! String
			
			if (p > 0.08) {
				OperationQueue.main.addOperation({
					self.breed.text = breed
				})
			}
		}
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
		pictureView.image = image
		
		uploadImage = UploadImage(image: image)
		print("Starting upload...")
		uploadImage?.post {
			print("Returned: \(self.uploadImage?.publicURL)")
			self.url = self.uploadImage?.publicURL?.absoluteString
			self.startAzure()
		}
				picker.dismiss(animated: true, completion: nil)
	}
	
	@IBOutlet weak var location: UITextField!
	@IBOutlet weak var breed: UITextField!
//	@IBOutlet weak var color: UITextField!
	@IBOutlet weak var firstName: UITextField!
	@IBOutlet weak var number: UITextField!
	@IBOutlet weak var pictureView: UIImageView!
	override func viewDidLoad() {
        super.viewDidLoad()
		imagePicker.delegate = self
		locationManager.requestWhenInUseAuthorization()
		locationManager.delegate = self
        // Do any additional setup after loading the view.
    }
	@IBAction func submit(_ sender: Any) {
		print("Hello!")
		guard let coordinate = self.locationCoordinate, let name = firstName.text, let phoneNumber = number.text else {
			print("Fail :( " )
			let alert = UIAlertController(title: "Incomplete Form", message: "Please ensure the form is completely filled out before proceeding.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
			self.present(alert, animated: true, completion: nil)
			return
		}
		
		let db = AWSDynamoDBObjectMapper.default()
		let newPet = RuffLife()!
		
		newPet.FirstName = name
//		newPet.LastName = "Empty"
		newPet.PhoneNumber = phoneNumber
		newPet.Breed = breed.text
//		newPet.Color = color.text
		newPet.ImageURL = url!
		newPet.lat = coordinate.latitude as NSNumber
		newPet.lon = coordinate.longitude as NSNumber
		newPet.PetID = NSNumber(integerLiteral: Int(arc4random()))
		
		db.save(newPet).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
			DispatchQueue.main.async {
				let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
				if let error = task.error as NSError? {
					alert.title = "Failure"
					alert.message = "The request failed. Error: \(error)"
					alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
					self.present(alert, animated: true, completion: nil)

				} else {
					// Do something with task.result or perform other operations.
					alert.title = "Success"
					alert.message = "Successfully published to location of this pet!"
					alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
					self.present(alert, animated: true, completion: {
						self.navigationController?.popViewController(animated: true)
					})

				}
			}
			return nil
		})

	}
	
	func openCamera()
	{
		if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
		{
			imagePicker.sourceType = UIImagePickerControllerSourceType.camera
			imagePicker.allowsEditing = true
			self.present(imagePicker, animated: true, completion: nil)
		}
		else
		{
			let alert  = UIAlertController(title: "Warning", message: "You don't have a camera", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func openGallary()
	{
		imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
		imagePicker.allowsEditing = true
		self.present(imagePicker, animated: true, completion: nil)
	}
	
	@IBAction func autofill(_ sender: Any) {
		let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
		alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
			self.openCamera()
		}))
		
		alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
			self.openGallary()
		}))
		
		alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
		
		locationManager.distanceFilter = kCLDistanceFilterNone;
		locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		locationManager.startUpdatingLocation()
		
		self.present(alert, animated: true, completion: nil)
//		self.show(picker, sender: self)
		
		present(imagePicker, animated: true, completion: nil)
	}
	
	let locationManager = CLLocationManager()
	
	@IBOutlet weak var autofill: UIButton!
	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
