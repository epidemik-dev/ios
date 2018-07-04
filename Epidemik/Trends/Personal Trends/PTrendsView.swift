//
//  PTrendsView.swift
//  Epidemik
//
//  Created by Ryan Bradford on 2/20/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class PTrendsView: UIScrollView {

	var dataCenter: DataCenter!
	var blur: UIVisualEffectView!
	
	//
	var baseY = CGFloat(60)
	var totalY = CGFloat(60)
	var gap = CGFloat(20.0)
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.baseY = self.frame.height / 10
		self.totalY = self.baseY
		self.isScrollEnabled = true
		self.alwaysBounceVertical = true
		self.autoresizingMask = UIViewAutoresizing.flexibleHeight
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// The function that is called when the data center is done loading
	// EFFECTT: adds the blur to the view, initalizes the pull to refresh controls
	// Puts the title at the top, loads all the trend data
	func displayTrends() {
		for subview in self.subviews {
			subview.removeFromSuperview()
		}
		myInitBlur()
		initPullToRefresh()
		initLabel()
		tellSicknessPerYear()
		tellAverageTimeSick()
		tellMostCommonTimeSick()
		drawGraph()
		self.contentSize = CGSize(width: self.frame.width, height: self.totalY)
	}
	
	//Removes all the trends and updates them
	func updateTrends() {
		for view in self.subviews {
			view.removeFromSuperview()
		}
		self.dataCenter.loadGlobalTrendData()
	}
	
	//Draws the graph of sickness over time
	func drawGraph() {
		let toAdd = SicknessGraph(frame: CGRect(x:0, y:0, width: self.frame.width - 60, height: self.frame.height/3), personData: self.dataCenter.getPersonalTrendData().getDatapoints())
		addItemOnBlur(item: toAdd)
	}
	
	//Tells how many times per year you get sick
	//EFFEFCT: adds the view to the trend screen
	func tellSicknessPerYear() {
		let text = "You are sick for an average of \n" + String(dataCenter.getPersonalTrendData().getSicknessPerYear()) + " times per year"
		let toDisplay = Trend(toDisplay: text)
		let uiForm = toDisplay.getUIView(width: Double(self.frame.width))
		uiForm.frame.origin.y = self.totalY + 20.0
		self.totalY += uiForm.frame.height + 20.0
		self.addSubview(uiForm)
	}
	
	//Tells how long you are usually sick for
	//EFFECT: adds the view to the trend screen
	func tellAverageTimeSick() {
		let text = "You are sick for an average of \n" + String(dataCenter.getPersonalTrendData().getAverageLengthSickInDays()) + " days at a time"
		let toDisplay = Trend(toDisplay: text)
		let uiForm = toDisplay.getUIView(width: Double(self.frame.width))
		uiForm.frame.origin.y = self.totalY + 20.0
		self.totalY += uiForm.frame.height + 20.0
		self.addSubview(uiForm)
	}
	
	//Tells when you are usually sick
	//EFFECT: adds the view to the trend view
	func tellMostCommonTimeSick() {
		let toUse = dataCenter.getPersonalTrendData().getAverageDateSick()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMMM"
		let text = "You usually get sick in " + dateFormatter.string(from: toUse)
		let toDisplay = Trend(toDisplay: text)
		let uiForm = toDisplay.getUIView(width: Double(self.frame.width))
		uiForm.frame.origin.y = self.totalY + 20.0
		self.totalY += uiForm.frame.height + 20.0
		self.addSubview(uiForm)
	}
	
	//Adds the given item on top of a UIBlur
	func addItemOnBlur(item: UIView) {
		let rect = CGRect(x: self.frame.width/2 - (item.frame.width + 20)/2, y: totalY + 20, width: item.frame.width + 20, height: item.frame.height + 20)
		item.frame = CGRect(x: 10, y: 10, width: item.frame.width, height: item.frame.height)
		let graphBackground = UIView(frame: rect)
		graphBackground.initBlur(blurType: UIBlurEffectStyle.prominent)
		graphBackground.layer.cornerRadius = CGFloat(rect.height/8)
		graphBackground.clipsToBounds = true
		graphBackground.addSubview(item)
		self.totalY += graphBackground.frame.height + 20
		self.addSubview(graphBackground)
	}
	
	//Initalizes the blur background to this view
	func myInitBlur() {
		let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
		blur = UIVisualEffectView(effect: blurEffect)
		//always fill the view
		blur.frame = CGRect(x: 0, y: -self.frame.height, width: self.frame.width, height: self.frame.height*5)
		blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.addSubview(blur) //if you have more UIViews, use an insertSubview API to place it where needed
	}
	
	// Turns on pull to refresh controls
	func initPullToRefresh() {
		refreshControl = UIRefreshControl()
		refreshControl!.addTarget(self, action: #selector(PTrendsView.updateData(_:)), for: UIControlEvents.valueChanged)
		self.addSubview(refreshControl!)
	}
	
	//The reactor to the pull to refresh
	//EFFECT: reloads all the data
	@objc func updateData(_ sender: UIButton?) {
		self.totalY = baseY
		refreshControl!.endRefreshing()
		dataCenter.loadPersonalTrendData()
	}
	
	//Create the title lable
	//EFFECT: adds it to the view
	func initLabel() {
		let toAdd = UILabel(frame: CGRect(x: 50, y: 20, width: self.frame.width - 100, height: 50))
		toAdd.text = "Personal Trends"
		toAdd.font = PRESETS.FONT_BIG_BOLD
		toAdd.textAlignment = .center
		self.addSubview(toAdd)
	}
	
}
