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
	
	private var allSymptoms: Array<Int>!
	
	private var searchBar: UITextField!
	
	private var defaultSearch = "Type your Symptom..."
	
	init(frame: CGRect, canSelect: Array<Int>, selectOrView: Bool) {
		super.init(frame: frame)
		self.allSymptoms = canSelect
		self.selectOrView = selectOrView
		if(selectOrView) {
			self.initSearchBar()
		}
		self.changeSearch(search: "")

		self.isScrollEnabled = true
		self.alwaysBounceVertical = true
		self.autoresizingMask = UIViewAutoresizing.flexibleHeight
		self.contentSize = CGSize(width: self.frame.width, height: curY)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func initSearchBar() {
		searchBar = UITextField(frame: CGRect(x: 0, y: self.curY, width: self.frame.width, height: self.frame.height/10))
		searchBar.backgroundColor = PRESETS.CLEAR
		searchBar.textAlignment = .center
		searchBar.text = defaultSearch
		searchBar.clearsOnBeginEditing = true
		self.curY += searchBar.frame.height
		searchBar.addTarget(self, action: #selector(updateSearch), for: UIControlEvents.allEditingEvents)
		self.addSubview(searchBar)
	}
	
	//The reactor to editing the search bod
	//EFFECT: changes the symptoms displayed on the screen
	@objc func updateSearch(_ sender: UITextField?) {
		self.curY = sender!.frame.origin.y + sender!.frame.height
		self.changeSearch(search: sender!.text!)
	}
	
	func changeSearch(search: String) {
		let oldArray = self.symptoms
		for view in self.symptoms {
			view.removeFromSuperview()
		}
		self.symptoms = Array<IndivSymptomSelector>()
		for symptom in self.allSymptoms {
			if(search == "" || search == defaultSearch || DISEASE_QUESTIONS.QUESTION_DICT[symptom]!.lowercased().contains(search.lowercased())) {
				self.addSymptom(symID: symptom)
			}
		}
		for symptom in oldArray {
			if(symptom.isSelected()) {
				self.setChecked(symID: symptom.symID)
			}
		}
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
		let height = max(30, self.frame.height/7)
		let frame = CGRect(x: CGFloat(0), y: curY, width: self.frame.width, height: height)
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

private class IndivSymptomSelector: UIButton {
	
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
		title.isSelectable = false
		title.text = DISEASE_QUESTIONS.QUESTION_DICT[self.symID]
		title.backgroundColor = UIColor.clear
		self.addSubview(self.title)
	}
	
	func addDeleteButton() {
		deleteButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height))
		deleteButton.setImage(FileRW.readImage(imageName: "x.png"), for: .normal)
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
