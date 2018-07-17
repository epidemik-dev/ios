//
//  DataTermsOfService.swift
//  Epidemik
//
//  Created by Ryan Bradford on 7/13/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

class DataTermsOfService: UIView {

	var tosText: UITextView!
	var agreeButton: UIButton!
	var backButton: UIButton!
	var manager: DiagnosisManager!
	//Where the buttons are placed on the screen
	let buttonInShift = CGFloat(25.0)
	let buttonUpShift = CGFloat(20.0)
	
	
	init(frame: CGRect, manager: DiagnosisManager) {
		super.init(frame: frame)
		self.initTOSText()
		self.initAgreeButton()
		self.initBackButton()
		self.manager = manager
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// Adds the text that says the TOS to the view
	// EFFECT: inits and adds the TOS text to the view
	func initTOSText() {
		self.tosText = UITextView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height/5))
		self.tosText.text = "These are Terms of Service"
		self.addSubview(self.tosText)
	}
	
	// A SendButton is a button in the bottom right of the screen
	// Creates the button that allows the user to send their sickness data to the server
	func initAgreeButton() {
		agreeButton = UIButton(frame: CGRect(x: self.frame.width/2+buttonInShift, y: 3*self.frame.height/4 - buttonUpShift, width: self.frame.width/2-2*buttonInShift, height: self.frame.height/4-2*buttonInShift))
		agreeButton.accessibilityIdentifier = "AgreeButton"
		agreeButton.setTitle("AGREE", for: .normal)
		agreeButton.titleLabel?.font = PRESETS.FONT_BIG_BOLD
		agreeButton.backgroundColor = PRESETS.RED
		agreeButton.addTarget(self, action: #selector(agreed), for: .touchUpInside)
		agreeButton.layer.cornerRadius = 15
		self.addSubview(agreeButton)
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
	//Makes this view disapear and shows the person symptom selector
	// EFFECT: changes the X of this view, removes it from the view, and adds the symptom selector
	@objc func agreed(_ sender: UIButton?) {
		self.manager.initPersonSelector()
		UIView.animate(withDuration: 0.5, animations: {
			self.frame.origin.x -= self.frame.width
		})
	}

}