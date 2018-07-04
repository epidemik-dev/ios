//
//  ScrollSelector.swift
//  Epidemik
//
//  Created by Ryan Bradford on 9/29/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation

import Foundation
import UIKit

public class ScrollSelector: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
	//A class that standardizes scrolling through a list of options
	
	//The UIView item that represents the selector itself
	var itemPicker: UIPickerView!
	//All the items displayed (the filtered list)
	var items: Array<String>?
	//All the items that could be displayed (the unfiltered list)
	var allItems: Array<String>!
	//The text of the current item selected
	var currentTextField: UITextField?
	
	//Initilzizes this class with the given items
	//OTHER: creates all the appropriate fields and adds stuff to the View
	init(frame: CGRect, items: Array<String>) {
		super.init(frame: frame)
		
		self.items = items
		self.allItems = items
		
		itemPicker = UIPickerView()
		itemPicker.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
		
		currentTextField = UITextField()
		currentTextField?.font = PRESETS.FONT_BIG_BOLD
		
		itemPicker?.dataSource = self
		itemPicker?.delegate = self
		
		currentTextField?.inputView = itemPicker
		currentTextField?.text = items[0]
		
		self.addSubview(itemPicker)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return items![row]
	}
	
	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if items != nil && row < items!.count {
			currentTextField?.text = self.items![row]
		}
	}
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return items!.count
	}
	
	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	public func limitItems(search: String) {
		if(search != "") {
			items = allItems.filter({ (toTest) -> Bool in
				(toTest.contains(search))
			})
		} else {
			items = allItems
		}
		itemPicker?.dataSource = self
		itemPicker?.delegate = self
		itemPicker.updateFocusIfNeeded()
	}
}

