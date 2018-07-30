//
//  DiseaseNameScreen.swift
//  Epidemik
//
//  Created by Ryan Bradford on 9/25/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import SwiftyButton

public class DiseaseNameScreen: UIView {
	
	//The sad face that is at the top of the screen
	var sadFace: UIImageView!
	
	//The two action buttons
	var backButton: PressableButton!
	var submitButton: PressableButton!
	
	//The place where you select the disease name
	var diseaseSelector: ScrollSelector!
	
	//The sickness screen that this view was created from
	var superScreen: SicknessView!
	
	//The place where you can search for the disease name
	var searchBox: UITextField!
	
	//Where the buttons are placed on the screen
	let buttonInShift = CGFloat(25.0)
	let buttonUpShift = CGFloat(20.0)
	
	//The view that comes after this one
	var questionair: DiseaseQuestionair!
	
	init (frame: CGRect, superScreen: SicknessView) {
		self.superScreen = superScreen
		super.init(frame: frame)
		self.accessibilityIdentifier = "DiseaseNameScreen"
		initBlur()
		initSadFace()
		initDiseaseSelector()
		initTextBox()
		initSendButton()
		initBackButton()
		self.backgroundColor = PRESETS.CLEAR
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// A SadFace is a (UIView centered at the middle-top of the screen)
	// Creates the sad face graphic on the screen
	func initSadFace() {
		let frame = CGRect(x: self.frame.width/4, y: 15, width: self.frame.width/2, height: self.frame.width/2)
		let image = FileRW.readImage(imageName: "sadface.png")
		sadFace = UIImageView(image: image)
		sadFace.frame = frame
		
		sadFace.backgroundColor = PRESETS.CLEAR
		self.addSubview(sadFace)
	}
	
	// Shows the text box where users can search for their disease
	// EFFECT: adds the search box to the view
	func initTextBox() {
		searchBox = UITextField(frame: CGRect(x: 0, y: self.frame.width/2+30, width: self.frame.width, height: 30))
		searchBox.textAlignment = .center
		searchBox.backgroundColor = PRESETS.CLEAR
		searchBox.font = PRESETS.FONT_BIG
		searchBox.text = "Search for your disease..."
		searchBox.clearsOnBeginEditing = true
		searchBox.addTarget(self, action: #selector(updateSearch), for: UIControlEvents.allEditingEvents)
		searchBox.addTarget(self, action: #selector(slideAllUp), for: UIControlEvents.editingDidBegin)
		searchBox.addTarget(self, action: #selector(slideAllDown), for: UIControlEvents.editingDidEnd)
		self.addSubview(searchBox)
	}
	
	//The reactor to editing the search view
	//EFFECT: filters the list of diseases
	@objc func updateSearch(_ sender: UITextField?) {
		diseaseSelector.limitItems(search: searchBox!.text!)
	}
	
	//Moves every item on the screen up by a certain amount when the user begins typing
	@objc func slideAllUp(_ sender: UITextField?) {
		let slideUp = self.frame.width/2 + 15
		UIView.animate(withDuration: 0.5, animations: {
			self.sadFace.frame.origin.y -= slideUp
			self.searchBox.frame.origin.y -= slideUp
			self.diseaseSelector.frame.origin.y -= slideUp
			self.submitButton.frame.origin.y -= slideUp
			self.backButton.frame.origin.y -= slideUp
		})
	}
	
	//Moves every item on the screen down by a certain amount when the user begins typing
	//EFFECT: edits the Y cordinates of certain UIView objects in the class
	@objc func slideAllDown(_ sender: UITextField?) {
		if(sadFace.frame.origin.y > 0) {
			return
		}
		let slideDown = self.frame.width/2 + 15
		UIView.animate(withDuration: 0.5, animations: {
			self.sadFace.frame.origin.y += slideDown
			self.searchBox.frame.origin.y += slideDown
			self.diseaseSelector.frame.origin.y += slideDown
			self.submitButton.frame.origin.y += slideDown
			self.backButton.frame.origin.y += slideDown
		})
	}
	
	//Creates the title of the screen
	func initDiseaseSelectorTitle() {
		let selectorTitle = UITextView(frame: CGRect(x: 0, y: self.frame.width/2+30, width: self.frame.width, height: 30))
		selectorTitle.text = "Select Your Illness"
		selectorTitle.textAlignment = .center
		selectorTitle.backgroundColor = PRESETS.CLEAR
		selectorTitle.font = PRESETS.FONT_BIG
		selectorTitle.autocorrectionType = UITextAutocorrectionType.no
		self.addSubview(selectorTitle)
	}
	
	// A DiseaseSelector is a scrollable selector in the middle of the screen
	// Creates the selector that lets the user select which disease they have
	func initDiseaseSelector() {
		diseaseSelector = ScrollSelector(frame: CGRect(x: 0, y: 4*self.frame.height/16, width: self.frame.width, height: 3*self.frame.height/8), items: DISEASE_QUESTIONS.diseases)
		self.addSubview(diseaseSelector)
	}
	
	// A SendButton is a button in the bottom right of the screen
	// Creates the button that allows the user to send their sickness data to the server
	func initSendButton() {
		submitButton = PressableButton(frame: CGRect(x: self.frame.width/2+buttonInShift, y: 3*self.frame.height/4 - buttonUpShift, width: self.frame.width/2-2*buttonInShift, height: self.frame.height/4-2*buttonInShift))
		submitButton.accessibilityIdentifier = "SubmitButton"
		submitButton.setTitle("SUBMIT", for: .normal)
		submitButton.titleLabel?.font = PRESETS.FONT_BIG_BOLD
		submitButton.colors = .init(button: PRESETS.RED, shadow: PRESETS.RED)
		submitButton.addTarget(self, action: #selector(gatherAndSendInfo), for: .touchUpInside)
		submitButton.cornerRadius = 15
		self.addSubview(submitButton)
	}
	
	// A BackButton is a button in the bottom right of the screen
	// Creates the button that allows the user to go back to the sickness screen
	func initBackButton() {
		backButton = PressableButton(frame: CGRect(x: buttonInShift, y: 3*self.frame.height/4 - buttonUpShift, width: self.frame.width/2 - 2*buttonInShift, height: self.frame.height/4 - 2*buttonInShift))
		backButton.setTitle("BACK", for: .normal)
		backButton.colors = .init(button: PRESETS.GRAY, shadow: PRESETS.GRAY)
		backButton.titleLabel?.font = PRESETS.FONT_BIG_BOLD
		backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
		backButton.cornerRadius = 15
		self.addSubview(backButton)
	}
	
	// Recieves the press from the back button and slides the disease selection screen to the right
	@objc func back(_ sender: UIButton?) {
		superScreen.addSubview(superScreen.diagnoseButton)
		superScreen.addSubview(superScreen.sicknessButton)
		UIView.animate(withDuration: 0.5, animations: {
			self.frame.origin.x += self.frame.width
			self.superScreen.sicknessButton.frame.origin.x += self.frame.width
			self.superScreen.diagnoseButton.frame.origin.x += self.frame.width
		}, completion: {
			(value: Bool) in
			self.removeFromSuperview()
		})
	}
	
	// Slides the disease selection screen on-screen and moves the healthy button off screen
	func forwards() {
		questionair = DiseaseQuestionair(frame: CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height), disease_name: diseaseSelector.currentTextField!.text!, superScreen: self.superScreen)
		superScreen.sicknessButton.removeFromSuperview()
		self.superScreen.addSubview(questionair)
		UIView.animate(withDuration: 0.5, animations: {
			self.frame.origin.x -= self.frame.width
			self.questionair.frame.origin.x -= self.frame.width
		}, completion: {
			(value: Bool) in
			self.removeFromSuperview()
		})
	}
	
	// Recieves a button press from the send button and sends the sickness report to the server
	@objc func gatherAndSendInfo(_ sender: UIButton?) {
		self.endEditing(true)
		self.superScreen.initHealthyButton()
		self.superScreen.healthyButton.frame.origin.x += self.frame.width
		self.forwards()
	}
	
	
}



