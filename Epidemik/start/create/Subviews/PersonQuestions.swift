//
//  PersonQuestions.swift
//  Epidemik
//
//  Created by Ryan Bradford on 7/25/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class PersonQuestions: CreateItem {
	
	private var questions = Array<IndivQuestion>()
	private var curY = CGFloat(0.0)
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		self.title = "Check all that apply"
		self.addQuestion(question: "I smoke.")
		self.addQuestion(question: "I have hypertension.")
		self.addQuestion(question: "I have diabetes.")
		self.addQuestion(question: "I have high cholesterol.")
		self.addQuestion(question: "None of the above")
	}
	
	func addQuestion(question: String) {
		let toAdd = IndivQuestion(frame: CGRect(x: 0.0, y: curY, width: self.frame.width, height: self.frame.height/6), question: question)
		questions.append(toAdd)
		self.addSubview(toAdd)
		curY += self.frame.height/5
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	public override func getInfo() -> [String] {
		print(questions[3].isSelected())
		return [String(questions[0].isSelected()), String(questions[1].isSelected()), String(questions[2].isSelected()), String(questions[3].isSelected())]
	}
	
}

private class IndivQuestion: UIView {
	
	var checkbox: CheckBox!
	var question: String!
	
	init(frame: CGRect, question: String) {
		super.init(frame: frame)
		self.question = question
		self.initCheckbox()
		self.initTitle()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func initCheckbox() {
		self.checkbox = CheckBox(frame: CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height))
		self.addSubview(self.checkbox)
	}
	
	func initTitle() {
		let title = UITextView(frame: CGRect(x: self.frame.height, y: 0, width: self.frame.width - self.frame.height, height: self.frame.height))
		title.text = self.question
		title.isSelectable = false
		title.isEditable = false
		title.font = PRESETS.FONT_BIG
		self.addSubview(title)
	}
	
	func isSelected() -> Bool {
		return self.checkbox.isChecked
	}
	
}
