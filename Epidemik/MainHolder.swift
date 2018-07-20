//
//  MainHolder.swift
//  Epidemik
//
//  Created by Ryan Bradford on 10/12/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class MainHolder: UIView {
	//The UIView that brings the app together
	//Holds the map, the trends, the sickness registration, the settings, and the transition buttons
	//Probably some other stuff too
	
	
	var mapView: Map!
	var sicknessView: SicknessView!
	var trendsView: GTrendsView!
	var personalTrends: PTrendsView!
	
	var mapButton: UIButton!
	var pTrendsButton: UIButton!
	var gTrendsButton: UIButton!
	
	var settingsButton: UIButton!
	
	var loadingView: LoadingGraphic!
	
	var settings: SettingsView!
	var isSettings = false
	
	var transControls: TransitionControls!
	
	var dataCenter: DataCenter!
	
	
	
	
	//Creates this class with all the perams
	//OTHER: inits every UIView object and begins to load the data
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.accessibilityIdentifier = "MainHolder"
		
		initSettings()
		initMap()
		initPersonalTrends()
		initTrends()
		initTransition()
		initChangeButtons()
		initBringBackSicknessButton()
		self.bringSubview(toFront: settingsButton)
		initSickness()
		initData()
		initLoading()
		
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	//Creates the data cennter
	//EFFECT: updates the map, trends, and pTrends data center also reloads their data when done loading
	func initData() {
		self.dataCenter = RealDataCenter(mainScreen: self, map: self.mapView, trendsView: self.trendsView, pTrendsView: self.personalTrends)
		self.mapView.dataCenter = self.dataCenter
		self.trendsView.dataCenter = self.dataCenter
		self.personalTrends.dataCenter = dataCenter
	}
	
	//Creates the sickness screen
	//EFFECT: if it already exists remove it and load it as normal
	func initSickness() {
		if(sicknessView != nil) {
			sicknessView.removeFromSuperview()
		}
		sicknessView = SicknessView(frame: self.frame)
		self.addSubview(sicknessView)
	}
	
	//Creates the map
	func initMap() {
		let leftFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
		mapView = Map(frame: leftFrame, settingsButton: settingsButton)
		self.addSubview(mapView)
	}
	
	//Creates the local trends view
	func initTrends() {
		trendsView = GTrendsView(frame: CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height))
		self.addSubview(trendsView)
	}
	
	//Creates the personal trends view
	func initPersonalTrends() {
		personalTrends = PTrendsView(frame: CGRect(x: -self.frame.width, y:0, width: self.frame.width, height: self.frame.height))
		self.addSubview(personalTrends)
	}
	
	//Transitions to the map from any other view
	//EFFECT: shifts all the cordinates of the views and updates the alpha level of the buttons
	@objc func transisitionToMap(_ sender: UIButton?) {
		UIView.animate(withDuration: 0.5, animations: {
			self.mapButton.alpha = 1
			self.pTrendsButton.alpha = 0.5
			self.gTrendsButton.alpha = 0.5
			self.sicknessView.alpha = 0
			
			self.personalTrends.frame.origin.x = -self.frame.width
			
			self.trendsView.frame.origin.x = self.frame.width
		})
	}
	
	//Transitions to the pTrends from any other view
	//EFFECT: shifts all the cordinates of the views and updates the alpha level of the buttons
	@objc func transisitionToPTrends(_ sender: UIButton?) {
		UIView.animate(withDuration: 0.5, animations: {
			self.mapButton.alpha = 0.5
			self.gTrendsButton.alpha = 0.5
			self.pTrendsButton.alpha = 1
			
			self.personalTrends.alpha = 1
			self.personalTrends.frame.origin.x = 0
			self.trendsView.frame.origin.x = self.frame.width
			
		})
	}
	
	//Transitions to the gTends from any other view
	//EFFECT: shifts all the cordinates of the views and updates the alpha level of the buttons
	@objc func transisitionToGTrends(_ sender: UIButton?) {
		UIView.animate(withDuration: 0.5, animations: {
			self.mapButton.alpha = 0.5
			self.pTrendsButton.alpha = 0.5
			self.gTrendsButton.alpha = 1
			
			self.personalTrends.alpha = 0
			self.personalTrends.frame.origin.x = -self.frame.width
			
			self.trendsView.frame.origin.x = 0
		})
	}
	
	//Creates the buttons that move the screens
	func initChangeButtons() {
		initMapButton()
		initPTrendsButton()
		initTrendsButton()
	}
	
	//Creates the button that would show the gTrendsView
	func initTrendsButton() {
		let trendsImage = FileRW.readImage(imageName: "trends.png")
		gTrendsButton = UIButton(frame: CGRect(x: self.frame.width - 55, y: self.frame.height - 65, width: 50, height: 50))
		gTrendsButton.backgroundColor = PRESETS.CLEAR
		gTrendsButton.addTarget(self, action: #selector(MainHolder.transisitionToGTrends(_:)), for: .touchUpInside)
		gTrendsButton.setImage(trendsImage, for: .normal)
		gTrendsButton.alpha = 0.5
		self.addSubview(gTrendsButton)
	}
	
	//Creates the button to show the pTrendsView
	func initPTrendsButton() {
		let pTrendsImage = FileRW.readImage(imageName: "sickness.png")
		pTrendsButton = UIButton(frame: CGRect(x: 5, y: self.frame.height - 65, width: 50, height: 50))
		pTrendsButton.backgroundColor = PRESETS.CLEAR
		pTrendsButton.addTarget(self, action: #selector(MainHolder.transisitionToPTrends(_:)), for: .touchUpInside)
		pTrendsButton.setImage(pTrendsImage, for: .normal)
		pTrendsButton.alpha = 0.5
		self.addSubview(pTrendsButton)
	}
	
	//Creates the button to show the map
	func initMapButton() {
		let mapImage = FileRW.readImage(imageName: "globe2")
		mapButton = UIButton(frame: CGRect(x: self.frame.width/2 - 25, y: self.frame.height - 65, width: 50, height: 50))
		mapButton.backgroundColor = PRESETS.CLEAR
		mapButton.addTarget(self, action: #selector(MainHolder.transisitionToMap(_:)), for: .touchUpInside)
		mapButton.setImage(mapImage, for: .normal)
		mapButton.alpha = 1
		self.addSubview(mapButton)
	}
	
	//Creates the button to show the settings
	func initSettings() {
		let settingsImage = FileRW.readImage(imageName: "settings.png")
		settingsButton = UIButton(frame: CGRect(x: 3*self.frame.width/32-self.frame.height/32, y: self.frame.height/16, width: self.frame.height/16, height: self.frame.height/16))
		settingsButton.accessibilityIdentifier = "SettingsButton"
		settingsButton.backgroundColor = PRESETS.CLEAR
		settingsButton.setImage(settingsImage, for: .normal)
		settingsButton.addTarget(self, action: #selector(MainHolder.showSettings(_:)), for: .touchUpInside)
		settingsButton.window?.windowLevel = UIWindowLevelStatusBar
		self.addSubview(settingsButton)
	}
	
	//Creates the loading graphic that runs until the sickness view is done loading
	func initLoading() {
		let grahicSize = self.frame.height / 4
		loadingView = LoadingGraphic(frame: CGRect(x: self.frame.width/2 - grahicSize/2, y: self.frame.height/2 - grahicSize/2, width: grahicSize, height: grahicSize))
		self.addSubview(loadingView)
		self.loadingView.startAnimation()
	}
	
	//The function that is called when the settings button is pressed
	//Creates and moves the settings view on to the screen
	@objc func showSettings(_ sender: UIButton?) {
		isSettings = true
		settings = SettingsView(frame: CGRect(x: 0, y: -self.frame.height, width: self.frame.width, height: self.frame.height), mainView: self)
		self.addSubview(settings)
		UIView.animate(withDuration: 0.5, animations: {
			self.settings.frame.origin.y += self.frame.height
		})
	}

	//Creates the transition controls from swipe capibilites
	func initTransition() {
		transControls = TransitionControls(mainView: self)
	}
	
	//Creates the button that can recal the sickness view after the user has pressed done to dismis it
	func initBringBackSicknessButton() {
		let bringBackButton = UIButton(frame: CGRect(x: 29*self.frame.width/32-self.frame.height/32, y: self.frame.height/16, width: self.frame.height/16, height: self.frame.height/16))
		bringBackButton.setImage(FileRW.readImage(imageName: "sickness2.png"), for: .normal)
		bringBackButton.addTarget(self, action: #selector(bringBackSickness), for: .touchUpInside)
		self.addSubview(bringBackButton)
	}
	
	//What is called when the bring back button is pressed
	//EFFECT: Adds and slides down the sickness view
	@objc func bringBackSickness(_ sender: UIButton?) {
		self.addSubview(sicknessView)
		UIView.animate(withDuration: 0.5, animations: {
			self.sicknessView.frame.origin.y += self.frame.height
			self.sicknessView.alpha = 1
		})
	}
	
	// Writes to DiseaseQuestions all the info that we need
	// EFFECT: changes DiseaseQuestions info
	func getSymptomInfo() {
		
	}
	
}

