//
//  AccountCreation.swift
//  Epidemik
//
//  Created by Ryan Bradford on 3/3/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import UserNotifications
import SwiftyJSON

class LoginScreen: UIView, UITextFieldDelegate {
	//The screen that handles logining in and account creation
	
	var FILE_NAME = "username.epi"
	
	var usernameTextBox: AccCreationTextBox!
	var passwordTextBox: AccCreationTextBox!
	var addressTextBox: AddressCreator?
	var dobPicker: UIDatePicker?
	var genderSelector: GenderSelector?
	
	var dobTitle: UITextView?
	var passwordWarning: UITextView?
	
	var shouldAdd: Bool = true
	
	var loginButton: UIButton!
	var loginLabel: UILabel!
	var createAccLabel: UILabel!
	
	var createAccButton: UIButton!
	
	var logoImageView: UIImageView!
	
	var vc: ViewController!
	
	var username: String?
	var password: String?
	var latitude: Double?
	var longitude: Double?
	
	var slidUp = false
	
	var xOffset: CGFloat!
	var selectorHeight: CGFloat!
	var textBoxWidth: CGFloat!
	
	
	//Inits this class and sets the variable that says whether we need to login/create account
	init(frame: CGRect, vc: ViewController) {
		self.vc = vc
		super.init(frame: frame)
		self.accessibilityIdentifier = "LoginScreen"
		setShouldAdd()
		self.backgroundColor = PRESETS.WHITE
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	//Draws this view by adding all the proper subview items
	override func draw(_ rect: CGRect) {
		selectorHeight = self.frame.height / 15.0
		xOffset = self.frame.width / 12
		textBoxWidth = self.frame.width - 2.0*xOffset
		initTextBoxes()
		addLoginButton()
		addCreateAccountButton()
		addLogo()
		self.backgroundColor = PRESETS.WHITE
	}
	
	// Sends a login request to the server
	//EFFECT: if suceeds, writes the passwors and username to the disk and slides this view away
	//If fails, dismisses the textbox and warns the user
	func login(username: String, password: String) {
		NetworkAPI.loginIsValid(username: username, password: password, result: {(response: JSON?) -> () in
			if(response != nil) {
				FileRW.writeFile(fileName: self.FILE_NAME, contents: username)
				FileRW.writeFile(fileName: "auth_token.epi", contents: response!.string!)
				FileRW.writeFile(fileName: "password.epi", contents: password)
				DispatchQueue.main.sync {
					self.slideBackDown()
					self.slideSelfAway(duration: 0.5)
				}
			} else {
				DispatchQueue.main.sync {
					self.slideBackDown()
					self.warnUser(message: "Incorrect Password")
				}
			}
		})
	}
	
	// Tells the Holder if this view should be added
	//EFFECT: updates the shouldAdd field
	func setShouldAdd() {
		let currentUsername = FileRW.readFile(fileName: FILE_NAME)
		let currentPassword = FileRW.readFile(fileName: "password.epi")
		self.shouldAdd = currentUsername == nil || currentUsername == "" || currentPassword == nil || currentPassword == ""
	}
	
	//Tells the user that their login was incorrect
	//Sets the username textbox to display a warning
	func warnUser(message: String) {
		usernameTextBox.text = message
		passwordTextBox.text = ""
	}
	
	//Called when the app has verified the address
	//EFFECT: Moves this textview away and brings stuff on the main view
	func slideSelfAway(duration: Double) {
		self.vc.initMainScreen()
		UIView.animate(withDuration: duration, animations: {
			self.frame.origin.y -= self.frame.height
		}, completion: {
			(value: Bool) in
			self.removeFromSuperview()
		})
	}
	
	//Creates the username and password text boxes
	//EFFECT: changes the username and password textboxes
	func initTextBoxes() {
		initUsernameTextBox()
		initPasswordTextBox()
	}
	
	// Creates the username textbox and puts the image next to it
	//EFFECT: alters the username field and adds it to the UIView
	func initUsernameTextBox() {
		let usernameImage = FileRW.readImage(imageName: "username.png")
		usernameTextBox = AccCreationTextBox(frame: CGRect(x: xOffset, y: self.frame.height/2 - 2*selectorHeight, width: self.frame.width - 2.0*xOffset, height: selectorHeight), toDisplay: usernameImage)
		usernameTextBox.delegate = self
		usernameTextBox.text = "username"
		usernameTextBox.accessibilityIdentifier = "UsernameTextBox"
		self.addSubview(usernameTextBox)
	}
	
	// Creates the password textbox and puts the image next to it
	//EFFECT: alters the username field and adds it to the UIView
	func initPasswordTextBox() {
		let passwordImage = FileRW.readImage(imageName: "password.png")
		passwordTextBox = AccCreationTextBox(frame: CGRect(x: xOffset, y: self.frame.height/2 - selectorHeight/2, width: self.frame.width - 2*xOffset, height: selectorHeight), toDisplay: passwordImage)
		passwordTextBox.accessibilityIdentifier = "PasswordTextBox"
		passwordTextBox.isSecureTextEntry = true
		passwordTextBox.delegate = self
		passwordTextBox.text = "password"
		self.addSubview(passwordTextBox)
	}
	
	// Creates the login button
	//EFFECT: alters the login field and adds it to the UIView
	func addLoginButton() {
		loginButton = UIButton(frame: CGRect(x: xOffset, y: self.frame.height / 2 + selectorHeight, width: self.textBoxWidth, height: selectorHeight))
		loginButton.backgroundColor = PRESETS.OFF_WHITE
		loginButton.accessibilityIdentifier = "LoginButton"
		loginButton.addTarget(self, action: #selector(LoginScreen.loginReactor(_:)), for: .touchUpInside)
		loginLabel = UILabel()
		loginLabel.text = "Login"
		loginLabel.font = PRESETS.FONT_BIG
		loginLabel.frame = CGRect(x: 0, y: 0, width: self.textBoxWidth, height: selectorHeight)
		loginLabel.textAlignment = .center
		loginButton.addSubview(loginLabel)
		self.addSubview(loginButton)
	}
	
	//Puts on the little text labaled create an account
	//EFFECT: adds the create an acc button to the page
	func addCreateAccountButton() {
		let selectorHeight = self.frame.height / 12
		let selfWidth = 5*self.frame.width / 12
		createAccButton = UIButton(frame: CGRect(x: (self.frame.width - selfWidth) / 2, y: self.frame.height - selectorHeight, width: selfWidth, height: selectorHeight))
		createAccButton.accessibilityIdentifier = "CreateAccButton"
		createAccButton.backgroundColor = PRESETS.CLEAR
		self.createAccLabel = UILabel()
		self.createAccLabel.text = "Create an Account"
		self.createAccLabel.font = PRESETS.FONT_MEDIUM
		self.createAccLabel.frame = CGRect(x: 0, y: 0, width: selfWidth, height: selectorHeight)
		self.createAccLabel.textAlignment = .center
		createAccButton.addSubview(self.createAccLabel)
		createAccButton.addTarget(self, action: #selector(LoginScreen.accCreateInitReactor(_:)), for: .touchUpInside)
		self.addSubview(createAccButton)
	}
	
	//Reacts when the user presses the create account buttom
	//EFFECT: Moves the objects onto the screen that need to be used.
	//Slides the login button down and removes the create acc button
	@objc func accCreateInitReactor(_ sender: UIButton?) {
		self.slideBackDown()
		loginLabel.text = "Create An Account"
		initPasswordWarning()
		initAddressTextBox()
		
		loginButton.removeTarget(self, action: #selector(LoginScreen.loginReactor(_:)), for: .touchUpInside)
		loginButton.addTarget(self, action: #selector(LoginScreen.accCreateReactor(_:)), for: .touchUpInside)
		
		self.createAccLabel.text = "Create A New Account"
		
		UIView.animate(withDuration: 0.5, animations: {
			self.loginButton.frame.origin.y += 9*self.selectorHeight/2
			self.createAccButton.frame.origin.x -= self.frame.width
			self.addressTextBox?.frame.origin.x = self.xOffset
		})
	}
	
	//Creats the password warning field that shows if the users password is valid
	//EFFECT: creates the field and adds it to the UIView
	func initPasswordWarning() {
		self.passwordWarning = UITextView(frame: CGRect(x: xOffset, y: self.frame.height/2 - selectorHeight/2 - 10, width: self.frame.width - 2*xOffset, height: 20))
		self.passwordWarning!.font = PRESETS.FONT_SMALL_BOLD
		self.passwordWarning!.isEditable = false
		self.passwordWarning!.isSelectable = false
		self.passwordWarning!.textColor = PRESETS.RED
		self.passwordWarning!.textAlignment = .center
		self.passwordWarning!.backgroundColor = PRESETS.CLEAR
		self.passwordWarning!.accessibilityIdentifier = "PasswordWarning"
		self.addSubview(self.passwordWarning!)
		
		let _ = checkPassword(password: self.passwordTextBox.text!)
	}
	
	// Creates the address textbox and puts the image next to it
	//EFFECT: alters the address field and adds it to the UIView
	func initAddressTextBox() {
		let addressImage = FileRW.readImage(imageName: "address.png")
		addressTextBox = AddressCreator(frame: CGRect(x: self.frame.width, y: self.frame.height/2 + selectorHeight, width: self.textBoxWidth, height: 3*selectorHeight), toDisplay: addressImage, accCreationView: self)
		addressTextBox!.setDelegate(toSetAs: self)
		addressTextBox?.accessibilityIdentifier = "AddressCreator"
		self.addSubview(addressTextBox!)
	}
	
	//Creates the DOBSelector and adds a lable next to it
	//EFFECT: inits the dobField and adds it to the UIView
	func initDOBSelector() {
		dobTitle = UITextView(frame: CGRect(x: self.frame.width, y: self.frame.height/2 + 7*selectorHeight/4, width: 2*xOffset, height: 2*selectorHeight))
		dobTitle!.text = "DOB"
		dobTitle!.font = PRESETS.FONT_BIG_BOLD
		dobTitle?.isEditable = false
		dobTitle?.isSelectable = false
		dobTitle?.backgroundColor = PRESETS.CLEAR
		self.addSubview(dobTitle!)
		
		self.dobPicker = UIDatePicker(frame: CGRect(x: self.frame.width, y: self.frame.height/2 + 2*selectorHeight/4, width: self.textBoxWidth - 0.5*xOffset, height: 6*selectorHeight/2))
		self.dobPicker?.accessibilityIdentifier = "DOBPicker"
		self.dobPicker?.datePickerMode = .date
		var dateComponents = DateComponents()
		dateComponents.year = -100
		let minDate = Calendar.current.date(byAdding: dateComponents, to: Date())
		
		self.dobPicker?.minimumDate = minDate
		self.dobPicker?.maximumDate = Date()
		self.addSubview(dobPicker!)
	}
	
	//Creates the gender selector field
	//EFFECT: adds it to the UIView
	func initMaleFemaleOtherCheckbox() {
		genderSelector = GenderSelector(frame: CGRect(x: self.frame.width, y: self.frame.height/2 + 7*selectorHeight/2, width: self.textBoxWidth, height: selectorHeight))
		genderSelector?.accessibilityIdentifier = "GenderSelector"
		self.addSubview(genderSelector!)
	}
	
	//What is called when the user presses the login button
	//EFFECT: calls self.login and checks the login on the server
	@objc func loginReactor(_ sender: UIButton?) {
		self.login(username: self.usernameTextBox.text!, password: self.passwordTextBox.text!)
	}
	
	//What is called when the user presses the return button
	//EFFECT: moves everything down just a lil
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		slideBackDown()
		return false
	}
	
	//What is called when the user begins to edit stuff
	//EFFECT: slides everything up a lil
	func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
		slideBackDown()
	}
	
	//What is called when the user types anything
	//EFFECT: pdates the field that says whether the password is good
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if(textField.accessibilityIdentifier != "PasswordTextBox") {
			return true
		}
		let text = self.passwordTextBox.text!
		if(string == "") {
			let _ = checkPassword(password: String(text[..<text.index(before: text.endIndex)]))
		} else {
			let _ = checkPassword(password: text + string)
		}
		return true
	}
	
	//Returns if the password is a valid password
	//EFFECT: If it is not, modifies the passwordWarningField to say so
	func checkPassword(password: String) -> Bool {
		if((password.count) < 6) {
			self.passwordWarning?.text = "Password Must Be Longer"
			return false
		}else if(password == "password") {
			self.passwordWarning?.text = "Invalid Password"
			return false
		} else {
			self.passwordWarning?.text = ""
			return true
		}
	}
	
	//Slides everything down just a lil
	//EFFECT: removes the keyboard and moves all the fields and labels down by a keyboard width
	//Also sets the slidUp field to false
	func slideBackDown() {
		self.endEditing(true)
		if(!slidUp) {
			return
		}
		slidUp = false
		UIView.animate(withDuration: 0.5, animations: {
			self.usernameTextBox.frame.origin.y += 5*self.frame.height/16
			self.passwordTextBox.frame.origin.y += 5*self.frame.height/16
			self.passwordWarning?.frame.origin.y += 5*self.frame.height/16
			self.logoImageView.frame.origin.y += 5*self.frame.height/16
			self.loginButton.frame.origin.y += 5*self.frame.height/16
			self.addressTextBox?.frame.origin.y += 5*self.frame.height/16
			self.dobPicker?.frame.origin.y += 5*self.frame.height/16
			self.dobTitle?.frame.origin.y += 5*self.frame.height/16
			self.genderSelector?.frame.origin.y += 5*self.frame.height/16
		})
	}
	
	func slideUp() {
		if(slidUp) {
			return
		}
		slidUp = true
		UIView.animate(withDuration: 0.5, animations: {
			self.usernameTextBox.frame.origin.y -= 5*self.frame.height/16
			self.passwordTextBox.frame.origin.y -= 5*self.frame.height/16
			self.passwordWarning?.frame.origin.y -= 5*self.frame.height/16
			self.logoImageView.frame.origin.y -= 5*self.frame.height/16
			self.loginButton.frame.origin.y -= 5*self.frame.height/16
			self.addressTextBox?.frame.origin.y -= 5*self.frame.height/16
			self.dobPicker?.frame.origin.y -= 5*self.frame.height/16
			self.dobTitle?.frame.origin.y -= 5*self.frame.height/16
			self.genderSelector?.frame.origin.y -= 5*self.frame.height/16
		})
	}
	
	//Slides everything up just a lil
	//EFFECT: r moves all the fields and labels up by a keyboard width also sets the slidUp field to true
	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.clearsOnBeginEditing = false
		slideUp()
	}
	
	//What is called when the user presses the login button and they have create account set to true
	//turns their location to Lat, Long and then calls the real create acc method
	//EFFECT: if the address is invald, it warns the user
	@objc func accCreateReactor(_ sender: UIButton?) {
		let address = addressTextBox!.getAddress()
		let username = usernameTextBox.text!
		let password = passwordTextBox.text!
		
		let isValid = checkPassword(password: self.passwordTextBox.text!)
		if(!isValid) {
			return
		}
		if (address != "") {
			let geocoder = CLGeocoder()
			geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> () in
				if let buffer = placemarks?[0] {
					let location = buffer.location;
					if(self.dobPicker == nil) {
						self.showDOBGenderHideAdd();
					} else {
						self.askForNotifications(username: username, password: password, latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
					}
				} else {
					self.warnUser(message: "please enter a valid address")
				}
			})
		} else {
			warnUser(message: "please enter a valid address")
		}
	}
	
