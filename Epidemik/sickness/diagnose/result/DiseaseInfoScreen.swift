//
//  DiseaseInfoScreen.swift
//  Epidemik
//
//  Created by Ryan Bradford on 7/24/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SwiftyButton

public class DiseaseInfoScreen: UIView {
	
	init(frame: CGRect, info: JSON?, userSymptoms: Array<Int>, percentage: Double) {
		super.init(frame: frame)
		self.initBlur()
		let toSetFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
		let toAdd = DiseaseInfoScroll(frame: toSetFrame, info: info, userSymptoms: userSymptoms, percentage: percentage)
		self.addSubview(toAdd)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}

public class DiseaseInfoScroll: UIScrollView {
	
	var curY = CGFloat(20)
	var insetX = CGFloat(30.0)
	
	// info extracted from the JSON
	var diseaseName: String!
	var symptomsMatched: Array<Int>!
	var medicinesRecomended: Array<String>!
	var medicalAttentionRecomended: Int!
	var diseaseDescription: String!
	
	var doneButton: PressableButton!
	
	init(frame: CGRect, info: JSON?, userSymptoms: Array<Int>, percentage: Double) {
		super.init(frame: frame)
		self.readJSON(result: info, symptoms: userSymptoms)
		self.initTitle(diseaseName: self.diseaseName)
		self.initWarning(percentage: percentage)
		self.initMedicalAttention(medicalAttention: self.medicalAttentionRecomended)
		self.initDescription(description: self.diseaseDescription)
		self.initMedicines(medicines: self.medicinesRecomended)
		self.initMatchingSymtoms(symptoms: self.symptomsMatched)
		self.initDone()
		self.isScrollEnabled = true
		self.autoresizingMask = UIViewAutoresizing.flexibleHeight
		self.contentSize = CGSize(width: self.frame.width, height: self.curY+10)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func readJSON(result: JSON?, symptoms: Array<Int>) {
		self.diseaseName = result!.dictionary!["disease_name"]!.string!
		self.symptomsMatched = DISEASE_QUESTIONS.getMatchingSymptoms(diseaseName: self.diseaseName, symptoms: symptoms)
		self.medicinesRecomended = Array<String>()
		let medicines = result!.dictionary!["medicines"]!
		for medicine in medicines.arrayValue {
			medicinesRecomended.append(medicine.string!)
		}
		self.medicalAttentionRecomended = result!.dictionary!["doctor"]!.int!
		self.diseaseDescription = result!.dictionary!["description"]!.string!
	}
	
	func initTitle(diseaseName: String) {
		let height = self.estimatedHeightOfLabel(text: diseaseName, width: self.frame.width, font: PRESETS.FONT_VERY_VERY_BIG!)
		let titleView = UITextView(frame: CGRect(x: 0, y: curY, width: self.frame.width, height: height))
		titleView.font = PRESETS.FONT_VERY_VERY_BIG
		titleView.text = diseaseName
		titleView.isEditable = false
		titleView.isSelectable = false
		titleView.isScrollEnabled = false
		titleView.textAlignment = .center
		titleView.backgroundColor = UIColor.clear
		self.addSubview(titleView)
		self.curY += titleView.frame.height
	}
	
	func initWarning(percentage: Double) {
		var warningText: String
		if(percentage > 0.5) {
			warningText = "High Evidence"
		} else if(percentage > 0.2) {
			warningText = "Moderate Evidence"
		} else {
			warningText = "Low Evidence"
		}
		
		let warningView = UITextView(frame: CGRect(x: 0, y: curY, width: self.frame.width, height: self.frame.height/18))
		warningView.font = PRESETS.FONT_VERY_BIG
		warningView.text = warningText
		warningView.isEditable = false
		warningView.isSelectable = false
		warningView.isScrollEnabled = false
		warningView.textAlignment = .center
		warningView.backgroundColor = UIColor.clear
		self.addSubview(warningView)
		self.curY += warningView.frame.height
	}
	
	func initMedicalAttention(medicalAttention: Int) {
		var warningText = "Medical Attention "
		var warningColor = UIColor.orange
		if(medicalAttention == 0) {
			warningText += "Mildly Recommended"
			warningColor = PRESETS.DARK_YELLOW
		} else if(medicalAttention == 1) {
			warningText += "Moderately Recommended"
			warningColor = UIColor.orange
		} else {
			warningText += "Strongly Recommended"
			warningColor = PRESETS.RED
		}
		let height = estimatedHeightOfLabel(text: warningText, width: self.frame.width, font: PRESETS.FONT_BIG!)
		let warningView = UITextView(frame: CGRect(x: 0, y: curY, width: self.frame.width, height: height))
		warningView.font = PRESETS.FONT_BIG
		warningView.isEditable = false
		warningView.isSelectable = false
		warningView.isScrollEnabled = false
		warningView.textAlignment = .center
		warningView.backgroundColor = UIColor.clear
		warningView.text = warningText
		warningView.textColor = warningColor
		warningView.frame = CGRect(x: 0, y: curY, width: self.frame.width, height: height)
		self.addSubview(warningView)
		self.curY += warningView.frame.height
	}
	
	func initDescription(description: String) {
		let descriptionTitleView = UITextView(frame: CGRect(x: 10, y: curY, width: self.frame.width-10, height: self.frame.height/20))
		descriptionTitleView.font = PRESETS.FONT_BIG_BOLD
		descriptionTitleView.text = "Description:"
		descriptionTitleView.isEditable = false
		descriptionTitleView.isSelectable = false
		descriptionTitleView.isScrollEnabled = false
		descriptionTitleView.textAlignment = .left
		descriptionTitleView.backgroundColor = UIColor.clear
		self.addSubview(descriptionTitleView)
		self.curY += descriptionTitleView.frame.height
		
		let height = estimatedHeightOfLabel(text: description, width: self.frame.width-20, font: PRESETS.FONT_BIG!)
		let descriptionView = UITextView(frame: CGRect(x: 20, y: curY, width: self.frame.width-20, height: height))
		descriptionView.font = PRESETS.FONT_BIG
		descriptionView.text = "• " + description
		descriptionView.isEditable = false
		descriptionView.isSelectable = false
		descriptionView.isScrollEnabled = false
		descriptionView.textAlignment = .left
		descriptionView.backgroundColor = UIColor.clear
		self.addSubview(descriptionView)
		self.curY += descriptionView.frame.height
	}
	
	func initMedicines(medicines: Array<String>) {
		let medicinesTitleView = UITextView(frame: CGRect(x: 10, y: curY, width: self.frame.width-10, height: self.frame.height/20))
		medicinesTitleView.font = PRESETS.FONT_BIG_BOLD
		medicinesTitleView.text = "Possible Medications:"
		medicinesTitleView.isEditable = false
		medicinesTitleView.isSelectable = false
		medicinesTitleView.isScrollEnabled = false
		medicinesTitleView.textAlignment = .left
		medicinesTitleView.backgroundColor = UIColor.clear
		self.addSubview(medicinesTitleView)
		self.curY += medicinesTitleView.frame.height
		
		for medicine in medicines {
			let medicineView = UITextView(frame: CGRect(x: 20, y: curY, width: self.frame.width-20, height: self.frame.height/20))
			medicineView.font = PRESETS.FONT_BIG
			medicineView.text = "• " + medicine
			medicineView.isEditable = false
			medicineView.isSelectable = false
			medicineView.isScrollEnabled = false
			medicineView.textAlignment = .left
			medicineView.backgroundColor = UIColor.clear
			self.addSubview(medicineView)
			self.curY += medicineView.frame.height
		}
	}
	
	func initMatchingSymtoms(symptoms: Array<Int>) {
		let symptomTitleView = UITextView(frame: CGRect(x: 10, y: curY, width: self.frame.width-10, height: self.frame.height/20))
		symptomTitleView.font = PRESETS.FONT_BIG_BOLD
		symptomTitleView.text = "Matching Symptoms:"
		symptomTitleView.isEditable = false
		symptomTitleView.isSelectable = false
		symptomTitleView.isScrollEnabled = false
		symptomTitleView.textAlignment = .left
		symptomTitleView.backgroundColor = UIColor.clear
		self.addSubview(symptomTitleView)
		self.curY += symptomTitleView.frame.height
		
		for symptom in symptoms {
			let symptomView = UITextView(frame: CGRect(x: 20, y: curY, width: self.frame.width-20, height: self.frame.height/20))
			symptomView.font = PRESETS.FONT_BIG
			symptomView.text = "• " + DISEASE_QUESTIONS.QUESTION_DICT[symptom]!
			symptomView.isEditable = false
			symptomView.isSelectable = false
			symptomView.isScrollEnabled = false
			symptomView.textAlignment = .left
			symptomView.backgroundColor = UIColor.clear
			self.addSubview(symptomView)
			self.curY += symptomView.frame.height
		}
	}
	
	func initDone() {
		let buttonHeight = self.frame.height/6
		let doneYCord = 11*self.frame.height/16 + buttonHeight/2
		doneButton = PressableButton(frame: CGRect(x: insetX, y: self.curY + 10, width: self.frame.width-2*insetX, height: buttonHeight))
		doneButton.accessibilityIdentifier = "done"
		doneButton.cornerRadius = 40
		doneButton.setTitle("Done", for: UIControlState.normal)
		doneButton.titleLabel?.font = PRESETS.FONT_BIG_BOLD
		doneButton.colors = .init(button: PRESETS.RED, shadow: PRESETS.RED)
		doneButton.addTarget(self, action: #selector(DiseaseInfoScroll.done(_:)), for: .touchUpInside)
		self.addSubview(doneButton)
		self.curY += doneButton.frame.height
	}
	
	@objc func done(_ sender: UIButton?) {
		UIView.animate(withDuration: 0.5, animations: {
			self.superview!.frame.origin.x += self.frame.width
		}, completion: {
			(value: Bool) in
			self.superview!.removeFromSuperview()
		})
	}
	
	
}
