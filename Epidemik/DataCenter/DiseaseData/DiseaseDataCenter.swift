//
//  DiseasePointCenter.swift
//  Epidemik
//
//  Created by Ryan Bradford on 2/17/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import SwiftyJSON

public class DiseaseDataCenter {
	
	var datapoints = Array<Disease>()
	var map: Map
	
	init(map: Map) {
		self.map = map
	}
	
	// Loads the text from the server given a lat, long, lat width, long height
	// Calls the text->array, process, and draw
	// EFFECT: loads the data and turns it to [Disease]
	func loadDiseasePointData() {
		NetworkAPI.loadAllDiseaseData(result: loadDiseaseTextToArray)
	}
	
	// Processes the text from the server and loads it to a local array
	// EFFECT: calls the loading reactor
	func loadDiseaseTextToArray(toDraw: JSON?) {
		for disease in toDraw!.arrayValue {
			let lat = Double(disease["latitude"].string!)!
			let long = Double(disease["longitude"].string!)!
			let diseaseName = disease["diease_name"].rawString()!
			let dateSick = disease["date_sick"].string!
			let dateHealthy = disease["date_healthy"].string
			self.datapoints.append(Disease(lat: lat, long: long, diseaseName: diseaseName, date: dateSick, date_healthy: dateHealthy))
		}
		DispatchQueue.main.sync {
			map.initAfterData()
			map.isLoading = false
		}
	}
	
	//Returns the disease points
	func getAppropriateData() -> Array<Disease> {
		return datapoints
	}
	
}