	func showDOBGenderHideAdd() {
		self.slideBackDown()
		self.initDOBSelector()
		self.initMaleFemaleOtherCheckbox()
		UIView.animate(withDuration: 0.5, animations: {
			self.addressTextBox?.frame.origin.x -= self.frame.width
			self.dobPicker?.frame.origin.x = 2*self.xOffset
			self.dobTitle?.frame.origin.x = self.xOffset/2
			self.genderSelector?.frame.origin.x = self.xOffset
		})
	}
	
	//What is called after the address is turned to cordinates
	//EFFECT: asks the user if they want notifications and then calls the real real account creator
	func askForNotifications(username: String, password: String, latitude: Double, longitude: Double) {
		self.username = username
		self.password = password
		self.longitude = longitude
		self.latitude = latitude
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		appDelegate.accCreation = self
		UNUserNotificationCenter.current().requestAuthorization(options:[.alert, .sound]){ (granted, error) in }
		UIApplication.shared.registerForRemoteNotifications()
	}
	
	//Creates an account with the devID given that all the class feilds are full
	//EFFECT: if the account is valid, it removes this view and writes the username + password to the disk
	//Else, it warns the user and we do the whole thing again
	func createAccount(deviceID: String) {
		NetworkAPI.createAccount(username: username!, password: password!, latitude: latitude!, longitude: longitude!, deviceID: deviceID, dob: self.dobPicker!.date, gender: self.genderSelector!.getGender(), result: { (response: JSON?) -> () in
			if(response != nil) {
				FileRW.writeFile(fileName: self.FILE_NAME, contents: self.username!)
				FileRW.writeFile(fileName: "password.epi", contents: self.password!)
				FileRW.writeFile(fileName: "auth_token.epi", contents: response!.string!)
				DispatchQueue.main.sync {
					self.slideBackDown()
					self.slideSelfAway(duration: 0.5)
				}
			} else {
				DispatchQueue.main.sync {
					self.slideBackDown()
					self.warnUser(message: "this login already exists")
				}
			}
		})
	}
	
	//Adds the logo to the top of the UIVIew
	//EFFECT: inits the logo field and adds it as a view
	func addLogo() {
		let epidemikImage = FileRW.readImage(imageName: "epidemik.png")
		let imageWidth = self.frame.width / 3
		logoImageView = UIImageView(frame: CGRect(x: (self.frame.width - imageWidth)/2, y: self.frame.height
			/ 20 + 40, width: imageWidth, height: imageWidth))
		logoImageView.image = epidemikImage
		self.addSubview(logoImageView)
	}
	
	
}
