//
//  PersonalTrendDataCenter
//  Epidemik
//
//  Created by Ryan Bradford on 2/17/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import SwiftyJSON

public class PersonalTrendDataCenter {
	
	var datapoints = Array<Disease>()
	var pTrendsView: PTrendsView!
	
	init(pTrendsView: PTrendsView) {
		self.pTrendsView = pTrendsView
	}
	
	// Loads the text from the server given a lat, long, lat width, long height
	// Calls the text->array, process, and draw
	func loadData() {
		datapoints = Array<Disease>()
		NetworkAPI.getAllPersonalData(username: FileRW.readFile(fileName: "username.epi")!, result: loadDiseaseTextToArray)
	}
	
	// Processes the text from the server and loads it to a local array
	//EFFECT: calls the loading reactor when done and creates the datapoints field
	func loadDiseaseTextToArray(toDraw: JSON?) {
		for disease in toDraw!.arrayValue {
			let lat = Double(disease["latitude"].string!)!
			let long = Double(disease["longitude"].string!)!
			let diseaseName = disease["diease_name"].stringValue
			let dateSick = disease["date_sick"].string!
			let dateHealthy = disease["date_healthy"].string
			self.datapoints.append(Disease(lat: lat, long: long, diseaseName: diseaseName, date: dateSick, date_healthy: dateHealthy))
		}
		_ = DispatchQueue.main.sync {
			pTrendsView.displayTrends()
		}
	}
	
	// Returns the date when you are most likely to get sick
	func getAverageDateSick() -> Date {
		var monthSum = 0.0
		var daySum = 0.0
		if(self.datapoints.count == 0) {
			return Date()
		}
		
		for disease in self.datapoints {
			monthSum = monthSum + Double(Calendar.current.component(Calendar.Component.month, from: disease.date))
			daySum = daySum + Double(Calendar.current.component(Calendar.Component.day, from: disease.date))

		}
		let month  = String(Int(round(monthSum/Double(datapoints.count))))
		let day  = String(Int(round(daySum/Double(datapoints.count))))
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM-dd"
		return dateFormatter.date(from: month + "-" + day)!
	}
	
	//Returns the average length you are sick for
	func getAverageLengthSickInDays() -> Double {
		var totalTime = 0.0
		for disease in datapoints {
			if(disease.date_healthy != nil) {
				totalTime = totalTime + disease.date_healthy!.timeIntervalSince(disease.date)
			}
		}
		if(datapoints.count == 0) {
			return 0
		}
		return round(10.0*totalTime / (Double(datapoints.count)*86400.0)) / 10.0
	}
	
	//Returns how many times you are likely to get sick in a year
	func getSicknessPerYear() -> Double {
		if(datapoints.count == 0) {
			return 0
		} else {
			let totalLength = datapoints.last!.date.timeIntervalSince(datapoints.first!.date)
			if(totalLength == 0) {
				return Double(datapoints.count)
			}
			return round(10.0*Double(datapoints.count) / (0.5 + totalLength/31540000)) / 10.0
		}
	}
	
	func getDatapoints() -> Array<Disease> {
		return self.datapoints.sorted(by: {
			$0.date < $1.date
		})
	}
	
}

