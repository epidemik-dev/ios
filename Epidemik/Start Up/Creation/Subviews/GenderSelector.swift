//
//  GenderSelector.swift
//  Epidemik
//
//  Created by Ryan Bradford on 4/19/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

class GenderSelector: CreateItem {
	
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
		self.title = "Check your gender"
		initCheckBoxes()
		initTextBoxes()
	}
	
	//Makes the checkboxes and adds the target to the method
	//EFFECT: overwrite and recreates the checkboxes
	func initCheckBoxes() {
		let height = self.frame.height/5
		maleSelector = CheckBox(frame: CGRect(x: 10, y: 10, width: height, height: height))
		maleSelector.accessibilityIdentifier = "MaleButton"
		maleSelector.addTarget(self, action: #selector(GenderSelector.genderChanged(_:)), for: .touchUpInside)
		self.addSubview(maleSelector)
		femaleSelector = CheckBox(frame: CGRect(x: 10, y: self.frame.height/2 - height/2, width: height, height: height))
		femaleSelector.accessibilityIdentifier = "FemaleButton"
		femaleSelector.addTarget(self, action: #selector(GenderSelector.genderChanged(_:)), for: .touchUpInside)
		self.addSubview(femaleSelector)
		otherSelector = CheckBox(frame: CGRect(x: 10, y: self.frame.height - height, width: height, height: height))
		otherSelector.accessibilityIdentifier = "OtherButton"
		otherSelector.addTarget(self, action: #selector(GenderSelector.genderChanged(_:)), for: .touchUpInside)
		self.addSubview(otherSelector)
		otherSelector.isChecked = true
		otherSelector.updateImage()
	}
	
	//Creates the checkbox labels
	//EFFECT: adds the labels to the UIView
	func initTextBoxes() {
		let height = self.frame.height/5
		let textInset = height + 10
		let maleTextbox = UITextView(frame: CGRect(x: textInset, y: 10, width: self.frame.width - textInset, height: height))
		maleTextbox.font = PRESETS.FONT_VERY_VERY_BIG
		maleTextbox.text = "Male"
		maleTextbox.textAlignment = .left
		maleTextbox.isEditable = false
		maleTextbox.isSelectable = false
		maleTextbox.backgroundColor = PRESETS.CLEAR
		self.addSubview(maleTextbox)
		
		let femaleTextbox = UITextView(frame: CGRect(x: textInset, y: self.frame.height/2 - height/2, width: self.frame.width - textInset, height: height))
		femaleTextbox.font = PRESETS.FONT_VERY_VERY_BIG
		femaleTextbox.text = "Female"
		femaleTextbox.textAlignment = .left
		femaleTextbox.isEditable = false
		femaleTextbox.isSelectable = false
		femaleTextbox.backgroundColor = PRESETS.CLEAR
		self.addSubview(femaleTextbox)
		
		let otherTextbox = UITextView(frame: CGRect(x: textInset, y: self.frame.height - height, width: self.frame.width - textInset, height: height))
		otherTextbox.font = PRESETS.FONT_VERY_VERY_BIG
		otherTextbox.text = "Other"
		otherTextbox.textAlignment = .left
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
	
	override func getInfo() -> [String] {
		return [self.getGender()]
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
