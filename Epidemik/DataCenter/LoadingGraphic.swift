//
//  LoadingGraphic.swift
//  Epidemik
//
//  Created by Ryan Bradford on 3/18/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

class LoadingGraphic: UIView {
	//A loading graphic that has the logo and a spinning ring around it
	
	var mainImage: UIImageView!
	var animateImage: UIImageView!
	
	var shouldContinue = true
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initMainImage()
		initAnimateImage()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	//Inits the main image for the loading graphic
	//EFFECT: creates the mainImage as a UIImageVIew
	func initMainImage() {
		let toAdd = FileRW.readImage(imageName: "epidemik.png")
		self.mainImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
		self.mainImage.image = toAdd
		self.addSubview(self.mainImage)
		
	}
	
	//Inits the spinning ring that spins around
	//EFFECT: creates the animateImage as a UIImageView
	func initAnimateImage() {
		let toAdd = FileRW.readImage(imageName: "loading.png")
		self.animateImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
		self.animateImage.image = toAdd
		self.addSubview(self.animateImage)
	}
	
	//Begins to spin the ring
	//EFFECT: animates the ring on a loop that restarts until shouldContinue is false
	func startAnimation() {
		UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
			self.animateImage.transform = self.animateImage.transform.rotated(by: .pi)
		}) { finished in
			if(self.shouldContinue) {
				self.startAnimation()
			} else {
				UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
					self.frame.origin.x -= 1000
				})
			}
		}
	}
	
	//EFFECT: sets should continut to false
	func stopAnimation() {
		self.shouldContinue = false
	}
	
}
