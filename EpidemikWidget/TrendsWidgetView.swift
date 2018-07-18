//
//  TrendsWidgetView.swift
//  EpidemikWidget
//
//  Created by Ryan Bradford on 12/17/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import SwiftyJSON

public class TrendsWidgetView: UIScrollView {
	
	var trends = Array<Trend>()
	var realTrends = Array<Trend>()
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		getAddressInfo()
		self.isScrollEnabled = true
		self.autoresizingMask = UIViewAutoresizing.flexibleHeight
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func getAddressInfo() {
		let username = FileRW.readFile(fileName: "username.epi")
		getTrends(username: username!)
	}
	
	func getTrends(username: String) {
		NetworkAPI.getAllTrendData(username: username, result: { (response: JSON?) -> () in
			DispatchQueue.main.sync {
				self.processTrends(json_trends: response!)
			}
		})
	}
	
	func processTrends(json_trends: JSON) {
		for trend in json_trends.arrayValue {
			let disease_name = trend["disease_name"].string!
			let weight = trend["trend_weight"].double!
			let currentTrend = Trend(name: disease_name, weight: weight, width: Double(self.frame.width))
			trends.append(currentTrend)
		}
		filterOnlyTop3()
		if realTrends.count == 0 {
			realTrends.append(Trend(name: Trend.nothing, weight: 0, width: Double(self.frame.width)))
		}
		displayTrends()
	}
	
	func displayTrends() {
		let startShift = CGFloat(0.0)
		for i in 0 ..< realTrends.count {
			let toDisplay = realTrends[i]
			toDisplay.frame.origin.y = CGFloat(i) * (6.0/5.0*toDisplay.frame.height) + startShift
			self.addSubview(toDisplay)
		}
		if(realTrends.count > 0) {
			self.contentSize = CGSize(width: self.frame.width, height: (realTrends.last?.frame.origin.y)! + (realTrends.last?.frame.height)!)
		}
	}
	
	func filterOnlyTop3() {
		trends.sort(by: {trend0,trend1 in
			trend0.weight > trend1.weight
		})
		realTrends = Array<Trend>()
		if trends.count < 3 {
			realTrends = trends
		} else {
			realTrends = [trends[0],trends[1],trends[2]]
		}
	}
	
}
