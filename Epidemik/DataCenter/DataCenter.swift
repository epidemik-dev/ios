//
//  DataCenter.swift
//  Epidemik
//
//  Created by Ryan Bradford on 2/17/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation

protocol DataCenter {
	
	//Loads all the data a new
	func loadData()
	
	//Loads the disease data
	func loadDiseaseData()
	
	//Returns the disease data
	func getDiseaseData() -> Array<Disease>
	
	//Loads the global trends
	func loadGlobalTrendData()
	
	//Returns the global trends
	func getGlobalTrendData() -> Array<Trend>
	
	//Loads this users personal data
	func loadPersonalTrendData()
	
	//Returns this users personal data
	func getPersonalTrendData() -> PersonalTrendDataCenter
	
	//Loads this users sickness status
	func loadStatusData()
	
	//Returns this users sickness status
	func getStatusData() -> StatusDataCenter
	
}

public class RealDataCenter: DataCenter {
	
	private var diseaseData: DiseaseDataCenter
	
	private var globalTrendData: GlobalTrendDataCenter
	
	private var personalTrendData: PersonalTrendDataCenter
	
	var statusData: StatusDataCenter
	
	init(mainScreen: MainHolder, map: Map, trendsView: GTrendsView, pTrendsView: PTrendsView) {
		self.diseaseData = DiseaseDataCenter(map: map)
		
		self.globalTrendData = GlobalTrendDataCenter(trendsView: trendsView)
		
		self.personalTrendData = PersonalTrendDataCenter(pTrendsView: pTrendsView)
		
		statusData = StatusDataCenter(mainScreen: mainScreen)
		
		self.loadData()
	}
	
	//Calls the loading method of every sub data center
	func loadData() {
		loadDiseaseData()
		loadGlobalTrendData()
		loadPersonalTrendData()
		loadStatusData()
	}
	
	//Loads the disease data center
	//EFFECT: When done calls the diseaseReactor
	func loadDiseaseData() {
		diseaseData.loadDiseasePointData()
	}
	
	//Returns all the disease data points
	//Only has lat and long
	func getDiseaseData() -> Array<Disease> {
		return diseaseData.getAppropriateData()
	}
	
	//Loads all the trend data for this users location
	//EFFECT: calls the globalTrendReactor when done
	func loadGlobalTrendData() {
		self.globalTrendData.loadData()
	}
	
	//Returns all trends for the given users region
	func getGlobalTrendData() -> Array<Trend> {
		return globalTrendData.getTrends()
	}
	
	//Loads all the personal data for this user
	//EFFECT: calls the personalTrendReactor when done
	func loadPersonalTrendData() {
		self.personalTrendData.loadData()
	}
	
	// Returns the PersonalTrendDataCenter
	func getPersonalTrendData() -> PersonalTrendDataCenter {
		return self.personalTrendData
	}
	
	//Loads this users status
	//EFFECT: Calls the sickness reporting screen loading when done
	func loadStatusData() {
		self.statusData.getUserStatus()
	}
	
	//Returns this StatusDataCenter
	func getStatusData() -> StatusDataCenter {
		return self.statusData
	}
	
}
