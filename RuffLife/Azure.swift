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
	
	func request(_ url : String) -> Dictionary<String, Any> {
		var d = [String: String]()
		d["URL"] = url
		return [:]
	}
	
	
}
