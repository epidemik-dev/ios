//
//  AddressChanger.swift
//  Epidemik
//
//  Created by Ryan Bradford on 12/13/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import UserNotifications

class ADDRESS {
	
	public static var FILE_NAME = "address.epi"
	
	public static func askForNewAddress(message: String) {
		
		Asker.ask(title: "Address", placeHolder: "1 Main St. New York, NY", message: message, isSecure: false, resp: response)
	}
	
	public static func response(data: String) {
		ADDRESS.convertToCordinates(address: data)
	}
	
	public static func convertToCordinates(address: String) {
		if (address != "") {
			FileRW.writeFile(fileName: ADDRESS.FILE_NAME, contents: address)
			let geocoder = CLGeocoder()
			geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
				if let buffer = placemarks?[0] {
					let location = buffer.location;
					self.sendToServer(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
				}
			})
		} else {
			setError()
		}
	}
	
	static func sendToServer(latitude: Double, longitude: Double) {
		NetworkAPI.updateAddress(username: FileRW.readFile(fileName: "username.epi")!, latitude: latitude, longitude: longitude)
	}
	
	public static func setError() {
		askForNewAddress(message: "Please Enter A Valid Address")
	}
	
}


