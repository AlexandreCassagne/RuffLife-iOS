//
//  UploadImage.swift
//  
//
//  Created by Alexandre Cassagne on 21/10/2017.
//

import UIKit

import AWSS3
import AWSCore


class UploadImage: NSObject {
	let image : UIImage
	let fileURL : URL
	var publicURL: URL?
	init(image: UIImage) {
		self.image = image
		let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
		let filePath = NSString(string: paths[0]).appendingPathComponent("\(NSDate())")
		fileURL = URL(fileURLWithPath: filePath)
		try! UIImagePNGRepresentation(image)?.write(to: fileURL)
	}
	
	func post(_ a: @escaping () -> () ) {
		let uploadRequest = AWSS3TransferManagerUploadRequest()!
		uploadRequest.body = fileURL
		uploadRequest.bucket = "rufflifeimg2"
		uploadRequest.contentType = "image/png"
		uploadRequest.acl = .publicRead
		
		let transferManager = AWSS3TransferManager.default()
		transferManager.upload(uploadRequest).continueWith(block: { (task: AWSTask) -> Any? in
			if let error = task.error {
				print("Upload failed with error: (\(error.localizedDescription))")
			}
			if let exception = task.error {
				print("Upload failed with exception (\(exception))")
			}
			if task.result != nil {
				let url = AWSS3.default().configuration.endpoint.url!
				self.publicURL = (url.appendingPathComponent(uploadRequest.bucket!).appendingPathComponent(uploadRequest.key!))
				print("Uploaded to:\(self.publicURL)")
				a()
			}
			return nil
		})
	}
	
}
