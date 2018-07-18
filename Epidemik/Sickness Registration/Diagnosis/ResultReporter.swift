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
	
	init(frame: CGRect, results: JSON?) {
		super.init(frame: frame)
		self.initBlur()
		self.initResults(results: results!)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func initResults(results: JSON) {
		
	}
	
	func addTopResult(disease_name: String, probability: Double) {
		
	}
	
	func addSecondResult(disease_name: String, probability: Double) {
		
	}
	
	func addThirdResult(disease_name: String, probability: Double) {
		
	}
	
}
