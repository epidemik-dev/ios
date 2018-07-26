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
	static var view: UIView!
	//static var baseURL = "https://epidemik.us/api"
	static var baseURL = "http://localhost:3000"
	static var versionExtension = "?version=" + (Bundle.main.infoDictionary?["CFBundleVersion"] as! String)
	
	/**
	Queries to the API to check that this users login is valid. If it is, will return their authentication token.
	- parameter username:the username of the user trying to login
	- parameter password:the password of the user trying to login
	- parameter result:the function that will be called when the return is sent
	- returns: the authentication token if the login is correct
	- complexity: O(N+Network) (N is the number of users)
    */
	public static func loginIsValid(username: String, password: String, result: @escaping (JSON?) -> ()) {
		let queryParams = "&username=" + username + "&password=" + password
		sendPOSTWithCallback(method: "POST", urlExtensiuon: "/login", queryParams: queryParams, body: Data(), callback: result)
	}
	
	/** Creates an account on the database with all this information
	- parameter username:the username of the user trying to create an account
	- parameter password:the password of the user trying to create an account
	- parameter latitude: the latitude that this user lives at (exact)
	- parameter longitude: the longitude that this user lives at (exact)
	- parameter deviceID: the Device ID of the current device
	- parameter dob: the day the user was born on
	- parameter gender: the gender of the given user
	- parameter result:the function that will be called when the return is sent
	- returns: the authentication token when the user creates an account
	- complexity: O(Network)
	*/
	public static func createAccount(username: String, password: String, latitude: Double, longitude: Double, deviceID: String, dob: Date, gender: String, weight: Int, height: Int, smoke: Bool, hypertension: Bool, diabetes: Bool, cholesterol: Bool, result: @escaping (JSON?) -> ()) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let body = JSON([
			"username": username,
			"password": password,
			"latitude": latitude,
			"longitude": longitude,
			"deviceID": deviceID,
			"date_of_birth": dateFormatter.string(from: dob),
			"gender": gender,
			"weight": weight,
			"height": height,
			"does_smoke": smoke,
			"has_hypertension": hypertension,
			"has_diabetes": diabetes,
			"has_high_cholesterol": cholesterol] as [String : Any])
		try? sendPOSTWithCallback(method: "POST", urlExtensiuon: "/users", queryParams: "", body: body.rawData(), callback: result)
	}
	
	// Pulls all the current disease infromation from the server where
	// the disease point is still sick and not healthy
	public static func loadAllDiseaseData(result: @escaping (JSON?) -> ()) {
		let authToken = getAuthToken()
		let queryParams = "&auth_token=" + authToken
		sendPOSTWithCallback(method: "GET", urlExtensiuon: "/diseases", queryParams: queryParams, body: Data(), callback: result)
		
	}
	
	//Returns all the trend data for the given users location
	public static func getAllTrendData(username: String, result: @escaping (JSON?) -> ()) {
		let authToken = getAuthToken()
		let queryParams = "&auth_token=" + authToken
		sendPOSTWithCallback(method: "GET", urlExtensiuon: "/trends/" + username, queryParams: queryParams, body: Data(), callback: result)
	}
	
	//Returns all points for this disease in this users location
	public static func getTrendsForDisease(latitude: Double, longitude: Double, diseaseName: String, result: @escaping (_ response: JSON?) -> ()) {
		let diseaseName2 = diseaseName.replacingOccurrences(of: " ", with: "-")
		let authToken = getAuthToken()
		let queryParams = "&auth_token=" + authToken + "&latitude=" + String(latitude) + "&longitude=" + String(longitude) + "&disease_name=" + diseaseName2
		sendPOSTWithCallback(method: "GET", urlExtensiuon: "/trends/historical", queryParams: queryParams, body: Data(), callback: result)
	}
	
	//Returns every disease point that this user has registered
	public static func getAllPersonalData(username: String, result: @escaping (JSON?) -> ()) {
		let authToken = getAuthToken()
		let queryParams = "&auth_token=" + authToken
		sendPOSTWithCallback(method: "GET", urlExtensiuon: "/users/" + username + "/diseases", queryParams: queryParams, body: Data(), callback: result)
	}
	
	//Says if this user is sick or not
	public static func amISickHuh(username: String, result: @escaping (JSON?) -> ()) {
		let authToken = getAuthToken()
		let queryParams = "&auth_token=" + authToken
		sendPOSTWithCallback(method: "GET", urlExtensiuon: "/users/" + username + "/sickness", queryParams: queryParams, body: Data(), callback: result)
	}
	
	//Updates the database so that this user is sick
	public static func setSick(username: String, symptoms: Array<Int>, callback: @escaping (JSON?) -> ()) {
		NetworkAPI.setSick(username: username, diseaseName: nil, symptoms: symptoms, callback: callback)
	}
	
	public static func setSick(username: String, diseaseName: String, symptoms: Array<Int>) {
		NetworkAPI.setSick(username: username, diseaseName: diseaseName, symptoms: symptoms, callback: ({(response: JSON?) -> ()
			in
			
		}))
	}
	
	//Updates the database so that this user is sick
	public static func setSick(username: String, diseaseName: String?, symptoms: Array<Int>, callback: @escaping (JSON?) -> ()) {
		let authToken = getAuthToken()
		let queryParams = "&auth_token=" + authToken
		
		let date = NSDate()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let dateString = dateFormatter.string(from:date as Date)
		
		var body = JSON([
			"date_sick": dateString,
			"date_healthy": nil,
			"symptoms": symptoms
			])
		if(diseaseName != nil) {
			let diseaseName2 = diseaseName!.replacingOccurrences(of: " ", with: "-")
			body = JSON([
				"disease_name": diseaseName2,
				"date_sick": dateString,
				"date_healthy": nil,
				"symptoms": symptoms
				])
		}
		try? sendPOSTWithCallback(method: "POST", urlExtensiuon: "/users/" + username + "/diseases", queryParams: queryParams, body: body.rawData(), callback: callback)
	}
	
	//Updates the database so that this user is healthy
	public static func setHealthy(username: String) {
		let date = NSDate()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let dateString = dateFormatter.string(from:date as Date)
		
		let authToken = getAuthToken()
		let queryParams = "&auth_token=" + authToken + "&date_healthy=" + dateString
		
		sendPOSTWithCallback(method: "PATCH", urlExtensiuon: "/users/" + username + "/diseases", queryParams: queryParams, body: Data(), callback: ({(response: JSON?) -> ()
			in
			
		}))
	}
	
	// Changes this users address
	public static func updateAddress(username: String, latitude: Double, longitude: Double) {
		let authToken = getAuthToken()
		let queryParams = "&auth_token=" + authToken + "&latitude=" + String(latitude) + "&longitude=" + String(longitude)
		sendPOSTWithCallback(method: "PATCH", urlExtensiuon: "/users/" + username, queryParams: queryParams, body: Data(), callback: ({(response: JSON?) -> ()
			in
			
		}))
	}
	
	public static func getDiagnosisInfo(callback: @escaping (JSON?) -> ()) {
		let authToken = getAuthToken()
		let queryParams = "&auth_token=" + authToken
		sendPOSTWithCallback(method: "GET", urlExtensiuon: "/diseases/symptoms", queryParams: queryParams, body: Data(), callback: callback)
	}
	
	public static func getDiseaseInfo(diseaseName: String, callback: @escaping (JSON?) -> ()) {
		let authToken = getAuthToken()
		let queryParams = "&auth_token=" + authToken
		sendPOSTWithCallback(method: "GET", urlExtensiuon: "/diseases/" + diseaseName + "/information", queryParams: queryParams, body: Data(), callback: callback)
	}
	
	//Sends this POST string to the given url and calls the given callback when it returns
	//If the url errors or the user is offline it calls the callback with the string "error"
	public static func sendPOSTWithCallback(method: String, urlExtensiuon: String, queryParams: String, body: Data, callback: @escaping (JSON?) -> ()) {
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
		DispatchQueue.main.sync {
			let frame = CGRect(x: 0, y: -view.frame.height, width: view.frame.width, height: view.frame.height)
			let badScreen = BadVersionScreen(frame: frame)
			badScreen.accessibilityIdentifier = "BadScreen"
			view.addSubview(badScreen)
			UIView.animate(withDuration: 0.5, animations: {
				badScreen.frame.origin.y += frame.height
			})
		}
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
