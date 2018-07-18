//
//  BodyPartSymptomSelector.swift
//  Epidemik
//
//  Created by Ryan Bradford on 7/13/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

class BodyPartSymptomSelector: UIView {
	
	var doneButton: UIButton!
	var insetX = CGFloat(30.0)
	
	var bodyPartImage: UIView!
	var symptomSelector: SymptomSelector!
	var partName: String!
	var done: ((BodyPartSymptomSelector) -> ())!
	
	init(frame: CGRect, partName: String, done: @escaping ((BodyPartSymptomSelector) -> ()), currentSymptoms: Array<Int>) {
		super.init(frame: frame)
		self.partName = partName
		self.done = done
		initBlur()
		initDoneButton()
		initImage()
		initTitle()
		initSelector()
		for symptom in currentSymptoms {
			self.symptomSelector.setChecked(symID: symptom)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// Adds the drop down symptom selector the view
	func initSelector() {
		let y = self.bodyPartImage.frame.origin.y + self.bodyPartImage.frame.height + 20
		symptomSelector = SymptomSelector(frame: CGRect(x: 20, y: y, width: self.frame.width-20, height: self.frame.height/2), canSelect: DISEASE_QUESTIONS.getBodyPartQuestions(bodyPart: self.partName), selectOrView: true)
		self.addSubview(symptomSelector)
	}
	
	// Adds the body part image to the top of the view
	func initImage() {
		let xInset = CGFloat(150)
		self.bodyPartImage = UIView(frame: CGRect(x: xInset, y: 10, width: self.frame.width-2*xInset, height:  self.frame.width-2*xInset))
		self.bodyPartImage.backgroundColor = UIColor.blue
		self.addSubview(self.bodyPartImage)
	}
	
	// Adds the title to the top of the view
	func initTitle() {
		
	}
	
	//Creates the done button
	//EFFECT: initalizes the field doneButton and adds it to the UIView
	func initDoneButton() {
		let buttonHeight = self.frame.height/6
		let doneYCord = 5*self.frame.height/8 + buttonHeight/2
		doneButton = UIButton(frame: CGRect(x: insetX, y: doneYCord, width: self.frame.width-2*insetX, height: buttonHeight))
		doneButton.accessibilityIdentifier = "DoneButton"
		doneButton.layer.cornerRadius = 40
		doneButton.setTitle("Done", for: UIControlState.normal)
		doneButton.titleLabel?.font = PRESETS.FONT_BIG_BOLD
		doneButton.backgroundColor = PRESETS.RED
		doneButton.addTarget(self, action: #selector(BodyPartSymptomSelector.done(_:)), for: .touchUpInside)
		self.addSubview(doneButton)
	}
	
	// When the user is done adding symptoms from this body part
	@objc func done(_ sender: UIButton?) {
		done(self)
		UIView.animate(withDuration: 0.5, animations: {
			self.frame.origin.x -= self.frame.width
		})
	}
	
	func symptomRemoved(symID: Int) {
		
	}
	
	func getSelectedSymptoms() -> Array<Int> {
		return self.symptomSelector.getSelectedSymptoms()
	}
	
	func getUnselectedSymptoms() -> Array<Int> {
		return self.symptomSelector.getUnselectedSymptoms()
	}
	
	
}
