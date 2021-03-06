//
//  UIViewExtension.swift
//  Epidemik
//
//  Created by Ryan Bradford on 3/4/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	
	//Will add a blur as a foreground to any UIView object
	func initBlur(blurType: UIBlurEffectStyle) {
		let blurEffect = UIBlurEffect(style: blurType)
		let blur = UIVisualEffectView(effect: blurEffect)
		//always fill the view
		blur.frame = self.bounds
		blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.addSubview(blur) //if you have more UIViews, use an insertSubview API to place it where needed
	}
	
	func initBlur() {
		self.initBlur(blurType: UIBlurEffectStyle.regular)
	}
	
	func estimatedHeightOfLabel(text: String, width: CGFloat, font: UIFont) -> CGFloat {
		
		let size = CGSize(width: width, height: 1000)
		
		let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
		
		let attributes = [kCTFontAttributeName: font]
		
		let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes as [NSAttributedStringKey : Any], context: nil).height
		
		return rectangleHeight+20
	}
	
}
