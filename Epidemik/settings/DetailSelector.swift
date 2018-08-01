//
//  DetailSelector.swift
//  Epidemik
//
//  Created by Ryan Bradford on 12/13/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class DetailSelector: BarSelector {
	// The bar for selecting detail on the map
	
	var map: Map!
	
	let base = 20.0
	let totalVariability = 30.0
	
	//Creates this detail selector with the fields
	//Draws the bar at a the base ration
	init(frame: CGRect, map: Map) {
		self.map = map
		super.init(frame: frame)
		self.updateBar(ratio: self.getRatio())
	}
	
	//The function called when the bar is pressed
	//EFFECT: updates the numLong and numLat on the OverlayCreator
	@objc override func update(sender:UIGestureRecognizer) -> CGFloat {
		let ratio = super.update(sender: sender)
		map.overlayCreator.numLong = Double(CGFloat(base)+CGFloat(totalVariability)*ratio)
		map.overlayCreator.numLat = Double(CGFloat(base)+CGFloat(totalVariability)*ratio)
		map.updateOverlays()
		return ratio
	}
	
	//Returns the ratio given the one set on the map
	func getRatio() -> CGFloat {
		return CGFloat((map.overlayCreator.numLong-base)/totalVariability)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}
