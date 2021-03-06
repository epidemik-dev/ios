//
//  PersonSymptomSelector.swift
//  Epidemik
//
//  Created by Ryan Bradford on 7/13/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import SwiftyButton

class PersonSymptomSelector: UIView {
	
	var title: UITextView!
	
	var manager: DiagnosisManager!
	
	var curPersonY: CGFloat!
	var personImage: UIImageView!
	var head: UIButton!
	var neck: UIButton!
	var arms: UIButton!
	var chest: UIButton!
	var stomach: UIButton!
	var leg1: UIButton!
	var leg2: UIButton!
	var full: PressableButton!
	
	var backButton: PressableButton!
	var doneButton: CustomPressableButton!
	var indicator: UIActivityIndicatorView!
	
	//Where the buttons are placed on the screen
	let buttonInShift = CGFloat(25.0)
	let buttonUpShift = CGFloat(40.0)
	// how far the gap between the side and the sym selector is
	var symptomSelectorGap = CGFloat(20)
	// how far the title is pushed down
	var titlePushDown = CGFloat(20)
	
	var symptomDisplay: SymptomSelector!
	
	init(frame: CGRect, manager: DiagnosisManager) {
		super.init(frame: frame)
		self.manager = manager
		self.initTitle()
		self.initPerson()
		//self.displayBodyOutline()
		self.initSymptomDisplay(symptoms: Array<Int>())
		
		self.initDoneButton()
		self.initBackButton()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func initTitle() {
		title = UITextView(frame: CGRect(x: 0, y: titlePushDown, width: self.frame.width, height: self.frame.height/8 - titlePushDown))
		title.backgroundColor = UIColor.clear
		title.text = "Select Region of Symptoms"
		title.textAlignment = .center
		title.font = PRESETS.FONT_VERY_BIG
		self.addSubview(title)
	}
	
	// Adds the content to the screen that allows you to select symptoms
	func initPerson() {
		self.curPersonY = 2*self.frame.height/16
		let startY = self.curPersonY
		let image = FileRW.readImage(imageName: "body.jpg")
		let personDimensions = PersonDimensions(height: self.frame.height/3)
		initHead(width: personDimensions.HEAD_WIDTH, height: personDimensions.HEAD_HEIGHT)
		initNeck(width: personDimensions.NECK_WIDTH, height: personDimensions.NECK_HEIGHT)
		initArms(width: personDimensions.ARM_WIDTH, height: personDimensions.ARM_HEIGHT)
		initChest(width: personDimensions.CHEST_WIDTH, height: personDimensions.CHEST_HEIGHT)
		initStomach(width: personDimensions.CHEST_WIDTH, height: personDimensions.STOMACH_HEIGHT)
		initLegs(width: personDimensions.LEG_WIDTH, height: personDimensions.LEG_HEIGHT, chestWidth: personDimensions.CHEST_WIDTH)
		initFullBody(armWidth: personDimensions.ARM_WIDTH)
		personImage = UIImageView(frame: CGRect(x: self.frame.width/2 - personDimensions.ARM_WIDTH/2, y: startY!, width: personDimensions.ARM_WIDTH, height: self.curPersonY - startY!))
		personImage.image = image
		self.addSubview(personImage)
	}
	
	func initHead(width: CGFloat, height: CGFloat) {
		head = UIButton(frame: CGRect(x: self.frame.width/2 - width/2, y: curPersonY, width: width, height: height))
		curPersonY = curPersonY + height
		head.backgroundColor = UIColor.clear
		head.accessibilityIdentifier = "head"
		head.addTarget(self, action: #selector(PersonSymptomSelector.bodyPartClicked(_:)), for: .touchUpInside)
		self.addSubview(head)
	}
	
	func initArms(width: CGFloat, height: CGFloat) {
		arms = UIButton(frame: CGRect(x: self.frame.width/2 - width/2, y: curPersonY, width: width, height: height))
		arms.backgroundColor = UIColor.clear
		arms.accessibilityIdentifier = "arms"
		arms.addTarget(self, action: #selector(PersonSymptomSelector.bodyPartClicked(_:)), for: .touchUpInside)
		self.addSubview(arms)
	}
	
	func initNeck(width: CGFloat, height: CGFloat) {
		neck = UIButton(frame: CGRect(x: self.frame.width/2-width/2, y: curPersonY, width: width, height: height))
		curPersonY = curPersonY + height;
		neck.backgroundColor = UIColor.clear
		neck.accessibilityIdentifier = "neck"
		neck.addTarget(self, action: #selector(PersonSymptomSelector.bodyPartClicked(_:)), for: .touchUpInside)
		self.addSubview(neck)
	}
	
	func initChest(width: CGFloat, height: CGFloat) {
		chest = UIButton(frame: CGRect(x: self.frame.width/2-width/2, y: curPersonY, width: width, height: height))
		curPersonY = curPersonY + height;
		chest.backgroundColor = UIColor.clear
		chest.accessibilityIdentifier = "chest"
		chest.addTarget(self, action: #selector(PersonSymptomSelector.bodyPartClicked(_:)), for: .touchUpInside)
		self.addSubview(chest)
	}
	
	func initStomach(width: CGFloat, height: CGFloat) {
		stomach = UIButton(frame: CGRect(x: self.frame.width/2-width/2, y: curPersonY, width: width, height: height))
		curPersonY = curPersonY + height;
		stomach.backgroundColor = UIColor.clear
		stomach.accessibilityIdentifier = "stomach"
		stomach.addTarget(self, action: #selector(PersonSymptomSelector.bodyPartClicked(_:)), for: .touchUpInside)
		self.addSubview(stomach)
	}
	
	func initLegs(width: CGFloat, height: CGFloat, chestWidth: CGFloat) {
		leg1 = UIButton(frame: CGRect(x: self.frame.width/2-chestWidth/2, y: curPersonY, width: width, height: height))
		leg1.backgroundColor = UIColor.clear
		leg1.accessibilityIdentifier = "legs"
		leg1.addTarget(self, action: #selector(PersonSymptomSelector.bodyPartClicked(_:)), for: .touchUpInside)
		self.addSubview(leg1)
		
		leg2 = UIButton(frame: CGRect(x: self.frame.width/2+chestWidth/2-width, y: curPersonY, width: width, height: height))
		leg2.backgroundColor = UIColor.clear
		leg2.accessibilityIdentifier = "legs"
		leg2.addTarget(self, action: #selector(PersonSymptomSelector.bodyPartClicked(_:)), for: .touchUpInside)
		self.addSubview(leg2)
		curPersonY = curPersonY + height;
	}
	
	func initFullBody(armWidth: CGFloat) {
		full = PressableButton(frame: CGRect(x: self.frame.width/2-armWidth, y: arms.frame.origin.y + 20, width: armWidth/2, height: armWidth/2))
		full.colors = .init(button: PRESETS.RED, shadow: PRESETS.RED)
		full.setTitle("FULL BODY", for: .normal)
		full.titleLabel!.font = PRESETS.FONT_SMALL_BOLD
		full.cornerRadius = 10
		full.clipsToBounds = true
		full.accessibilityIdentifier = "full"
		full.addTarget(self, action: #selector(PersonSymptomSelector.bodyPartClicked(_:)), for: .touchUpInside)
		self.addSubview(full)
	}
	
	func displayBodyOutline() {
		head.backgroundColor = .blue
		neck.backgroundColor = .magenta
		chest.backgroundColor = .red
		stomach.backgroundColor = .green
		arms.backgroundColor = .purple
		leg1.backgroundColor = .yellow
		leg2.backgroundColor = .yellow
		personImage.alpha = 0.5
	}
	
	// The thing that happens when a body part is clicked
	@objc func bodyPartClicked(_ sender: UIButton?) {
		var frame = self.frame
		frame.origin.x = self.frame.width
		let bodyPartSelector = BodyPartSymptomSelector(frame: frame, partName: sender!.accessibilityIdentifier!, done: finishedAddingSymptomsToPart, currentSymptoms: self.symptomDisplay.getSelectedSymptoms())
		self.addSubview(bodyPartSelector)
		UIView.animate(withDuration: 0.5, animations: {
			bodyPartSelector.frame.origin.x -= self.frame.width
		})
	}
	
	func initSymptomDisplay(symptoms: Array<Int>) {
		if(symptomDisplay != nil) {
			symptomDisplay.removeFromSuperview()
		}
		symptomDisplay = SymptomSelector(frame: CGRect(x: symptomSelectorGap, y: curPersonY + symptomSelectorGap, width: self.frame.width-symptomSelectorGap, height: self.frame.height/4), canSelect: symptoms, selectOrView: false)
		self.addSubview(symptomDisplay)
	}
	
	// A SendButton is a button in the bottom right of the screen
	// Creates the button that allows the user to send their sickness data to the server
	func initDoneButton() {
		let height = self.frame.height/5-2*buttonInShift
		doneButton = CustomPressableButton(frame: CGRect(x: self.frame.width/2+buttonInShift, y: 7*self.frame.height/8 - buttonUpShift, width: self.frame.width/2-2*buttonInShift, height: height))
		doneButton.accessibilityIdentifier = "submit"
		doneButton.setTitle("SUBMIT", for: .normal)
		doneButton.titleLabel?.font = PRESETS.FONT_BIG_BOLD
		doneButton.colors = .init(button: PRESETS.RED, shadow: PRESETS.RED)
		doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
		doneButton.cornerRadius = 15
		self.addSubview(doneButton)
		
		self.indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
		self.indicator.frame = CGRect(x: 20, y: height/2 - 7, width: 15, height: 15)
		self.doneButton.contentView.addSubview(indicator)
	}
	
	// A BackButton is a button in the bottom right of the screen
	// Creates the button that allows the user to go back to the sickness screen
	func initBackButton() {
		backButton = PressableButton(frame: CGRect(x: buttonInShift, y: 7*self.frame.height/8 - buttonUpShift, width: self.frame.width/2 - 2*buttonInShift, height: self.frame.height/5 - 2*buttonInShift))
		backButton.setTitle("BACK", for: .normal)
		backButton.colors = .init(button: PRESETS.GRAY, shadow: PRESETS.GRAY)
		backButton.titleLabel?.font = PRESETS.FONT_BIG_BOLD
		backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
		backButton.cornerRadius = 15
		self.addSubview(backButton)
	}
	
	// Recieves the press from the back button and slides the disease selection screen to the right
	@objc func back(_ sender: UIButton?) {
		manager.back();
	}
	
	// When the user is finished selecting all their symptoms
	@objc func done(_ sender: UIButton?) {
		self.indicator.startAnimating()
		manager.sendResults(symptoms: self.symptomDisplay.getSelectedSymptoms())
	}
	
	func finishedAddingSymptomsToPart(part: BodyPartSymptomSelector) {
		let toAdd = part.getSelectedSymptoms()
		for add in toAdd {
			symptomDisplay.addSymptom(symID: add)
		}
		
		let toRemove = part.getUnselectedSymptoms()
		for remove in toRemove {
			symptomDisplay.removeSymptom(symID: remove)
		}
		
	}
	
}


private class PersonDimensions {
	
	var HEAD_WIDTH: CGFloat
	var HEAD_HEIGHT: CGFloat
	var NECK_WIDTH: CGFloat
	var NECK_HEIGHT: CGFloat
	var ARM_WIDTH: CGFloat
	var ARM_HEIGHT: CGFloat
	var CHEST_WIDTH: CGFloat
	var CHEST_HEIGHT: CGFloat
	var STOMACH_HEIGHT: CGFloat
	var LEG_WIDTH: CGFloat
	var LEG_HEIGHT: CGFloat
	
	// The height of the person as a whole
	init(height: CGFloat) {
		HEAD_WIDTH = height / 7
		HEAD_HEIGHT = height / 8
		NECK_WIDTH = HEAD_WIDTH
		NECK_HEIGHT = height / 12
		ARM_WIDTH = height/2
		ARM_HEIGHT = height/2
		CHEST_WIDTH = height/5
		CHEST_HEIGHT = 5*height/24
		STOMACH_HEIGHT = height/4
		LEG_WIDTH = height/9
		LEG_HEIGHT = height/2
	}

	
	
}


