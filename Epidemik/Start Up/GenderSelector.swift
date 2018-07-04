//
//  GenderSelector.swift
//  Epidemik
//
//  Created by Ryan Bradford on 4/19/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

class GenderSelector: UIView {
	//The UIView object for selecting the gender of a user
	
	//The tree checkboxes
	//STRUCTURAL INTEGRITY: only one is checked at a time
	var maleSelector: CheckBox!
	var femaleSelector: CheckBox!
	var otherSelector: CheckBox!
	
	var textHeight = CGFloat(20.0)
	var textWidth = CGFloat(40)
	
	//Creates this class and creates the textboxes + their labels
	override init(frame: CGRect) {
		super.init(frame: frame)
		initCheckBoxes()
		initTextBoxes()
	}
	
	//Makes the checkboxes and adds the target to the method
	//EFFECT: overwrite and recreates the checkboxes
	func initCheckBoxes() {
		maleSelector = CheckBox(frame: CGRect(x: 0, y: 0, width: self.frame.height - textHeight, height: self.frame.height - textHeight))
		maleSelector.accessibilityIdentifier = "MaleButton"
		maleSelector.addTarget(self, action: #selector(GenderSelector.genderChanged(_:)), for: .touchUpInside)
		self.addSubview(maleSelector)
		femaleSelector = CheckBox(frame: CGRect(x: self.frame.width/2 - (self.frame.height - textHeight)/2, y: 0, width: self.frame.height - textHeight, height: self.frame.height - textHeight))
		femaleSelector.accessibilityIdentifier = "FemaleButton"
		femaleSelector.addTarget(self, action: #selector(GenderSelector.genderChanged(_:)), for: .touchUpInside)
		self.addSubview(femaleSelector)
		otherSelector = CheckBox(frame: CGRect(x: self.frame.width - (self.frame.height - textHeight), y: 0, width: self.frame.height - textHeight, height: self.frame.height - textHeight))
		otherSelector.accessibilityIdentifier = "OtherButton"
		otherSelector.addTarget(self, action: #selector(GenderSelector.genderChanged(_:)), for: .touchUpInside)
		self.addSubview(otherSelector)
	}
	
	//Creates the checkbox labels
	//EFFECT: adds the labels to the UIView
	func initTextBoxes() {
		let maleTextbox = UITextView(frame: CGRect(x: 0, y: self.frame.height - textHeight, width: textWidth, height: textHeight))
		maleTextbox.font = PRESETS.FONT_SMALL
		maleTextbox.text = "Male"
		maleTextbox.textAlignment = .left
		maleTextbox.isEditable = false
		maleTextbox.isSelectable = false
		maleTextbox.backgroundColor = PRESETS.CLEAR
		self.addSubview(maleTextbox)
		
		let femaleTextbox = UITextView(frame: CGRect(x: self.frame.width/2 - (textWidth)/2, y: self.frame.height - textHeight, width: textWidth, height: textHeight))
		femaleTextbox.font = PRESETS.FONT_SMALL
		femaleTextbox.text = "Female"
		femaleTextbox.textAlignment = .center
		femaleTextbox.isEditable = false
		femaleTextbox.isSelectable = false
		femaleTextbox.backgroundColor = PRESETS.CLEAR
		self.addSubview(femaleTextbox)
		
		let otherTextbox = UITextView(frame: CGRect(x: self.frame.width - textWidth, y: self.frame.height - textHeight, width: textWidth, height: textHeight))
		otherTextbox.font = PRESETS.FONT_SMALL
		otherTextbox.text = "Other"
		otherTextbox.textAlignment = .right
		otherTextbox.isEditable = false
		otherTextbox.isSelectable = false
		otherTextbox.backgroundColor = PRESETS.CLEAR
		self.addSubview(otherTextbox)
	}
	
	//Returns the title of which checkbox is checked
	func getGender() -> String {
		if(maleSelector.isChecked) {
			return "Male"
		}
		if(femaleSelector.isChecked) {
			return "Female"
		}
		if(otherSelector.isChecked) {
			return "Other"
		}
		return "Did Not Choose"
	}
	
	//What is called when any checkbox is check
	//EFFECT: unchecks every checkbox and then check this one
	//Updates all the images
	@objc func genderChanged(_ sender: UIButton?) {
		maleSelector.isChecked = false
		femaleSelector.isChecked = false
		otherSelector.isChecked = false

		(sender as! CheckBox).isChecked = true
		
		maleSelector.updateImage()
		femaleSelector.updateImage()
		otherSelector.updateImage()

	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}
