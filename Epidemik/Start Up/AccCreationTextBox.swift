//
//  AccCreationTextBox.swift
//  Epidemik
//
//  Created by Ryan Bradford on 3/14/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

class AccCreationTextBox: UITextField {
	//A standard textbox line for account creation
	//Has a image to the left and it underlines the whole thing
	
	var toDisplay: UIImage!
	
	//Inits this class
	//OTHER: sets some features of the textfield
	init(frame: CGRect, toDisplay: UIImage) {
		self.toDisplay = toDisplay
		super.init(frame: frame)
		self.backgroundColor = PRESETS.CLEAR
		self.autocorrectionType = .no
		self.autocapitalizationType = .none
		self.textAlignment = .center
		self.clearsOnBeginEditing = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	//Draws this UIView and places the image down
	override func draw(_ rect: CGRect) {		
		let underline = UIBezierPath()
		PRESETS.BLACK.set()
		let bumpUp = self.frame.height - 5.0
		underline.move(to: CGPoint(x: 0, y: bumpUp))
		underline.addLine(to: CGPoint(x: self.frame.width, y: bumpUp))
		underline.lineWidth = 2
		underline.stroke()
		
		let imageHeight = 3*self.frame.height / 4
		let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageHeight, height: imageHeight))
		imageView.image = toDisplay
		self.addSubview(imageView)
	}
	
}
