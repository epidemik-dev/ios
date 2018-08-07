//
//  AgeSelector.swift
//  Epidemik
//
//  Created by Ryan Bradford on 7/26/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

class AgeSelector: CreateItem {
	
	var selector: ScrollSelector!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.title = "How old are you?"
		self.backgroundColor = PRESETS.WHITE
		var toDisplay = Array<String>()
		toDisplay.append("< 12 Months")
		for i in 1..<120 {
			toDisplay.append(String(i) + " years old")
		}
		
		selector = ScrollSelector(frame: CGRect(x: self.frame.width/5, y: 0, width: 3*self.frame.width/5, height: self.frame.height), items: toDisplay)
		self.addSubview(selector)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func getInfo() -> [String] {
		if(self.selector.currentTextField?.text == "< 12 Months") {
			return ["0 years old"]
		} else {
			return [self.selector.currentTextField!.text!]
		}
	}
	
}
