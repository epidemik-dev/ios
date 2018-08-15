//
//  ColorScheme.swift
//  Epidemik
//
//  Created by Ryan Bradford on 10/22/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit

public class PRESETS {
	//All the preset colors or fonts used throughout the app
	
	
	public static var RED  = UIColor(displayP3Red: 169/255.0, green: 18/255.0, blue: 27/255.0, alpha: 1) // Dark Red
	public static var DARK_RED  = UIColor(displayP3Red: 155/255.0, green: 10/255.0, blue: 20/255.0, alpha: 1) // Very Dark Red
	public static var DARK_YELLOW = UIColor(displayP3Red: 204/255.0, green: 204/255.0, blue: 0/255.0, alpha: 1)
	public static var GRAY  = UIColor.gray // Gray
	public static var WHITE  = UIColor(displayP3Red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1) //White
	public static var CLEAR = UIColor.clear
	public static var BLACK = UIColor.black
	public static var OFF_WHITE = UIColor(displayP3Red: 0.95, green: 0.92, blue: 0.92, alpha: 1)
	
	//Returns the approproate color for the overlay square given its power
	public static func getOverlayColor(weight: CGFloat) -> UIColor {
		return UIColor(displayP3Red: weight*185.0/255.0, green: 35.0/255.0, blue: 58.0/255.0, alpha: weight*1.0/4.0)
	}
	
	public static var FONT_NAME = "Helvetica"
	public static var BOLD_FONT_NAME = "Helvetica-Bold"
	public static var SCALE = 0.8
	
	public static var FONT_SMALL = UIFont(name: FONT_NAME, size: CGFloat(10*SCALE))
	public static var FONT_MEDIUM = UIFont(name: FONT_NAME, size: CGFloat(15*SCALE))
	public static var FONT_BIG = UIFont(name: FONT_NAME, size: CGFloat(20*SCALE))
	public static var FONT_SMALL_BOLD = UIFont(name: BOLD_FONT_NAME, size: CGFloat(10*SCALE))
	public static var FONT_BIG_BOLD = UIFont(name: BOLD_FONT_NAME, size: CGFloat(20*SCALE))
	public static var FONT_VERY_BIG = UIFont(name: FONT_NAME, size: CGFloat(30*SCALE))
	public static var FONT_VERY_VERY_BIG = UIFont(name: FONT_NAME, size: CGFloat(40*SCALE))
	
}
