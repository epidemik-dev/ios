//
//  WeightHeightSelector.swift
//  Epidemik
//
//  Created by Ryan Bradford on 7/26/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

class WeightHeightSelector: CreateItem {
	
	var weightSelector: ScrollSelector!
	var heightSelector: ScrollSelector!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.title = "What is your weight/height?"
		self.backgroundColor = PRESETS.WHITE
		
		var weights = Array<String>()
		for i in 50..<400 {
			weights.append(String(i) + " lbs")
		}
		
		weightSelector = ScrollSelector(frame: CGRect(x: 0, y: 0, width: self.frame.width/2, height: self.frame.height), items: weights)
		self.addSubview(weightSelector)
		
		var heights = Array<String>()
		for feet in 3..<9 {
			for inches in 0 ..< 12 {
				heights.append(String(feet) + "'" + String(inches) + "\"")
			}
		}
		
		heightSelector = ScrollSelector(frame: CGRect(x: self.frame.width/2, y: 0, width: self.frame.width/2, height: self.frame.height), items: heights)
		self.addSubview(heightSelector)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func getInfo() -> [String] {
		return [self.weightSelector.currentTextField!.text!, self.heightSelector.currentTextField!.text!]
	}
	
}
