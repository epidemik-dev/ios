//
//  TrendDataCenter.swift
//  Epidemik
//
//  Created by Ryan Bradford on 2/19/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import SwiftyJSON

class GlobalTrendDataCenter {
	
	var trends = Array<Trend>()
	var trendsView: GTrendsView!
	
	init(trendsView: GTrendsView) {
		self.trendsView = trendsView
	}
	
	//Returns all the trends for this users location
	func getTrends() -> Array<Trend> {
		return self.trends
	}
	
	//Loads all the trend data
	// EFFECT: errases the current trend array, calls the trend loader
	func loadData() {
		self.trends = Array<Trend>()
		let username = FileRW.readFile(fileName: "username.epi")
		self.getTrends(username: username!)
	}
	
	// Calls the network trend loader
	// EFFECT: calls the trend processer when done and loads the data to this class
	func getTrends(username: String) {
		NetworkAPI.getAllTrendData(username: username, result: {(response: JSON?) -> Void in
			DispatchQueue.main.sync {
				self.processTrends(response: response)
			}
		})
	}
	
	//Processes the given trend string
	//EFFECT: writes to the trend array with all the given trends
	func processTrends(response: JSON?) {
		for trend in response!.arrayValue {
			let currentTrend = Trend(name: trend["disease_name"].string!, weight: trend["trend_weight"].double!, latitude: trend["latitude"].double!, longitude: trend["longitude"].double!)
			trends.append(currentTrend)
		}
		if trends.count == 0 {
			trends.append(Trend(name: Trend.nothing, weight: 0, latitude: 0, longitude: 0))
		}
		trendsView.removeAllCurrentTrends()
		trendsView.displayTrends()
	}
	
	
	
}
