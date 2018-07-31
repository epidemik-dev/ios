//
//  DropDown.swift
//  Epidemik
//
//  Created by Ryan Bradford on 7/30/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class DropDownSelector: UIButton {
	
	var items: Array<String>!
	var title: String!
	var curSelected: Int!
	
	var displays: Array<UILabel>!
	
	var curY: CGFloat!
	
	var isExpanded = false
	var initialHeight: CGFloat!
	
	var update: (() -> ())!
	
	public init(frame: CGRect, items: Array<String>, title: String, update: @escaping (() -> ())) {
		super.init(frame: frame)
		self.initialHeight = frame.height
		self.items = items
		self.title = title
		self.update = update
		self.curSelected = 0
		self.curY = 0
		self.displays = Array<UILabel>()
		self.clipsToBounds = true
		self.addItem(text: title)
		self.addItem(text: "All")
		self.displays[1].backgroundColor = PRESETS.RED
		for item in items {
			self.addItem(text: item)
		}
		self.addTarget(self, action:
			#selector(DropDownSelector.expand), for: .touchUpInside)
	}
	
	//Shows the graph of this disease over time
	//EFFECT: brings up a new UIView that displays on the main ViewController
	@IBAction func expand(sender: AnyObject, event: UIEvent) {
		if(isExpanded) {
			let touches = event.touches(for: self)
			let touch = touches!.first!
			self.displays![curSelected].backgroundColor = PRESETS.WHITE
			self.curSelected = Int(floor(touch.location(in: self).y / self.initialHeight))
			self.displays![curSelected].backgroundColor = PRESETS.RED
			self.update()
			UIView.animate(withDuration: 0.5, animations: {
				self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height * CGFloat(1)/CGFloat(self.displays.count))
			})
		} else {
			UIView.animate(withDuration: 0.5, animations: {
				self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height * CGFloat(self.displays.count))
			})
		}
		isExpanded = !isExpanded
	}
	
	func addItem(text: String) {
		let toAdd = UILabel(frame: CGRect(x: 0, y: self.curY, width: self.frame.width, height: self.frame.height))
		toAdd.text = text
		toAdd.textAlignment = .center
		toAdd.backgroundColor = PRESETS.WHITE
		toAdd.layer.borderColor = PRESETS.BLACK.cgColor
		toAdd.layer.borderWidth = 2
		self.addSubview(toAdd)
		self.curY += self.frame.height
		self.displays.append(toAdd)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func getSelected() -> String? {
		let toReturn = self.displays[curSelected]
		if(toReturn.text == self.title || toReturn.text == "All") {
			return nil
		} else {
			print(toReturn.text)
			return toReturn.text
		}
	}
	
}
