//
//  AddressCreator.swift
//  Epidemik
//
//  Created by Ryan Bradford on 4/20/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class AddressCreator: CreateItem, UITextFieldDelegate {
	
	//The UIView that holds all the address creation textboxes
	
	// The image that goes to the left
	var toDisplay: UIImage!
	
	//The three checkboxes
	var addressBox: UITextField!
	var cityBox: UITextField!
	var stateBox: UITextField!
	
	var slideDown: (() -> ())!
	var slideUp: (() -> ())!
	var warnUser: ((String) -> ())!
	
	var latitude: Double?
	var longitude: Double?
	
	//Inits this class and creates the checkboxes
	init(frame: CGRect, slideUp: @escaping () -> (), slideDown: @escaping () -> (), warnUser: @escaping (String) -> ()) {
		self.toDisplay = FileRW.readImage(imageName: "address")
		self.slideUp = slideUp
		self.slideDown = slideDown
		self.warnUser = warnUser
		super.init(frame: frame)
		self.accessibilityIdentifier = "AddressCreator"
		self.title = "Where do you live?"
		self.backgroundColor = PRESETS.WHITE
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
		addressBox = UITextField(frame: CGRect(x: self.frame.height/3, y: 10, width: self.frame.width, height: self.frame.height/3))
		addressBox.autocorrectionType = .no
		addressBox.autocapitalizationType = .none
		addressBox.text = "Address"
		addressBox.backgroundColor = PRESETS.CLEAR
		addressBox.clearsOnBeginEditing = true
		addressBox.textAlignment = .left
		addressBox.delegate = self
		addressBox.accessibilityIdentifier = "AddressTextBox"
		self.addSubview(addressBox)
		
		cityBox = UITextField(frame: CGRect(x: self.frame.height/3, y: self.frame.height/3+10, width: self.frame.width, height: self.frame.height/3))
		cityBox.autocorrectionType = .no
		cityBox.autocapitalizationType = .none
		cityBox.text = "City"
		cityBox.clearsOnBeginEditing = true
		cityBox.textAlignment = .left
		cityBox.delegate = self
		cityBox.accessibilityIdentifier = "CityTextBox"
		self.addSubview(cityBox)
		
		stateBox = UITextField(frame: CGRect(x: self.frame.height/3, y: 2*self.frame.height/3+10, width: self.frame.width, height: self.frame.height/3))
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
		if(textField.accessibilityIdentifier == "StateTextBox") {
			return string == "" || self.stateBox.text!.count < 2
		} else {
			return true
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.slideDown()
		return false
	}
	
	func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
		self.slideDown()
	}
	
	//Slides everything up just a lil
	//EFFECT: r moves all the fields and labels up by a keyboard width also sets the slidUp field to true
	func textFieldDidBeginEditing(_ textField: UITextField) {
		self.slideUp()
	}
	
	//Draws the underline and places the image
	override func draw(_ rect: CGRect) {
		PRESETS.BLACK.set()
		if(self.frame.height == 0) {
			return
		}
		self.drawUnderline(y: self.frame.height/3)
		self.drawUnderline(y: 2*self.frame.height/3)
		self.drawUnderline(y: self.frame.height)
		
		let imageHeight = self.frame.height / 4
		let imageView = UIImageView(frame: CGRect(x: 0, y: 10, width: imageHeight, height: imageHeight))
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
	
	override func getInfo() -> [String] {
		return [String(latitude!), String(longitude!)]
	}
	
	override func next(result: @escaping (Bool) -> ()) {
		let address = self.getAddress()
		let geocoder = CLGeocoder()
		geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> () in
			if let buffer = placemarks?[0] {
				let location = buffer.location;
				self.latitude = location!.coordinate.latitude
				self.longitude = location!.coordinate.longitude
				result(true)
			} else {
				self.warnUser("please enter a valid address")
				result(false)
			}
		})
	}
	
	override func resetItem() {
		self.addressBox.text = "Address"
		self.cityBox.text = "City"
		self.stateBox.text = "ST"
	}
	
}
