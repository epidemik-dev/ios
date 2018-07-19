//
//  ResultReporter.swift
//  Epidemik
//
//  Created by Ryan Bradford on 7/13/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ResultReporter: UIView {
	
	var totalProbability = 0.0
	var curY: CGFloat!
	var doneButton: UIButton!
	var manager: DiagnosisManager!
	var insetX = CGFloat(30.0)
	
	init(frame: CGRect, results: JSON?, manager: DiagnosisManager) {
		super.init(frame: frame)
		self.curY = 3*self.frame.height/16
		self.manager = manager
		self.initBlur()
		self.initResults(results: results!)
		self.initDoneButton()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func initResults(results: JSON) {
		let array = results.arrayValue
		for result in array {
			totalProbability += result["probability"].double!
		}
		
		for i in 0..<min(3, results.count) {
			addResult(diseaseName: array[i]["disease_name"].string!, probability: array[i]["probability"].double!)
		}
	}
	
	func addResult(diseaseName: String, probability: Double) {
		let toAdd = ResultItem(frame: CGRect(x: 0, y: curY, width: self.frame.width, height: self.frame.height/6), diseaseName: diseaseName, percentage: probability)
		self.addSubview(toAdd)
		curY += toAdd.frame.height
	}
	
	func initDoneButton() {
		let buttonHeight = self.frame.height/6
		let doneYCord = 5*self.frame.height/8 + buttonHeight/2
		doneButton = UIButton(frame: CGRect(x: insetX, y: doneYCord, width: self.frame.width-2*insetX, height: buttonHeight))
		doneButton.accessibilityIdentifier = "DoneButton"
		doneButton.layer.cornerRadius = 40
		doneButton.setTitle("Done", for: UIControlState.normal)
		doneButton.titleLabel?.font = PRESETS.FONT_BIG_BOLD
		doneButton.backgroundColor = PRESETS.RED
		doneButton.addTarget(self, action: #selector(ResultReporter.done(_:)), for: .touchUpInside)
		self.addSubview(doneButton)
	}
	
	@objc func done(_ sender: UIButton?) {
		manager.done()
	}
	
}

private class ResultItem: UIView {
	
	var diseaseName: String!
	var percentage: Double!
	
	init(frame: CGRect, diseaseName: String, percentage: Double) {
		super.init(frame: frame)
		self.diseaseName = diseaseName
		self.percentage = percentage
		self.displayWarning(percentage: percentage)
		self.displayTitle(diseaseName: diseaseName)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func displayWarning(percentage: Double) {
		var iconColor: UIColor
		var warningText: String
		if(percentage > 0.5) {
			iconColor = UIColor.green
			warningText = "High Evidence"
		} else if(percentage > 0.2) {
			iconColor = UIColor.yellow
			warningText = "Moderate Evidence"
		} else {
			iconColor = UIColor.red
			warningText = "Low Evidence"
		}
		let icon = UITextView(frame: CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height))
		icon.backgroundColor = iconColor
		icon.text = String(percentage)
		self.addSubview(icon)
		
		let warningView = UITextView(frame: CGRect(x: self.frame.height, y: self.frame.height/2, width: self.frame.width - self.frame.height, height: self.frame.height/2))
		warningView.text = warningText
		self.addSubview(warningView)
	}
	
	func displayTitle(diseaseName: String) {
		let nameTitle = UITextView(frame: CGRect(x: self.frame.height, y: 0, width: self.frame.width - self.frame.height, height: self.frame.height/2))
		nameTitle.text = diseaseName
		self.addSubview(nameTitle)
	}
	
	
	
}
