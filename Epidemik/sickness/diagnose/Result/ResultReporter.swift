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
		self.initResults(results: results!)
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
		let toAdd = ResultItem(frame: CGRect(x: self.frame.width/10, y: curY, width: self.frame.width-5, height: self.frame.height/12), diseaseName: diseaseName, percentage: probability)
		resultItems.append(toAdd)
		toAdd.addTarget(self, action: #selector(ResultReporter.showDetails(_:)), for: .touchUpInside)
		self.addSubview(toAdd)
		curY += toAdd.frame.height*2
	}
	
	func initDoneButton() {
		let buttonHeight = self.frame.height/6
		let doneYCord = 5*self.frame.height/8 + buttonHeight/2
		doneButton = PressableButton(frame: CGRect(x: insetX, y: doneYCord, width: self.frame.width-2*insetX, height: buttonHeight))
		doneButton.accessibilityIdentifier = "DoneButton"
		doneButton.cornerRadius = 40
		doneButton.setTitle("Done", for: UIControlState.normal)
		doneButton.titleLabel?.font = PRESETS.FONT_BIG_BOLD
		doneButton.colors = .init(button: PRESETS.RED, shadow: PRESETS.RED)
		doneButton.addTarget(self, action: #selector(ResultReporter.done(_:)), for: .touchUpInside)
		self.addSubview(doneButton)
	}
	
	@objc func done(_ sender: UIButton?) {
		manager.done()
	}
	
	@objc func showDetails(_ sender: UIButton?) {
		var diseaseName = sender!.accessibilityIdentifier!
		diseaseName = diseaseName.replacingOccurrences(of: " ", with: "-")
		percentage = (sender as! ResultItem).percentage
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

private class ResultItem: UIButton {
	
	var diseaseName: String!
	var percentage: Double!
	
	init(frame: CGRect, diseaseName: String, percentage: Double) {
		super.init(frame: frame)
		self.diseaseName = diseaseName
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
		let nameTitle = UITextView(frame: CGRect(x: self.frame.height, y: 0, width: self.frame.width - self.frame.height - self.frame.width/3, height: self.frame.height/2))
		nameTitle.text = diseaseName
		nameTitle.backgroundColor = UIColor.clear
		nameTitle.font = PRESETS.FONT_BIG
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
