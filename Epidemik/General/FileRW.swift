//
//  FileRW.swift
//  Epidemik
//
//  Created by Ryan Bradford on 9/24/17
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class FileRW {
	
	//Reads this file and returns its result
	public static func readFile(fileName: String) -> String? {
		let defaults = UserDefaults(suiteName: "group.io.thaumavor.rbradford.Epidemik")
		return defaults?.object(forKey: fileName) as? String
	}
	
	//Writes this file to the disk
	//EFFECT: overwrites the given value
	public static func writeFile(fileName: String, contents: String) {
		let defaults = UserDefaults(suiteName: "group.io.thaumavor.rbradford.Epidemik")
		defaults?.set(contents, forKey: fileName)
	}
	
	//Deletes this file from the disk
	//EFFECT: removes this file from the disk
	public static func deleteFile(fileName: String) {
		let defaults = UserDefaults(suiteName: "group.io.thaumavor.rbradford.Epidemik")
		defaults?.removeObject(forKey: fileName)
	}
	
	//Returns if this file exists or not
	public static func fileExists(fileName: String) -> Bool {
		if FileRW.readFile(fileName: fileName) == nil {
			return false
		}
		return true
	}
	
	//Returns the image of it exists, if it doesn't returns a blank image
	public static func readImage(imageName: String) -> UIImage {
		let toAdd = UIImage(named: imageName)
		if(toAdd == nil) {
			return UIImage()
		} else {
			return toAdd!
		}
		

	}
	
}

