//
//  SicknessScreen.swift
//  Epidemik
//
//  Created by Ryan Bradford on 9/25/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import SwiftyButton

public class SicknessView: UIView {
	//The screen where users report their sickness
	
	var insetX = 30.0
	
	//The button to report health
	var healthyButton: PressableButton!
	//The button to report sickness
	public var sicknessButton: PressableButton!
	// The button to diagnose the user
	public var diagnoseButton: PressableButton!
	//The button to make it all go away
	var doneButton: PressableButton!

	
	var buttonWidth: CGFloat!
	var buttonHeight: CGFloat!
	
	let buttonChampher = CGFloat(40.0)
	let buttonFont = PRESETS.FONT_BIG_BOLD
	
	var sickYCord: CGFloat!
	var doneYCord: CGFloat!
	var diagnoseYCord: CGFloat!
	
	//The title that says the users current status
	var title: UILabel!
	
	override init (frame: CGRect) {
		super.init(frame: frame)
		self.accessibilityIdentifier = "SicknessView"
		initButtonPerams()
		initBlur()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	//Creates the fields that position the buttons on the view
	//EFFECT: creates the fields
	func initButtonPerams() {
		buttonHeight = self.frame.height/6
		buttonWidth = 7*CGFloat(insetX)
		sickYCord = self.frame.height/2 - 3*self.buttonHeight/2
		doneYCord = self.frame.height/2 + 3*self.buttonHeight/2
		diagnoseYCord = self.frame.height/2
	}
	
	// Inits the button that the user can press
	// If they are already sick, it will Say "Healthy Again!"
	// If they are healthy, it will say "Sick :("
	func initButton(isSick: Bool) {
		if (isSick) {
			initHealthyButton()
		} else {
			initSickButton()
			initDiagnoseButton()
		}
		initTitle(isSick: isSick)
		initDoneButton()
	}
	
	// Creates the button that the user can press to say they are sick
	func initSickButton() {
		sicknessButton = PressableButton(frame: CGRect(x: self.frame.width + self.frame.width/2 - buttonWidth/2, y: sickYCord, width: buttonWidth, height: buttonHeight))
		sicknessButton.accessibilityIdentifier = "SickButton"
		sicknessButton.cornerRadius = buttonChampher
		sicknessButton.setTitle("REPORT SICK", for: UIControlState.normal)
		sicknessButton.titleLabel?.font = buttonFont
		sicknessButton.colors = .init(button: PRESETS.GRAY, shadow: PRESETS.GRAY)
		sicknessButton.addTarget(self, action: #selector(SicknessView.amSick(_:)), for: .touchUpInside)
		self.addSubview(sicknessButton)
		
		UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
			self.sicknessButton.frame.origin.x -= self.frame.width
		})
	}
	
