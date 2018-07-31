//
//  BadVersionScreen.swift
//  Epidemik
//
//  Created by Ryan Bradford on 4/19/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

class BadVersionScreen: UIView {
	//The screen that is displayed when there is a invalid version (or the server goes down)
	
	//Inits this class and sets the text
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = PRESETS.WHITE
		let textView = UITextView(frame: CGRect(x: 10, y: self.frame.height/4, width: self.frame.width-20, height:  self.frame.height/4))
		textView.text = "This Version is No Longer Supported. Please Update the App from the App Store"
		textView.font = PRESETS.FONT_BIG_BOLD
		textView.textAlignment = .center
		self.addSubview(textView)
		addLogo()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	//Puts the logo at the top
	func addLogo() {
		let toAdd = UIImageView(frame: CGRect(x: self.frame.width/2 - self.frame.height / 8, y: self.frame.height/2, width: self.frame.height / 4, height: self.frame.height / 4))
		toAdd.image = FileRW.readImage(imageName: "epidemik.png")
		self.addSubview(toAdd)
	}
	
}
