//
//  DiagnosisManager.swift
//  Epidemik
//
//  Created by Ryan Bradford on 7/17/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

class DiagnosisManager: UIView {
	
	var tosView: DataTermsOfService!
	var personSelector: PersonSymptomSelector!
	var superScreen: SicknessView!
	
	init(frame: CGRect, superScreen: SicknessView) {
		super.init(frame: frame)
		self.superScreen = superScreen
		self.initBlur()
		self.initTOS()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// Adds the TOS view to this view
	// Begins with an x of 0
	func initTOS() {
		self.tosView = DataTermsOfService(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), manager: self)
		self.addSubview(self.tosView)
	}
	
	// Adds the person symptom selector to the view
	// slides it onto the screen
	func initPersonSelector() {
		var frame = self.frame
		frame.origin.x = self.frame.width
		self.personSelector = PersonSymptomSelector(frame: frame, manager: self)
		self.addSubview(self.personSelector)
		UIView.animate(withDuration: 0.5, animations: {
			self.personSelector.frame.origin.x -= self.personSelector.frame.width
		})
	}
	
	// Goes back without submitting anything
	func back() {
		superScreen.addSubview(superScreen.diagnoseButton)
		superScreen.addSubview(superScreen.sicknessButton)
		UIView.animate(withDuration: 0.5, animations: {
			self.frame.origin.x -= self.frame.width
			self.superScreen.sicknessButton.frame.origin.x += self.frame.width
			self.superScreen.diagnoseButton.frame.origin.x += self.frame.width
		})
	}
	
}

