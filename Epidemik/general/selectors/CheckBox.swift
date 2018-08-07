//
//  CheckBox.swift
//  Epidemik
//
//  Created by Ryan Bradford on 3/24/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

class CheckBox: UIButton {
	// Images
	let checkedImage = FileRW.readImage(imageName: "checked") as UIImage
	let uncheckedImage = FileRW.readImage(imageName: "unchecked") as UIImage
	
	// Bool property
	var isChecked: Bool = false
	
	var id: Int!
	
	//Creates a checkbox with this frame
	//OTHER: sets the image to the unchecked image
	override init(frame: CGRect) {
		self.id = 0
		super.init(frame: frame)
		self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
		self.isChecked = false
		self.setImage(uncheckedImage, for: UIControlState.normal)
	}
	
	//Creates a checkbox with this frame and sets the id to id
	//OTHER: sets the image to the unchecked image
	convenience init(frame: CGRect, id: Int) {
		self.init(frame: frame)
		self.id = id
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	//The function called when the checkbox is clicked
	//EFFECT: reverses the image and the isChecked boolean
	@objc func buttonClicked(sender: UIButton) {
		if sender == self {
			isChecked = !isChecked
		}
		updateImage()
		self.window?.rootViewController?.view?.endEditing(true)
	}
	
	//Updates the image based on what is checked is set to
	//EFFECT: changes the image
	func updateImage() {
		if(isChecked) {
			self.setImage(checkedImage, for: UIControlState.normal)
		} else {
			self.setImage(uncheckedImage, for: UIControlState.normal)
		}
	}
}
