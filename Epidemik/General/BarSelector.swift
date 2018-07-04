//
//  BarSelector.swift
//  Epidemik
//
//  Created by Ryan Bradford on 12/13/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class BarSelector: UIButton {
	//A general selector for selecting between two ranges
	
	//The bar that is moved
	var colorFrame: UIView!
	
	//Initizes this class with the given frame
	//OTHER: inits and draws the color frame, rounds its edges, and adds the gesture recognizer
	override public init(frame: CGRect) {
		super.init(frame: frame)
		colorFrame = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
		colorFrame.backgroundColor = PRESETS.RED
		self.addSubview(colorFrame)
		
		self.backgroundColor = PRESETS.WHITE
		self.layer.cornerRadius = 20
		colorFrame.layer.cornerRadius = 20
		
		let longGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.update(sender:)));
		longGestureRecognizer.minimumPressDuration = 0
		longGestureRecognizer.allowableMovement = 5
		self.addGestureRecognizer(longGestureRecognizer)
		
	}
	
	//Updates the color frame with the new ratio and returns the ratio
	//EFFECT: changes the frame of the color frame
	@objc func update(sender:UIGestureRecognizer) -> CGFloat {
		var newWidth = sender.location(in: self).x
		if(newWidth > self.frame.width) {
			newWidth = self.frame.width
		} else if(newWidth < 0) {
			newWidth = 0
		}		
		let ratio = newWidth / self.frame.width
		updateBar(ratio: ratio)
		return ratio
	}
	
	//Sets the color frame to display the given ratio
	//EFFECT: changes the color frame
	func updateBar(ratio: CGFloat) {
		colorFrame.frame = CGRect(x: 0, y: 0, width: ratio*self.frame.width, height: self.frame.height)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}

