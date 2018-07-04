//
//  DiseaseGraph.swift
//  Epidemik
//
//  Created by Ryan Bradford on 3/16/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class DiseaseGraph: UIView {
	//This class is simple a holder screen with a blur that
	//Holds the real graph (located below)
	
	var dates = Array<Date>()
	var weights = Array<Double>()
	var backButton: UIButton!
	var blur: UIVisualEffectView!
		
	var latitude: Double!
	var longitude: Double!

	//Inits this DiseaseGraph
	//OTHER: loads the blur to the background and begins to load the data
	init(frame: CGRect, diseaseName: String, latitude: Double, longitude: Double) {
		self.latitude = latitude
		self.longitude = longitude
		super.init(frame: frame)
		self.backgroundColor = PRESETS.CLEAR
		initBlur()
		myInitBlur()
		blur.frame = CGRect(x: 10, y: 50, width: self.frame.width - 20, height: 400)
		blur.layer.cornerRadius = 20
		blur.clipsToBounds = true
		loadData(diseaseName: diseaseName)
		addBackButton()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	//Loads the data for this disease in this users region
	//EFFECT: calls the processor when done which creates the graph
	func loadData(diseaseName: String) {
		NetworkAPI.getTrendsForDisease(latitude: latitude, longitude: longitude, diseaseName: diseaseName, result: processResponser)
	}
	
	//Turns the disease string into an array of disease points
	//EFFECT: draws the graph when done
	func processResponser(resp: JSON?) {
		for disease in resp!.arrayValue {
			print(disease)
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
			let dateString = disease["date"].string!
			let date = dateFormatter.date(from: dateString)
			let weight = disease["percent"].double
			dates.append(date!)
			weights.append(weight!)
		}
		DispatchQueue.main.sync {
			let drawing = DiseaseGraphDrawing(frame: CGRect(x: 10, y: 50, width: self.frame.width - 20, height: 400), dates: dates, weights: weights)
			self.addSubview(drawing)
		}
	}
	
	//Creates the back button
	//EFFECT: initalizes this back button and adds it to this UIView
	func addBackButton() {
		backButton = UIButton(frame: CGRect(x: 20, y: self.frame.height - 120, width: self.frame.width - 40, height: 100))
		backButton.setTitle("BACK", for: .normal)
		backButton.backgroundColor = PRESETS.RED
		backButton.titleLabel?.font = PRESETS.FONT_BIG_BOLD
		backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
		backButton.layer.cornerRadius = 15
		self.addSubview(backButton)
	}
	
	//The reactor function when the backbutton is pressed
	//EFFECT: takes this UIView off the screen
	@objc func back(_ sender: UIButton?) {
		UIView.animate(withDuration: 0.5, animations: {
			self.frame.origin.x += self.frame.width
		})
	}
	
	//Creates this blur
	//EFFECT: initalizes the blur on this Graph which is a class field
	func myInitBlur() {
		let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.prominent)
		blur = UIVisualEffectView(effect: blurEffect)
		//always fill the view
		blur.frame = CGRect(x: 0, y: -self.frame.height, width: self.frame.width, height: self.frame.height*5)
		blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.addSubview(blur) //if you have more UIViews, use an insertSubview API to place it where needed
	}
	
}

class DiseaseGraphDrawing: UIView {
	
	var dates: Array<Date>!
	var weights: Array<Double>!
	
	//Initalizes this graph
	//OTHER: sets the background color to clear
	init(frame: CGRect, dates: Array<Date>, weights: Array<Double>) {
		self.dates = dates
		self.weights = weights
		super.init(frame: frame)
		self.backgroundColor = PRESETS.CLEAR
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	//Draws this graph
	//EFFECT: puts a bunch of lines on the screen that represent this graph drawn
	override func draw(_ rect: CGRect) {
		if(dates.count == 0) {
			return
		}
		
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .center
		let attributes = [NSAttributedStringKey.paragraphStyle  :  paragraphStyle,
						  NSAttributedStringKey.font            :   PRESETS.FONT_SMALL!,
						  NSAttributedStringKey.foregroundColor : PRESETS.BLACK,] as [NSAttributedStringKey : Any]
		let attributes2 = [NSAttributedStringKey.paragraphStyle  :  paragraphStyle,
						  NSAttributedStringKey.font            :   PRESETS.FONT_BIG!,
						  NSAttributedStringKey.foregroundColor : PRESETS.BLACK,] as [NSAttributedStringKey : Any]
		
		let lineInset = CGFloat(40.0)
		let realWidth = self.frame.width - 2*lineInset
		let realHeight = self.frame.height - 2*lineInset
		
		let titleText = "Percent Sick"
		let titleAttText = NSAttributedString(string: titleText, attributes: attributes2)
		let titleRT = CGRect(x: 0, y: 20, width: self.frame.width, height: lineInset)
		titleAttText.draw(in: titleRT)
		
		let sickText = "100%"
		let sickAttText = NSAttributedString(string: sickText, attributes: attributes)
		let sickRT = CGRect(x: 0, y: lineInset, width: lineInset, height: lineInset)
		sickAttText.draw(in: sickRT)
		
		let healthyText = "0%"
		let healthyAttText = NSAttributedString(string: healthyText, attributes: attributes)
		let healthyRT = CGRect(x: 0, y: self.frame.height - lineInset - 10, width: lineInset, height: lineInset)
		healthyAttText.draw(in: healthyRT)
		
		let startDate = dates.first
		let endDate = dates.last
		let totalTime = endDate!.timeIntervalSince(startDate!)
		
		//Drawing the labels on the X Axis
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MMM-dd"
		
		let startString = dateFormatter.string(from: startDate!)
		let endString = dateFormatter.string(from: endDate!)
		
		let startAttText = NSAttributedString(string: startString, attributes: attributes)
		let startRT = CGRect(x: lineInset, y: self.frame.height - lineInset + 10, width: lineInset, height: lineInset)
		startAttText.draw(in: startRT)
		
		let endAttText = NSAttributedString(string: endString, attributes: attributes)
		let endRT = CGRect(x: self.frame.width - 2*lineInset, y: self.frame.height - lineInset + 10, width: lineInset, height: lineInset)
		endAttText.draw(in: endRT)
		
		// Drawing the axis of the graph
		let axisLine = UIBezierPath()
		axisLine.move(to: CGPoint(x: lineInset, y: lineInset))
		axisLine.addLine(to: CGPoint(x: lineInset, y:self.frame.height - lineInset))
		axisLine.addLine(to: CGPoint(x:self.frame.width - lineInset, y:self.frame.height - lineInset))
		PRESETS.BLACK.set()
		axisLine.lineWidth =  4
		axisLine.stroke()
		
		let graphLine = UIBezierPath()
		graphLine.lineJoinStyle = .bevel
		
		let firstWeight = weights.first
		let firstY = min(CGFloat(firstWeight!)*realHeight - lineInset, realHeight - lineInset)
		graphLine.move(to: CGPoint(x: lineInset,y: realHeight - firstY))
		for i in 1 ..< dates.count {
			let nextX = lineInset + realWidth * CGFloat(dates[i].timeIntervalSince(startDate!)) / CGFloat(totalTime)
			let nextY = min(CGFloat(weights[i])*realHeight - lineInset, realHeight - lineInset)
			graphLine.addLine(to: CGPoint(x: nextX, y: realHeight - nextY))
		}
		PRESETS.RED.set()
		graphLine.lineWidth = 2
		graphLine.stroke()
	}
	
}












