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

	//The number values of all questions for this disease questinair
	var questions = Array<Int>()
	
	var symptomSelector: SymptomSelector!
	
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
		initDoneButton()
		initSelector()
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
	func initSelector() {
		//var frame = CGRect(x: self.blur.frame.origin.x, y: self.blur.frame.origin.y, width: self.blur.frame.width, height: self.blur.frame.origin.x)
		//frame.height -= 20
		symptomSelector = SymptomSelector(frame: CGRect(x: 30, y: 100, width: self.frame.width-60, height: 4*self.frame.height/8), canSelect: self.questions, selectOrView: true)
		self.addSubview(symptomSelector)
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
		let symptomsToReport = self.symptomSelector.getSelectedSymptoms()
		if(self.superScreen?.title != nil) {
			self.superScreen!.title.text = "You Are Currently Sick"
		}
		NetworkAPI.setSick(username: FileRW.readFile(fileName: "username.epi")!, diseaseName: self.disease_name, symptoms: symptomsToReport)
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
	
	
}
