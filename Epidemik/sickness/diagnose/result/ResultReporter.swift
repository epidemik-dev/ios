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
import SwiftyButton

class ResultReporter: UIView {
	
	var totalProbability = 0.0
	var curY: CGFloat!
	var doneButton: PressableButton!
	var addButton: PressableButton!
	var manager: DiagnosisManager!
	var insetX = CGFloat(30.0)
	private var resultItems = Array<ResultItem>()
	
	var userSymptoms: Array<Int>!
	var percentage: Double!
	
	init(frame: CGRect, results: JSON?, manager: DiagnosisManager, userSymptoms: Array<Int>) {
		super.init(frame: frame)
		self.curY = 3*self.frame.height/16
		self.userSymptoms = userSymptoms
		self.manager = manager
		self.initBlur()
		self.initTitle()
		if(results == nil || results!.count == 0) {
			self.initNoResults()
		} else {
			self.initResults(results: results!)
			self.initAddButton()
		}
		self.initDoneButton()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func initTitle() {
		let title = UITextView(frame: CGRect(x: 0, y: 20, width: self.frame.width, height: self.curY))
		title.text = "Results"
		title.textAlignment = .center
		title.font = PRESETS.FONT_VERY_VERY_BIG
		title.backgroundColor = UIColor.clear
		title.isSelectable = false
		title.isEditable = false
		self.addSubview(title)
	}
	
	func initNoResults() {
		let title = UITextView(frame: CGRect(x: 40, y: self.curY + 20, width: self.frame.width-80, height: 100))
		title.text = "Sorry, there was not enough information to diagnose you."
		title.textAlignment = .center
		title.font = PRESETS.FONT_VERY_BIG
		title.backgroundColor = UIColor.clear
		title.accessibilityIdentifier = "noinfo"
		title.isSelectable = false
		title.isEditable = false
		self.addSubview(title)
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
		let toAdd = ResultItem(frame: CGRect(x: self.frame.width/15, y: curY, width: self.frame.width-5, height: self.frame.height/10), diseaseName: diseaseName, percentage: probability)
		resultItems.append(toAdd)
		toAdd.button.addTarget(self, action: #selector(ResultReporter.showDetails(_:)), for: .touchUpInside)
		self.addSubview(toAdd)
		curY = curY + CGFloat(toAdd.frame.height*2)
	}
	
	func initAddButton() {
		let buttonHeight = self.frame.height/6
		let doneYCord = 5*self.frame.height/8 + buttonHeight/2
		addButton = PressableButton(frame: CGRect(x: self.frame.width/2+insetX, y: doneYCord, width: self.frame.width/2-2*insetX, height: buttonHeight))
		addButton.accessibilityIdentifier = "add_to_map"
		addButton.cornerRadius = 40
		addButton.setTitle("Add To Map", for: UIControlState.normal)
		addButton.titleLabel?.font = PRESETS.FONT_BIG_BOLD
		addButton.colors = .init(button: PRESETS.RED, shadow: PRESETS.RED)
		addButton.addTarget(self, action: #selector(ResultReporter.done(_:)), for: .touchUpInside)
		self.addSubview(addButton)
	}
	
	func initDoneButton() {
		let buttonHeight = self.frame.height/6
		let doneYCord = 5*self.frame.height/8 + buttonHeight/2
		doneButton = PressableButton(frame: CGRect(x: insetX, y: doneYCord, width: self.frame.width/2-2*insetX, height: buttonHeight))
		doneButton.accessibilityIdentifier = "exit"
		doneButton.cornerRadius = 40
		doneButton.setTitle("Delete", for: UIControlState.normal)
		doneButton.titleLabel?.font = PRESETS.FONT_BIG_BOLD
		doneButton.colors = .init(button: PRESETS.GRAY, shadow: PRESETS.GRAY)
		doneButton.addTarget(self, action: #selector(ResultReporter.removeFromMap(_:)), for: .touchUpInside)
		self.addSubview(doneButton)
	}
	
	@objc func done(_ sender: UIButton?) {
		manager.amNowSick()
		if(self.manager.superScreen?.title != nil) {
			self.manager.superScreen!.title.text = "You Are Currently Sick"
		}
	}
	
	@objc func removeFromMap(_ sender: UIButton?) {
		NetworkAPI.deleteHealthy(username: FileRW.readFile(fileName: "username.epi")!, callback: self.processResult)
		manager.back()
	}
	
	func processResult(result: JSON?) {
	}
	
	@objc func showDetails(_ sender: UIButton?) {
		var diseaseName = sender!.accessibilityIdentifier!
		diseaseName = diseaseName.replacingOccurrences(of: " ", with: "-")
		percentage = (sender as! ResultItemButton).percentage
		NetworkAPI.getDiseaseInfo(diseaseName: diseaseName, callback: displayDiseaseInformation)
	}
	
	func displayDiseaseInformation(info: JSON?) {
		DispatchQueue.main.sync {
			let frame = CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height)
			let toDisplay = DiseaseInfoScreen(frame: frame, info: info, userSymptoms: userSymptoms, percentage: percentage)
			self.addSubview(toDisplay)
			UIView.animate(withDuration: 0.5, animations: {
				toDisplay.frame.origin.x -= self.frame.width
			})
		}
		
	}
	
}

private class ResultItem: UIView {
	
	var button: ResultItemButton!
	var percentage: Double!
	
	init(frame: CGRect, diseaseName: String, percentage: Double) {
		super.init(frame: frame)
		self.initBlur(blurType: .extraLight)
		self.percentage = percentage
		self.layer.cornerRadius = 10
		self.clipsToBounds = true
		button = ResultItemButton(frame: CGRect(x: 10, y: 2, width: self.frame.width - 10, height: self.frame.height-4), diseaseName: diseaseName, percentage: percentage)
		self.addSubview(button)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}

private class ResultItemButton: UIButton {
	
	var diseaseName: String!
	var percentage: Double!
	
	init(frame: CGRect, diseaseName: String, percentage: Double) {
		super.init(frame: frame)
		self.diseaseName = diseaseName
		self.backgroundColor = UIColor.clear
		self.accessibilityIdentifier = diseaseName
		self.percentage = percentage
		self.displayWarning(percentage: percentage)
		self.displayTitle(diseaseName: diseaseName)
		self.initArrow()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func displayWarning(percentage: Double) {
		var warningText: String
		if(percentage > 0.5) {
			warningText = "High Evidence"
		} else if(percentage > 0.2) {
			warningText = "Moderate Evidence"
		} else {
			warningText = "Low Evidence"
		}
		let icon = PercentageViewer(frame: CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height), percentage: percentage)
		self.addSubview(icon)
		
		let warningView = UITextView(frame: CGRect(x: self.frame.height, y: self.frame.height/2, width: self.frame.width - self.frame.height - self.frame.width/4, height: self.frame.height/2))
		warningView.text = warningText
		warningView.backgroundColor = UIColor.clear
		warningView.font = PRESETS.FONT_MEDIUM
		warningView.isEditable = false
		warningView.isSelectable = false
		self.addSubview(warningView)
	}
	
	func displayTitle(diseaseName: String) {
		let nameTitle = UITextView(frame: CGRect(x: self.frame.height, y: 0, width: self.frame.width - self.frame.height - self.frame.width/3, height: 7*self.frame.height/12))
		nameTitle.text = diseaseName
		nameTitle.backgroundColor = UIColor.clear
		nameTitle.font = PRESETS.FONT_BIG
		nameTitle.scrollRangeToVisible(NSRange(location: 0, length: 100))
		nameTitle.isSelectable = false
		nameTitle.isEditable = false
		self.addSubview(nameTitle)
	}
	
	func initArrow() {
		let arrowImage = FileRW.readImage(imageName: "arrow")
		let arrowView = UIImageView(frame: CGRect(x: 2*self.frame.width/3, y: 0, width: self.frame.width/5, height: self.frame.height))
		arrowView.image = arrowImage
		self.addSubview(arrowView)
	}
	
}

private class PercentageViewer: UIView {
	
	var percentage: Double!
	
	init(frame: CGRect, percentage: Double) {
		super.init(frame: frame)
		self.percentage = percentage
		self.backgroundColor = UIColor.clear
	}
	
	override func draw(_ rect: CGRect) {
		let width = self.frame.width - 5
		let height = self.frame.height - 5
		let circlePath = UIBezierPath(arcCenter: CGPoint(x: width/2,y: height/2), radius: CGFloat(width/2), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
		
		let shapeLayer = CAShapeLayer()
		shapeLayer.path = circlePath.cgPath
		
		//change the fill color
		let color: CGColor
		if(percentage > 0.5) {
			color = UIColor.red.cgColor
		} else if(percentage > 0.2) {
			color = UIColor.orange.cgColor
		} else {
			color = UIColor.green.cgColor
		}
		shapeLayer.fillColor = UIColor.clear.cgColor
		shapeLayer.strokeColor = color
		shapeLayer.lineWidth = 3.0
		
		self.layer.addSublayer(shapeLayer)
		
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .center
		
		let attributes = [
			NSAttributedStringKey.paragraphStyle: paragraphStyle,
			NSAttributedStringKey.font: PRESETS.FONT_BIG_BOLD,
			NSAttributedStringKey.foregroundColor: UIColor.blue
		]
		
		let textToDraw = String(Int(round(percentage*100))) + "%"
		let textRect = CGRect(x: 0, y: self.frame.height/4, width: self.frame.width, height: self.frame.height/2)

		
		let attributedString = NSAttributedString(string: textToDraw, attributes: attributes as [NSAttributedStringKey : Any])
		
		attributedString.draw(in: textRect)
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}
