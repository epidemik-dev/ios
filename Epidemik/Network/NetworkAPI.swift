//
//  NetworkAPI.swift
//  Epidemik
//
//  Created by Ryan Bradford on 4/20/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class NetworkAPI {
	
	//The URL where all the backend code is stored
	static var baseURL = "https://epidemik.us/api"
	static var versionExtension = "?version=" + (Bundle.main.infoDictionary?["CFBundleVersion"] as! String)
	
	//Says if this username and password combo exist
	public static func loginIsValid(username: String, password: String, result: @escaping (_ response: JSON?) -> Void) {
        let queryParams = "&username=" + username + "&password=" + password
		sendPOSTWithCallback(method: "POST", urlExtensiuon: "/login", queryParams: queryParams, body: Data(), callback: result)
	}
	
	// Creates an account on the database with all this information
	public static func createAccount(username: String, password: String, latitude: Double, longitude: Double, deviceID: String, dob: Date, gender: String, result: @escaping (_ response: JSON?) -> Void) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let body = JSON([
			"username": username,
			"password": password,
			"latitude": latitude,
			"longitude": longitude,
			"deviceID": deviceID,
			"date_of_birth": dateFormatter.string(from: dob),
			"gender": gender] as [String : Any])
		try? sendPOSTWithCallback(method: "POST", urlExtensiuon: "/users", queryParams: "", body: body.rawData(), callback: result)
	}
	
	// Pulls all the current disease infromation from the server where
	// the disease point is still sick and not healthy
	public static func loadAllDiseaseData(result: @escaping (_ response: JSON?) -> Void) {
		let authToken = getAuthToken()
		let queryParams = "&auth_token=" + authToken
		sendPOSTWithCallback(method: "GET", urlExtensiuon: "/diseases", queryParams: queryParams, body: Data(), callback: result)

	}
	
	//Returns all the trend data for the given users location
	public static func getAllTrendData(username: String, result: @escaping (_ response: JSON?) -> Void) {
		let authToken = getAuthToken()
		let queryParams = "&auth_token=" + authToken
		sendPOSTWithCallback(method: "GET", urlExtensiuon: "/trends/" + username, queryParams: queryParams, body: Data(), callback: result)
	}
	
	//Returns all points for this disease in this users location
	public static func getTrendsForDisease(latitude: Double, longitude: Double, diseaseName: String, result: @escaping (_ response: JSON?) -> Void) {
		let diseaseName2 = diseaseName.replacingOccurrences(of: " ", with: "-")
		let authToken = getAuthToken()
		let queryParams = "&auth_token=" + authToken + "&latitude=" + String(latitude) + "&longitude=" + String(longitude) + "&disease_name=" + diseaseName2
		sendPOSTWithCallback(method: "GET", urlExtensiuon: "/trends/historical", queryParams: queryParams, body: Data(), callback: result)
	}
	
	//Returns every disease point that this user has registered
	public static func getAllPersonalData(username: String, result: @escaping (_ response: JSON?) -> Void) {
		let authToken = getAuthToken()
		let queryParams = "&auth_token=" + authToken
		sendPOSTWithCallback(method: "GET", urlExtensiuon: "/users/" + username + "/diseases", queryParams: queryParams, body: Data(), callback: result)
	}
	
	//Says if this user is sick or not
	public static func amISickHuh(username: String, result: @escaping (_ response: JSON?) -> Void) {
		let authToken = getAuthToken()
		let queryParams = "&auth_token=" + authToken
		sendPOSTWithCallback(method: "GET", urlExtensiuon: "/users/" + username + "/sickness", queryParams: queryParams, body: Data(), callback: result)
	}
	
	//Updates the database so that this user is sick
	public static func setSick(username: String, diseaseName: String, symptoms: Array<Int>) {
		let authToken = getAuthToken()
		let queryParams = "&auth_token=" + authToken
		
		let date = NSDate()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let dateString = dateFormatter.string(from:date as Date)

		let diseaseName2 = diseaseName.replacingOccurrences(of: " ", with: "-")
		let body = JSON([
			"disease_name": diseaseName2,
			"date_sick": dateString,
			"date_healthy": nil,
			"symptoms": symptoms
			])
		try? sendPOSTWithCallback(method: "POST", urlExtensiuon: "/users/" + username + "/diseases", queryParams: queryParams, body: body.rawData(), callback: ({(response: JSON?) -> Void
			in
			
		}))
	}
	
	//Updates the database so that this user is healthy
	public static func setHealthy(username: String) {
		let date = NSDate()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let dateString = dateFormatter.string(from:date as Date)
		
		let authToken = getAuthToken()
		let queryParams = "&auth_token=" + authToken + "&date_healthy=" + dateString
		
		sendPOSTWithCallback(method: "PATCH", urlExtensiuon: "/users/" + username + "/diseases", queryParams: queryParams, body: Data(), callback: ({(response: JSON?) -> Void
			in
			
		}))
	}
	
	// Changes this users address
	public static func updateAddress(username: String, latitude: Double, longitude: Double) {
		let authToken = getAuthToken()
		let queryParams = "&auth_token=" + authToken + "&latitude=" + String(latitude) + "&longitude=" + String(longitude)
		sendPOSTWithCallback(method: "PATCH", urlExtensiuon: "/users/" + username, queryParams: queryParams, body: Data(), callback: ({(response: JSON?) -> Void
			in
			
			}))
		
	}
	
	//Sends this POST string to the given url and calls the given callback when it returns
	//If the url errors or the user is offline it calls the callback with the string "error"
	public static func sendPOSTWithCallback(method: String, urlExtensiuon: String, queryParams: String, body: Data, callback: @escaping (_ response: JSON?) -> Void) {
		var request = URLRequest(url: URL(string: baseURL + urlExtensiuon + versionExtension + queryParams)!)
		request.httpMethod = "POST"
		request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
		request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON
		request.httpMethod = method
		request.httpBody = body
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			let responseAsHTTP = response as? HTTPURLResponse
			let status = responseAsHTTP?.statusCode
			if status == 403 || status == 401 || (error != nil) {
				callback(nil)
				return
			} else if(status == 426) {
				showBadVersion()
				callback(nil)
				return
			} else {
				do {
					let json = try JSON(data: data!)
					callback(json)
				} catch {
					var asString = String(data: data!, encoding: String.Encoding.utf8)
					asString = asString!.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range: nil)
					callback(JSON(asString!))
				}
			}
			
		}
		task.resume()
	}
	
	static func showBadVersion() {
		var view = UIApplication().windows[0]
		let frame = CGRect(x: 0, y: -view.frame.height, width: view.frame.width, height: view.frame.height)
		let badScreen = BadVersionScreen(frame: frame)
		badScreen.accessibilityIdentifier = "BadScreen"
		view.addSubview(badScreen)
		UIView.animate(withDuration: 0.5, animations: {
			badScreen.frame.origin.y += frame.height
		})
	}
	
	static func getAuthToken() -> String {
		let token = FileRW.readFile(fileName: "auth_token.epi")
		if(token != nil) {
			return token!
		} else {
			return ""
		}
	}
	
}
