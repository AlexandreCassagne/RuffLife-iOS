//
//  FoundViewController.swift
//  RuffLife
//
//  Created by Alexandre Cassagne on 21/10/2017.
//  Copyright © 2017 Cassagne. All rights reserved.
//

import UIKit

class FoundViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
		pictureView.image = image

		let a = UIImagePNGRepresentation(image)!
		let base64 = a.base64EncodedString()
		
//		print(base64)
		
		picker.dismiss(animated: true, completion: nil)
	}
	
	@IBOutlet weak var location: UITextField!
	@IBOutlet weak var breed: UITextField!
	@IBOutlet weak var color: UITextField!
	@IBOutlet weak var firstName: UITextField!
	@IBOutlet weak var number: UITextField!
	@IBOutlet weak var pictureView: UIImageView!
	override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
    }
	@IBAction func submit(_ sender: Any) {
		
	}
	@IBAction func autofill(_ sender: Any) {
		let picker = UIImagePickerController();
		picker.sourceType = .camera
		picker.delegate = self
//		self.show(picker, sender: self)
		present(picker, animated: true, completion: nil)
	}
	
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
