//
//  SymptomSelector.swift
//  Epidemik
//
//  Created by Ryan Bradford on 7/18/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class SymptomSelector: UIView {
	
	private var symptomSelector: SymptomSelectorScroller!
	
	init(frame: CGRect, canSelect: Array<Int>, selectOrView: Bool) {
		super.init(frame: frame)
		self.initBlur(blurType: UIBlurEffectStyle.extraLight)
		self.layer.cornerRadius = 20
		self.clipsToBounds = true
		let frame = CGRect(x: 10, y: 10, width: self.frame.width-20, height: self.frame.height-20)
		symptomSelector = SymptomSelectorScroller(frame: frame, canSelect: canSelect, selectOrView: selectOrView)
		self.addSubview(symptomSelector)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func getSelectedSymptoms() -> Array<Int> {
		return symptomSelector.getSelectedSymptoms()
	}
	
	func getUnselectedSymptoms() -> Array<Int> {
		return symptomSelector.getUnselectedSymptoms()
	}
	
	func setChecked(symID: Int) {
		self.symptomSelector.setChecked(symID: symID)
	}
	
	func removeSymptom(symID: Int) {
		self.symptomSelector.removeSymptomView(symID: symID)
	}
	
	func addSymptom(symID: Int) {
		self.symptomSelector.addSymptom(symID: symID)
	}
	
}

private class SymptomSelectorScroller: UIScrollView {
	
	private var symptoms = Array<IndivSymptomSelector>()
	private var curY = CGFloat(0)
	private var selectOrView: Bool!
	
	init(frame: CGRect, canSelect: Array<Int>, selectOrView: Bool) {
		super.init(frame: frame)
		self.selectOrView = selectOrView
		for symptom in canSelect {
			self.addSymptom(symID: symptom)
		}
		self.isScrollEnabled = true
		self.alwaysBounceVertical = true
		self.autoresizingMask = UIViewAutoresizing.flexibleHeight
		self.contentSize = CGSize(width: self.frame.width, height: curY)
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func removeSymptomView(symID: Int) {
		var height: CGFloat? = nil
		var i = 0;
		while i < symptoms.count {
			let symptom = symptoms[i]
			if(symptom.symID == symID) {
				height = symptom.frame.height
				symptom.removeFromSuperview()
				symptoms.remove(at: i)
				self.curY -= height!
				i = i - 1
			} else if(height != nil) {
				symptom.frame.origin.y -= height!
			}
		 	i += 1
		}
	}
	
	func addSymptom(symID: Int) {
		for symptom in symptoms {
			if(symptom.symID == symID) {
				return
			}
		}
		let frame = CGRect(x: CGFloat(0), y: curY, width: self.frame.width, height: self.frame.height/5)
		let toAdd = IndivSymptomSelector(frame: frame, symID: symID, selectOrView: selectOrView, removeFunc: removeSymptomView)
		symptoms.append(toAdd)
		self.addSubview(toAdd)
		curY += toAdd.frame.height
		self.contentSize = CGSize(width: self.frame.width, height: curY)
		self.flashScrollIndicators()

	}
	
	func getSelectedSymptoms() -> Array<Int> {
		var toReturn = Array<Int>()
		for symView in symptoms {
			if(symView.isSelected()) {
				toReturn.append(symView.symID)
			}
		}
		return toReturn
 	}
	
	func getUnselectedSymptoms() -> Array<Int> {
		var toReturn = Array<Int>()
		for symView in symptoms {
			if(!symView.isSelected()) {
				toReturn.append(symView.symID)
			}
		}
		return toReturn
	}
	
	func setChecked(symID: Int) {
		for symptom in symptoms {
			if(symptom.symID == symID) {
				symptom.setChecked();
			}
		}
	}
	
}

private class IndivSymptomSelector: UIView {
	
	var removeFunc: ((Int) -> ())!
	var symID: Int!
	var selector: CheckBox!
	var title: UITextView!
	
	var deleteButton: UIButton!
	
	init(frame: CGRect, symID: Int, selectOrView: Bool, removeFunc: @escaping ((Int) -> ())) {
		super.init(frame: frame)
		self.removeFunc = removeFunc
		self.symID = symID
		
		addTitle()
		if(selectOrView) { // We want the symptoms to be selectable
			addSelector()
		} else { // We want the symptoms to be deletable
			addDeleteButton()
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func addSelector() {
		selector = CheckBox(frame: CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height))
		self.addSubview(selector)
	}
	
	func addTitle() {
		title = UITextView(frame: CGRect(x: self.frame.height, y: 0, width: self.frame.width - self.frame.height, height: self.frame.height))
		title.isEditable = false
		title.text = DISEASE_QUESTIONS.QUESTION_DICT[self.symID]
		title.backgroundColor = UIColor.clear
		self.addSubview(self.title)
	}
	
	func addDeleteButton() {
		deleteButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height))
		deleteButton.backgroundColor = UIColor.red
		deleteButton.addTarget(self, action: #selector(IndivSymptomSelector.deleteSelf(_:)), for: .touchUpInside)
		self.addSubview(deleteButton)
	}
	
	@objc func deleteSelf(_ sender: UIButton?) {
		removeFunc(self.symID)
	}
	
	func isSelected() -> Bool {
		return self.selector == nil || self.selector.isChecked
	}
	
	func setChecked() {
		self.selector.isChecked = true
		self.selector.updateImage()
	}
	
}
