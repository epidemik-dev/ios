//
//  AddressCreator.swift
//  Epidemik
//
//  Created by Ryan Bradford on 4/20/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

class AddressCreator: UIView, UITextFieldDelegate {
	//The UIView that holds all the address creation textboxes
	
	// The image that goes to the left
	var toDisplay: UIImage!
	
	//The three checkboxes
	var addressBox: UITextField!
	var cityBox: UITextField!
	var stateBox: UITextField!
	
	var accCreationView: LoginScreen!

	//Inits this class and creates the checkboxes
	init(frame: CGRect, toDisplay: UIImage, accCreationView: LoginScreen) {
		self.toDisplay = toDisplay
		self.accCreationView = accCreationView
		super.init(frame: frame)
		self.backgroundColor = PRESETS.CLEAR
		initBoxes()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	//Sets all the delegates of the textbox
	//EFFECT: updates the delegate fields of every textbox
	func setDelegate(toSetAs: UITextFieldDelegate) {
		addressBox.delegate = toSetAs
		cityBox.delegate = toSetAs
	}
	
	//Returns the address that this person lives at
	//FORMAT: Address City, State
	func getAddress() -> String {
		return addressBox.text! + " " + cityBox.text! + ", " + stateBox.text!
	}
	
	//Creates all the textboxes
	//EFFECT: updates all the fields and adds them to the UIView
	func initBoxes() {
		addressBox = UITextField(frame: CGRect(x: self.frame.height/3, y: 0, width: self.frame.width, height: self.frame.height/3))
		addressBox.autocorrectionType = .no
		addressBox.autocapitalizationType = .none
		addressBox.text = "Address"
		addressBox.clearsOnBeginEditing = true
		addressBox.textAlignment = .left
		addressBox.accessibilityIdentifier = "AddressTextBox"
		self.addSubview(addressBox)
		
		cityBox = UITextField(frame: CGRect(x: self.frame.height/3, y: self.frame.height/3, width: self.frame.width, height: self.frame.height/3))
		cityBox.autocorrectionType = .no
		cityBox.autocapitalizationType = .none
		cityBox.text = "City"
		cityBox.clearsOnBeginEditing = true
		cityBox.textAlignment = .left
		cityBox.accessibilityIdentifier = "CityTextBox"
		self.addSubview(cityBox)
		
		stateBox = UITextField(frame: CGRect(x: self.frame.height/3, y: 2*self.frame.height/3, width: self.frame.width, height: self.frame.height/3))
		stateBox.autocorrectionType = .no
		stateBox.autocapitalizationType = .none
		stateBox.text = "ST"
		stateBox.clearsOnBeginEditing = true
		stateBox.textAlignment = .left
		stateBox.delegate = self
		stateBox.accessibilityIdentifier = "StateTextBox"
		self.addSubview(stateBox)
		
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		textField.clearsOnBeginEditing = false
		return string == "" || self.stateBox.text!.count < 2
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		accCreationView.slideBackDown()
		return false
	}
	
	func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
		accCreationView.slideBackDown()
	}
	
	//Slides everything up just a lil
	//EFFECT: r moves all the fields and labels up by a keyboard width also sets the slidUp field to true
	func textFieldDidBeginEditing(_ textField: UITextField) {
		accCreationView.slideUp()
	}
	
	//Draws the underline and places the image
	override func draw(_ rect: CGRect) {
		PRESETS.BLACK.set()
		self.drawUnderline(y: self.frame.height/3)
		self.drawUnderline(y: 2*self.frame.height/3)
		self.drawUnderline(y: self.frame.height)
		
		let imageHeight = self.frame.height / 4
		let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageHeight, height: imageHeight))
		imageView.image = toDisplay
		self.addSubview(imageView)
	}
	
	func drawUnderline(y: CGFloat) {
		let underline = UIBezierPath()
		underline.move(to: CGPoint(x: 0, y: y-5))
		underline.addLine(to: CGPoint(x: self.frame.width, y: y-5))
		underline.lineWidth = 2
		underline.stroke()
	}
}
