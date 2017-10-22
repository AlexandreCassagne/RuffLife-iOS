//
//  Azure.swift
//  RuffLife
//
//  Created by Alexandre Cassagne on 21/10/2017.
//  Copyright © 2017 Cassagne. All rights reserved.
//

import UIKit

class Azure {
	private let endpoint = "https://southcentralus.api.cognitive.microsoft.com/customvision/v1.0/Prediction/ab2f8c58-1956-4af1-854c-85526a91a6b4/image"
	private var request : URLRequest
	
	init() {
		request = URLRequest(url: URL(string: self.endpoint)!)
		request.httpMethod = "POST"
		request.setValue("5956214919b442b7b7ad0772fd491aa1", forHTTPHeaderField: "Prediction-Key")
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
	}
	
	func request(_ url : String) {
		
		let json = ["Url": url]
		let jsonData = try! JSONSerialization.data(withJSONObject: json, options: .sortedKeys)
		print (jsonData);

		
		
		request.httpBody = jsonData
		
		print(request.debugDescription)
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {                                                 // check for fundamental networking error
				print("error=\(error)")
				return
			}
			
			if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
				print("statusCode should be 200, but is \(httpStatus.statusCode)")
				print("response = \(response)")
			}
			
			let responseString = String(data: data, encoding: .utf8)
			print("responseString = \(responseString)")
		}
		
		task.resume()

	}
	
	
}
