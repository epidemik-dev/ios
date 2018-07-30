//
//  DataTermsOfService.swift
//  Epidemik
//
//  Created by Ryan Bradford on 7/13/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import SwiftyButton

class DataTermsOfService: UIView {

	var title: UITextView!
	var tosText: UITextView!
	var agreeButton: PressableButton!
	var backButton: PressableButton!
	var manager: DiagnosisManager!
	//Where the buttons are placed on the screen
	let buttonInShift = CGFloat(25.0)
	let buttonUpShift = CGFloat(20.0)
	
	
	init(frame: CGRect, manager: DiagnosisManager) {
		super.init(frame: frame)
		self.initTitle()
		self.initTOSText()
		self.initAgreeButton()
		self.initBackButton()
		self.manager = manager
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func initTitle() {
		self.title = UITextView(frame: CGRect(x: 10, y: 20, width: self.frame.width-20, height: self.frame.height/5-20))
		self.title.text = "Concerned About Your Health?"
		self.title.textAlignment = .center
		self.title.font = PRESETS.FONT_VERY_VERY_BIG
		self.title.isEditable = false
		self.title.isSelectable = false
		self.title.backgroundColor = .clear
		self.addSubview(self.title)
	}
	
	// Adds the text that says the TOS to the view
	// EFFECT: inits and adds the TOS text to the view
	func initTOSText() {
		self.tosText = UITextView(frame: CGRect(x: 40, y: self.frame.height/5, width: self.frame.width-80, height: self.frame.height/2))
		self.tosText.text = "Our Diagnosis tool is used to give a potential diagnosis of your symptoms. Further consultation with a medical physican is recommended for confirmation. \n\nThis checkup should take around 2 minutes."
		self.tosText.textAlignment = .center
		self.tosText.backgroundColor = UIColor.clear
		self.tosText.isEditable = false
		self.tosText.isSelectable = false
		self.tosText.font = PRESETS.FONT_VERY_BIG
		self.tosText.textColor = PRESETS.GRAY
		self.tosText.layer.cornerRadius = 10
		self.addSubview(self.tosText)
	}
	
	// A SendButton is a button in the bottom right of the screen
	// Creates the button that allows the user to send their sickness data to the server
	func initAgreeButton() {
		agreeButton = PressableButton(frame: CGRect(x: self.frame.width/2+buttonInShift, y: 3*self.frame.height/4 - buttonUpShift, width: self.frame.width/2-2*buttonInShift, height: self.frame.height/4-2*buttonInShift))
		agreeButton.accessibilityIdentifier = "AgreeButton"
		agreeButton.setTitle("AGREE", for: .normal)
		agreeButton.titleLabel?.font = PRESETS.FONT_BIG_BOLD
		agreeButton.addTarget(self, action: #selector(agreed), for: .touchUpInside)
		agreeButton.colors = .init(button: PRESETS.RED, shadow: PRESETS.RED)
		agreeButton.cornerRadius = 15
		self.addSubview(agreeButton)
	}
	
	// A BackButton is a button in the bottom right of the screen
	// Creates the button that allows the user to go back to the sickness screen
	func initBackButton() {
		backButton = PressableButton(frame: CGRect(x: buttonInShift, y: 3*self.frame.height/4 - buttonUpShift, width: self.frame.width/2 - 2*buttonInShift, height: self.frame.height/4 - 2*buttonInShift))
		backButton.setTitle("BACK", for: .normal)
		backButton.titleLabel?.font = PRESETS.FONT_BIG_BOLD
		backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
		backButton.cornerRadius = 15
		backButton.colors = .init(button: PRESETS.GRAY, shadow: PRESETS.GRAY)
		self.addSubview(backButton)
	}
	
	// Recieves the press from the back button and slides the disease selection screen to the right
	@objc func back(_ sender: UIButton?) {
		manager.back();
	}
	//Makes this view disapear and shows the person symptom selector
	// EFFECT: changes the X of this view, removes it from the view, and adds the symptom selector
	@objc func agreed(_ sender: UIButton?) {
		self.manager.initPersonSelector()
		UIView.animate(withDuration: 0.5, animations: {
			self.frame.origin.x -= self.frame.width
		})
	}

}
