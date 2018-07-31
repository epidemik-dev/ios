//
//  TransitionControls.swift
//  Epidemik
//
//  Created by Ryan Bradford on 12/28/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit

open class TransitionControls: NSObject {
	//The class that represents the swipe controls that are possible
	
	var swipeLeft: UISwipeGestureRecognizer?
	var swipeRight: UISwipeGestureRecognizer?
	//The object that every view is added to
	var mainView: MainHolder
	
	//Inits the fields and creates the swipe controls
	init(mainView: MainHolder) {
		self.mainView = mainView
		super.init()
		self.initSwipeControl()
	}

	//Creates the swipe controls and their effect methods
	func initSwipeControl() {
		
		swipeLeft = UISwipeGestureRecognizer()
		swipeLeft!.addTarget(self, action: #selector(TransitionControls.transitionRight))
		swipeLeft!.direction = .left
		
		swipeRight = UISwipeGestureRecognizer()
		swipeRight!.addTarget(self, action: #selector(TransitionControls.transitionLeft))
		swipeRight!.direction = .right
		
		mainView.addGestureRecognizer(swipeLeft!)
		mainView.addGestureRecognizer(swipeRight!)
		mainView.isUserInteractionEnabled = true
	}
	
	//Transitions left if the gloabl trends view is displayed
	//EFFECT: moves the map to the center
	@objc func transitionLeft(sender: UIGestureRecognizer!) {
		mainView.endEditing(true)

		if mainView.trendsView.frame.origin.x == 0.0 && mainView.sicknessView.frame.origin.y != 0{
			mainView.transisitionToMap(nil)
		}
	}
	
	//Transitions right if the personal trends view is displayed
	//EFFECT: moves the map to the center
	@objc func transitionRight(sender: UIGestureRecognizer!) {
		mainView.endEditing(true)

		if mainView.personalTrends.frame.origin.x == 0.0 && mainView.sicknessView.frame.origin.y != 0 {
			mainView.transisitionToMap(nil)
		}
	}

}

