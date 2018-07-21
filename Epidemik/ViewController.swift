//
//  ViewController.swift
//  Epidemik
//
//  Created by Ryan Bradford on 9/15/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

//Crowd Sourced Disease

//App Parts
//Map
//Can be displayed versus time
//Notifications for disease
//When a disease is spreading in an area
//Disease Reporting
//Allows the user to say when they are sick
//Allows the user to report when they are better
//Say what type of sickness they have?
//Startup Screen
//User reports where they live

class ViewController: UIViewController {
	
	var accCreation: LoginScreen!
	
	var mainView: MainHolder!
	
	var introGraphic: UIView!
	
	
	
	// A testing initalizer
	init() {
		super.init(nibName: nil, bundle: nil)
		
		UIApplication.shared.shortcutItems = [] // Remove quick touch if exists
		self.displayIntroGraphics() //Display the intro graphic again
		//Maybe have it do something fancy?
		self.initWalkthrough()
		self.checkLogin()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = PRESETS.WHITE
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	//Displays the Graphic before everything is loaded
	func displayIntroGraphics() {
		introGraphic = UIView(frame: self.view.frame)
		introGraphic.backgroundColor = PRESETS.WHITE
		self.view.addSubview(introGraphic)
		usleep(500000)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// Creates the main screen that handles the three seperate views
	// - Left: Map
	// - Middle: Sickness Screen
	// - Right: Trends
	func initMainScreen() {
		mainView = MainHolder(frame: self.view.frame)
		self.view.addSubview(mainView)
		self.view.sendSubview(toBack: mainView)
	}
	
	// Creates the view that holds all the intro screens
	func initWalkthrough() {
		accCreation = LoginScreen(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), vc: self) //Calls initDatabase when done
		if(accCreation.shouldAdd) {
			self.view.addSubview(accCreation)
			self.view.sendSubview(toBack: accCreation)
		}
		self.removeIntroGraphics()
	}
	
	// Removes the graphic that is there before things load
	func removeIntroGraphics() {
		UIView.animate(withDuration: 0.5, animations: {
			self.introGraphic.frame.origin.x -= self.view.frame.width
		}, completion: {
			(value: Bool) in
			self.introGraphic.removeFromSuperview()
		})
	}
	
	// Removes the graphics that lead the user through account creation
	func removeWalkthrough() {
		UIView.animate(withDuration: 0.5, animations: {
			self.accCreation.frame.origin.x -= self.view.frame.width
		}, completion: {
			(value: Bool) in
			self.accCreation.removeFromSuperview()
		})
	}
	
	// Shows the map and all its parts
	func showMainView() {
		if (mainView == nil) {
			initMainScreen()
		}
		if mainView.isSettings {
			self.mainView.settings.removeSelf(nil)
		}
		self.mainView.frame = CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
		self.view.bringSubview(toFront: self.mainView)
		UIView.animate(withDuration: 0.5, animations: {
			self.mainView.frame.origin.x -= self.view.frame.width
		})
		
	}
	
	// Updates the trends based on any changes or a users new location
	func updateTrends() {
		if mainView != nil && mainView.trendsView
			!= nil {
			mainView.trendsView.updateTrends()
		}
	}
	
	//Restarts the whole app from the begining
	//Reloads all the data and restarts the walkthrough
	//Mainly used for restarting if the user wants to log out
	func restart() {
		self.mainView.removeFromSuperview()
		self.displayIntroGraphics() //Display the intro graphic again
		//Maybe have it do something fancy?
		self.initWalkthrough()
	}
	
	//Runs the test to see if the login is valid that is written to the disk
	//EFFECT: if it is not, deletes it from the disk and restarts the app
	func checkLogin() {
		if(accCreation.shouldAdd == false) {
			let username = FileRW.readFile(fileName: "username.epi")
			let password = FileRW.readFile(fileName: "password.epi")
			NetworkAPI.loginIsValid(username: username!, password: password!, result: {(response: JSON?) -> () in
				if(response == nil) {
					DispatchQueue.main.sync {
						self.view.addSubview(self.accCreation)
						self.view.sendSubview(toBack: self.accCreation)
					}
				} else {
					FileRW.writeFile(fileName: "auth_token.epi", contents: response!.string!)
					DispatchQueue.main.sync {
						self.initMainScreen()
					}
				}
			})
		} else {
			self.view.addSubview(self.accCreation)
			self.view.sendSubview(toBack: self.accCreation)
		}
	}
	
	
	
	
}

