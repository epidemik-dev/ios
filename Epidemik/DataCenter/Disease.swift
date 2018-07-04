//
//  Disease.swift
//  Epidemik
//
//  Created by Ryan Bradford on 10/11/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation

public class Disease {
	
	var lat: Double
	var long: Double
	var diseaseName: String
	var date: Date
	var date_healthy: Date?
	
	var nullData: Date
	
	//Initalizes this disease with this data exactly
	init(lat: Double, long: Double, diseaseName: String, date: Date, date_healthy: Date) {
		self.lat = lat
		self.long = long
		self.diseaseName = diseaseName
		self.date = date
		self.date_healthy = date_healthy
		self.nullData = Date()
	}
	
	//Initalizes this disease and turns the date string to a real Date
	init(lat: Double, long: Double, diseaseName: String, date: String, date_healthy: String?) {
        let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		if(date_healthy == nil) {
			self.date_healthy = nil
		} else {
			self.date_healthy = dateFormatter.date(from: date_healthy!)!
		}

		self.lat = lat
		self.long = long
		self.diseaseName = diseaseName
		
		
		print(date);
		self.date = dateFormatter.date(from: date)!
		
		self.nullData = dateFormatter.date(from: "4099-11-30T00:00:00.000Z")!
	}
	
}