	func initDiagnoseButton() {
		diagnoseButton = PressableButton(frame: CGRect(x: self.frame.width + self.frame.width/2 - buttonWidth/2, y: diagnoseYCord, width: buttonWidth, height: buttonHeight))
		diagnoseButton.accessibilityIdentifier = "diagnose"
		diagnoseButton.cornerRadius = buttonChampher
		diagnoseButton.setTitle("DIAGNOSE ME", for: UIControlState.normal)
		diagnoseButton.titleLabel?.font = buttonFont
		diagnoseButton.colors = .init(button: PRESETS.GRAY, shadow: PRESETS.GRAY)
		diagnoseButton.addTarget(self, action: #selector(SicknessView.diagnoseMe(_:)), for: .touchUpInside)
		self.addSubview(diagnoseButton)
		
		UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
			self.diagnoseButton.frame.origin.x -= self.frame.width
		})
	}
	
	// Creates the button that the user can say they are healthy in
	func initHealthyButton() {
		healthyButton = PressableButton(frame: CGRect(x: self.frame.width + self.frame.width/2 - buttonWidth/2, y: sickYCord, width: buttonWidth, height: buttonHeight))
		healthyButton.accessibilityIdentifier = "HealthyButton"
		healthyButton.cornerRadius = buttonChampher
		healthyButton.colors = .init(button: PRESETS.WHITE, shadow: PRESETS.WHITE)
		healthyButton.titleLabel?.font = buttonFont
		healthyButton.setTitleColor(PRESETS.GRAY, for: .normal)
		healthyButton.setTitle("REPORT HEALTHY", for: UIControlState.normal)
		healthyButton.addTarget(self, action: #selector(SicknessView.amHealthy(_:)), for: .touchUpInside)
		self.addSubview(healthyButton)
		
		UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
			self.healthyButton.frame.origin.x -= self.frame.width
		})
	}
	
	//Creates the done button
	//EFFECT: adds the button to the screen and adds the target to the button
	func initDoneButton() {
		doneButton = PressableButton(frame: CGRect(x: self.frame.width + self.frame.width/2 - buttonWidth/2, y: doneYCord, width: buttonWidth, height: buttonHeight))
		doneButton.accessibilityIdentifier = "done"
		doneButton.cornerRadius = buttonChampher
		doneButton.setTitle("Done", for: UIControlState.normal)
		doneButton.titleLabel?.font = buttonFont
		doneButton.colors = .init(button: PRESETS.RED, shadow: PRESETS.RED)
		doneButton.addTarget(self, action: #selector(SicknessView.amDone(_:)), for: .touchUpInside)
		self.addSubview(doneButton)
		
		UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
			self.doneButton.frame.origin.x -= self.frame.width
		})
	}
	
	//Adds the title view to the view
	//EFFECT: creates the title view on a blured background
	func initTitle(isSick: Bool) {
		self.title = UILabel(frame: CGRect(x: 10, y: 10, width: self.frame.width - 100, height: 50))
		if(isSick) {
			self.title.text = "You Are Currently Sick"
		} else {
			self.title.text = "You Are Currently Healthy"
		}
		self.title.font = PRESETS.FONT_BIG_BOLD
		self.title.textAlignment = .center
		let titleBackGround = UIView(frame: CGRect(x: self.frame.width + 40, y: 50, width: self.frame.width - 80, height: 70))
		titleBackGround.initBlur(blurType: UIBlurEffectStyle.prominent)
		titleBackGround.layer.cornerRadius = 20
		titleBackGround.clipsToBounds = true
		titleBackGround.addSubview(self.title)
		self.addSubview(titleBackGround)
		
		UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
			titleBackGround.frame.origin.x -= self.frame.width
		})
		
	}
	
	// Handles Sickness button presses
	// - Creates the disease name categorizer
	// UIButton -> Nothing
	@objc func amSick(_ sender: UIButton?) {
		let diseaseSelector = DiseaseNameScreen(frame: CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height), superScreen: self)
		self.addSubview(diseaseSelector)
		UIView.animate(withDuration: 0.5, animations: {
			self.sicknessButton.frame.origin.x -= self.frame.width
			self.diagnoseButton.frame.origin.x -= self.frame.width
			diseaseSelector.frame = self.frame
		}, completion: {
			(value: Bool) in
			self.diagnoseButton.removeFromSuperview()
			self.sicknessButton.removeFromSuperview()
		})
	}
	
	// Handles Diagnose button presses
	// - Adds the diagnosis manager
	// UIButton -> Nothing
	@objc func diagnoseMe(_ sender: UIButton?) {
		let diseaseWalkThrough = DiagnosisManager(frame: CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height), superScreen: self)
		self.addSubview(diseaseWalkThrough)
		UIView.animate(withDuration: 0.5, animations: {
			self.sicknessButton.frame.origin.x -= self.frame.width
			self.diagnoseButton.frame.origin.x -= self.frame.width
			diseaseWalkThrough.frame = self.frame
		}, completion: {
			(value: Bool) in
			self.diagnoseButton.removeFromSuperview()
			self.sicknessButton.removeFromSuperview()
		})
	}
	
	//Removes the sickness view from the main view
	@objc func amDone(_ sender: UIButton?) {
		UIView.animate(withDuration: 0.5, animations: {
			self.frame.origin.y -= self.frame.height
		})
	}
	
	// Handles the healthy press
	// Wipes the current sickness report from the server
	// Puts the sickness button on the screen
	@objc func amHealthy(_ sender: UIButton?) {
		NetworkAPI.setHealthy(username: FileRW.readFile(fileName: "username.epi")!)
		replaceHealthyButton()
		self.title.text = "You Are Currently Healthy"
	}
	
	// Slides the healthy button to the left and the sickness button in from the right
	func replaceHealthyButton() {
		if(sicknessButton != nil) {
			sicknessButton.removeFromSuperview()
			diagnoseButton.removeFromSuperview()
		}
		let smileyView = UIImageView(image: FileRW.readImage(imageName: "smiley"))
		smileyView.frame = CGRect(x: self.frame.width + self.frame.width/2 - self.frame.height/8, y: sickYCord, width: self.frame.height/4, height: self.frame.height/4)
		self.addSubview(smileyView)
		UIView.animate(withDuration: 0.5, animations: {
			smileyView.frame.origin.x -= self.frame.width
			self.healthyButton.frame.origin.x -= self.frame.width
		}, completion: {
			(value: Bool) in
			UIView.animate(withDuration: 0.5, animations: {
				smileyView.frame.origin.x -= self.frame.width
			}, completion: {
				(value: Bool) in
				smileyView.removeFromSuperview()
			})
			self.initSickButton()
			self.initDiagnoseButton()
			self.healthyButton.removeFromSuperview()
		})
	}
	
}
