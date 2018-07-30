//
//  Asker.swift
//  Epidemik
//
//  Created by Ryan Bradford on 2/23/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

class Asker {
	
	//Displays a popup image that asks this quesiton with this data
	//EFFECT: calls the IFunc when done
	public static func ask(title: String, placeHolder: String, message: String, isSecure: Bool, resp: @escaping ((String) -> ())) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (alertAction:UIAlertAction) in
			let textf1 = alert.textFields![0] as UITextField
			resp(textf1.text!)
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler:{ (alertAction:UIAlertAction) in
			
		}))
		alert.addTextField(configurationHandler: {(textField: UITextField) in
			textField.placeholder = placeHolder
			textField.isSecureTextEntry = isSecure
		})
		UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
	}
	
}
