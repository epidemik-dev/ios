//
//  DiseaseQuestionair.swift
//  Epidemik
//
//  Created by Ryan Bradford on 3/24/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class DiseaseQuestionair: UIView {
	
	//The disease name of this quesitonair
	var disease_name: String!
	//The sickness screen that this one was created from
	var superScreen: SicknessView?
	//The done button to submit
	var doneButton: UIButton!
	//The x cordinate that everything is pushed in by
	var insetX = CGFloat(30.0)
	//The blur view
	var blur: UIVisualEffectView!

	//The number values of all questions for this disease questinair
	var questions = Array<Int>()
	
	//The checkboxes that cordinate to every disease question
	//Have a field ID that says which question it points to
	var checkBoxes = Array<CheckBox>()
	
	//Initalizes this View with these fields
	//Creates the blur for the background
	//Creates a blur as the background for the questions
	//Adds the questions
	public init(frame: CGRect, disease_name: String, superScreen: SicknessView?) {
		super.init(frame: frame)
		self.accessibilityIdentifier = "DiseaseQuestionair"
		self.disease_name = disease_name
		self.superScreen = superScreen
		self.questions = DISEASE_QUESTIONS.getDiseaseQuestions(diseaseName: disease_name)
		initBlur()
		myInitBlur()
		blur.frame = CGRect(x: 30, y: 100, width: self.frame.width-60, height: 4*self.frame.height/8)
		blur.layer.cornerRadius = 20
		blur.clipsToBounds = true
		initDoneButton()
		initSelectors()
		initTitle()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	//Creates a title that shows what to do
	//EFFECT: adds the title and subtitle to the View
	func initTitle() {
		let title = UILabel(frame: CGRect(x: 20, y: 20, width: self.frame.width - 40, height: 60))
		title.text = "Testing Your Sickness"
		title.font = PRESETS.FONT_BIG_BOLD
		title.textAlignment = .center
		self.addSubview(title)
		
		let checkAllThatApply = UILabel(frame: CGRect(x: 20, y: 60, width: self.frame.width - 40, height: 20))
		checkAllThatApply.text = "(check all symptoms that apply)"
		checkAllThatApply.font = PRESETS.FONT_MEDIUM
		checkAllThatApply.textAlignment = .center
		self.addSubview(checkAllThatApply)
	}
	
	//Creates the selectors
	//EFFECT: resets the selector array and adds the checkboxes and lables to the view
	func initSelectors() {
		checkBoxes = Array<CheckBox>()
		var yPos = 120
		for question in self.questions {
			let checkbox = CheckBox(frame: CGRect(x: 40, y: yPos, width: 40, height: 40), id: question)
			checkBoxes.append(checkbox)
			let textBox = UILabel(frame: CGRect(x: 100, y: yPos, width: Int(self.frame.width - CGFloat(60)), height: 40))
			textBox.text = DISEASE_QUESTIONS.QUESTION_DICT[question]
			textBox.font = PRESETS.FONT_BIG
			self.addSubview(textBox)
			self.addSubview(checkbox)
			yPos += 60
		}
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
		doneButton.addTarget(self, action: #selector(DiseaseQuestionair.amDone(_:)), for: .touchUpInside)
		self.addSubview(doneButton)
	}
	
	//What is called when the done button is pressed
	//EFFECT: reports to the server the symptoms selected, and the disease report
	//Changes the title of the sickness screen
	//Makes this screen go away
	@objc func amDone(_ sender: UIButton?) {
		var symptomsToReport = Array<Int>()
		for checkbox in self.checkBoxes {
			if(checkbox.isChecked) {
				symptomsToReport.append(checkbox.id)
			}
		}
		if(self.superScreen?.title != nil) {
			self.superScreen!.title.text = "You Are Currently Sick"
		}
		Reporting.amSick(diseaseName: self.disease_name, symptoms: symptomsToReport)
		submit()
	}
	
	
	//Makes this screen go away and adds the healthy button again
	//EFFECT: shifts this x to the left, and the healthy button x to the left
	//Removes this view when the animation is done
	func submit() {
		UIView.animate(withDuration: 0.5, animations: {
			self.frame.origin.x -= self.frame.width
			if(self.superScreen != nil) {
				self.superScreen!.healthyButton.frame.origin.x -= self.frame.width
			}
		}, completion: {
			(value: Bool) in
			self.removeFromSuperview()
		})
	}
	
	//Initalizes the blur field of this class
	//EFFECT: creates the blur field of this class
	//Also makes it way longer than it needs to be (in the Y direction) for scrolling purposes
	func myInitBlur() {
		let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.prominent)
		blur = UIVisualEffectView(effect: blurEffect)
		//always fill the view
		blur.frame = CGRect(x: 0, y: -self.frame.height, width: self.frame.width, height: self.frame.height*5)
		blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.addSubview(blur) //if you have more UIViews, use an insertSubview API to place it where needed
	}
	
	
	
}
