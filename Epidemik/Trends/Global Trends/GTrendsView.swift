//
//  TrendsView.swift
//  Epidemik
//
//  Created by Ryan Bradford on 11/8/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class GTrendsView: UIScrollView {
	
	// The datacenter that stores the trend data
	var dataCenter: DataCenter!
	//The blur effect that goes behind this whole window
	var blur: UIVisualEffectView!
	//All the trends that will be displayed
	var trendDisplays: Array<UIView> = Array<UIView>()
	
	// Initalizes this window
	//OTHER: loads the blur, show the title, and begins pull to refresh controls
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.isScrollEnabled = true
		self.alwaysBounceVertical = true
		self.autoresizingMask = UIViewAutoresizing.flexibleHeight
		myInitBlur()
		initLabel()
		initPullToRefresh()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	//Displays a all the trends (is called when the DataCenter is done loading)
	//EFFECT: adds all the trend displays to the UIView and sorts them by weight
	func displayTrends() {
		var trends = dataCenter.getGlobalTrendData()
		trends.sort(by: { (a: Trend, b: Trend) -> Bool in
			return a.weight > b.weight
		})
		let startShift = self.frame.height / 6
		var lastY = CGFloat(0.0)
		for i in 0 ..< trends.count {
			let toDisplay = trends[i].getUIView(width: Double(self.frame.width))
			toDisplay.frame.origin.y = CGFloat(i) * (6.0/5.0*toDisplay.frame.height) + startShift
			self.addSubview(toDisplay)
			lastY = CGFloat(i) * (6.0/5.0*toDisplay.frame.height)
			lastY += startShift + 2*toDisplay.frame.height
			trendDisplays.append(toDisplay)
		}
		if(trends.count > 0) {
			self.contentSize = CGSize(width: self.frame.width, height: lastY)
		}
	}
	
	//Reloads all the trends
	//EFFECT: removes every trends and calls the loader
	func updateTrends() {
		for view in self.subviews {
			view.removeFromSuperview()
		}
		self.dataCenter.loadGlobalTrendData()
	}
	
	//Enables pull to refresh controls
	func initPullToRefresh() {
		refreshControl = UIRefreshControl()
		refreshControl!.addTarget(self, action: #selector(GTrendsView.updateData(_:)), for: UIControlEvents.valueChanged)
		self.addSubview(refreshControl!)
	}
	
	//called when the user pulls to refresh
	@objc func updateData(_ sender: UIButton?) {
		refreshControl!.endRefreshing()
		dataCenter.loadGlobalTrendData()
	}
	
	//Removes the trends and resets the array
	func removeAllCurrentTrends() {
		for view in trendDisplays {
			view.removeFromSuperview()
		}
		trendDisplays = Array<UIView>()
	}
	
	//Inits the blur background that goes behind the whole screen
	func myInitBlur() {
		let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
		blur = UIVisualEffectView(effect: blurEffect)
		//always fill the view
		blur.frame = CGRect(x: 0, y: -self.frame.height, width: self.frame.width, height: self.frame.height*5)
		blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		
		self.addSubview(blur) //if you have more UIViews, use an insertSubview API to place it where needed
	}
	
	
	//Inits the title
	func initLabel() {
		let toAdd = UILabel(frame: CGRect(x: 50, y: 20, width: self.frame.width - 100, height: 50))
		toAdd.text = "Local Trends"
		toAdd.font = PRESETS.FONT_BIG_BOLD
		toAdd.textAlignment = .center
		self.addSubview(toAdd)
	}
	
	
}
