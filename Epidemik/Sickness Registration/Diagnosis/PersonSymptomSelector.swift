//
//  PersonSymptomSelector.swift
//  Epidemik
//
//  Created by Ryan Bradford on 7/13/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

class PersonSymptomSelector: UIView {
	
	var manager: DiagnosisManager!
	var head: UIButton!
	var chest: UIButton!
	
	var backButton: UIButton!
	var doneButton: UIButton!
	
	//Where the buttons are placed on the screen
	let buttonInShift = CGFloat(25.0)
	let buttonUpShift = CGFloat(20.0)
	
	init(frame: CGRect, manager: DiagnosisManager) {
		super.init(frame: frame)
		self.manager = manager
		self.initPerson()
		self.initDoneButton()
		self.initBackButton()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// Adds the content to the screen that allows you to select symptoms
	func initPerson() {
		initHead()
		initChest()
	}
	
	func initHead() {
		head = UIButton(frame: CGRect(x: 20, y: 0, width: 60, height: 100))
		head.backgroundColor = UIColor.red
		head.accessibilityIdentifier = "head"
		head.addTarget(self, action: #selector(PersonSymptomSelector.bodyPartClicked(_:)), for: .touchUpInside)
		self.addSubview(head)
	}
	
	func initChest() {
		chest = UIButton(frame: CGRect(x: 0, y: 100, width: 100, height: 100))
		chest.backgroundColor = UIColor.blue
		chest.accessibilityIdentifier = "chest"
		chest.addTarget(self, action: #selector(PersonSymptomSelector.bodyPartClicked(_:)), for: .touchUpInside)
		self.addSubview(chest)
	}
	
	// The thing that happens when a body part is clicked
	@objc func bodyPartClicked(_ sender: UIButton?) {
		var frame = self.frame
		frame.origin.x = self.frame.width
		let bodyPartSelector = BodyPartSymptomSelector(frame: frame, partName: sender!.accessibilityIdentifier!)
		self.addSubview(bodyPartSelector)
		UIView.animate(withDuration: 0.5, animations: {
			bodyPartSelector.frame.origin.x -= self.frame.width
		})
	}
	
	// A SendButton is a button in the bottom right of the screen
	// Creates the button that allows the user to send their sickness data to the server
	func initDoneButton() {
		doneButton = UIButton(frame: CGRect(x: self.frame.width/2+buttonInShift, y: 3*self.frame.height/4 - buttonUpShift, width: self.frame.width/2-2*buttonInShift, height: self.frame.height/4-2*buttonInShift))
		doneButton.accessibilityIdentifier = "AgreeButton"
		doneButton.setTitle("AGREE", for: .normal)
		doneButton.titleLabel?.font = PRESETS.FONT_BIG_BOLD
		doneButton.backgroundColor = PRESETS.RED
		doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
		doneButton.layer.cornerRadius = 15
		self.addSubview(doneButton)
	}
	
	// A BackButton is a button in the bottom right of the screen
	// Creates the button that allows the user to go back to the sickness screen
	func initBackButton() {
		backButton = UIButton(frame: CGRect(x: buttonInShift, y: 3*self.frame.height/4 - buttonUpShift, width: self.frame.width/2 - 2*buttonInShift, height: self.frame.height/4 - 2*buttonInShift))
		backButton.setTitle("BACK", for: .normal)
		backButton.backgroundColor = PRESETS.GRAY
		backButton.titleLabel?.font = PRESETS.FONT_BIG_BOLD
		backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
		backButton.layer.cornerRadius = 15
		self.addSubview(backButton)
	}
	
	// Recieves the press from the back button and slides the disease selection screen to the right
	@objc func back(_ sender: UIButton?) {
		manager.back();
	}
	
	// When the user is finished selecting all their symptoms
	@objc func done(_ sender: UIButton?) {
		
	}
	
}

