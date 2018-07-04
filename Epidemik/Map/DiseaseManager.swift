//
//  DiseaseManager.swift
//  Epidemik
//
//  Created by Ryan Bradford on 5/11/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation

class DiseaseManager {
	//The class that stores all the disease points
	
	//The main disease branch that stores everything
	var corner: DiseaseBranch
	
	init() {
		//Creates a new corner that spans more than the globe
		corner = DiseaseBranch(latMin: -90, latMax: 90, longMin: -180, longMax: 180)
	}
	
	//Returns the count of all the disease points in this range
	func getWeightForRange(curLatMin: Double, curLatMax: Double, curLongMin: Double, curLongMax: Double) -> Int {
		return corner.getWeightForRange(curLatMin: curLatMin, curLatMax: curLatMax, curLongMin:curLongMin, curLongMax: curLongMax)
	}
	
	//Adds this disease point to the data structure
	func addDisease(lat: Double, long: Double) {
		corner = corner.addDisease(lat: lat, long: long)
	}
	
	// Returns the count of every disease stored in the system
	func getAll() -> Int {
		return corner.getAll()
	}
	
	
}

class DiseaseBranch {
	//I tried to use a system of Branch and Leaf classes but I
	//couldnt get it to work
	
	//The cordinates of this branch
	var latMin: Double
	var latMax: Double
	var longMin: Double
	var longMax: Double
	
	var latWidth: Double
	var longWidth: Double
	
	//The sub branches of this branch
	//If this one is an end leaf, these will be nil
	var topLeft: DiseaseBranch?
	var bottomLeft: DiseaseBranch?
	var topRight: DiseaseBranch?
	var bottomRight: DiseaseBranch?
	
	//The number of diseases stored in this branch
	//Should only be non-zero if this branch is an end branch
	var numDiseases: Int
	
	//The range limit for when it should stop recuring
	var errorBound = 0.005
	
	
	//Creates this branch with the sub-brances as nil
	init(latMin: Double, latMax: Double, longMin: Double, longMax: Double) {
		self.latWidth = latMax - latMin
		self.longWidth = longMax - longMin
		
		self.latMax = latMax
		self.latMin = latMin
		self.longMax = longMax
		self.longMin = longMin
		
		self.numDiseases = 0
	}
	
	//Adds this disease to the data structure
	//If it does not fall in the range of this branch, returns
	//If this branch is an end branch it increases this count
	//Else it finds what branch to slot it into
	//Only turns the proper branch into a non-nil branch if it needs to
	func addDisease(lat: Double, long: Double) -> DiseaseBranch {
		if(latWidth < errorBound && longWidth < errorBound) {
			numDiseases += 1
			return self
		}
		if(lat <= latMin + latWidth / 2) {
			//Bottom
			if(long <= longMin + longWidth / 2) {
				if(bottomLeft == nil) {
					bottomLeft = DiseaseBranch(latMin: latMin, latMax: latMin + latWidth / 2, longMin: longMin, longMax: longMin + longWidth / 2)
				}
				bottomLeft = bottomLeft?.addDisease(lat: lat, long: long)
				// Bottom Left
				return self
			} else {
				if(bottomRight == nil) {
					bottomRight = DiseaseBranch(latMin: latMin, latMax: latMin + latWidth / 2, longMin: longMin + longWidth / 2, longMax: longMax)
				}
				bottomRight = bottomRight?.addDisease(lat: lat, long: long)
				// Bottom Right
				return self
			}
		} else {
			// Top
			if(long <= longMin + longWidth / 2) {
				if(topLeft == nil) {
					topLeft = DiseaseBranch(latMin: latMin + latWidth / 2, latMax: latMax, longMin: longMin, longMax: longMin + longWidth / 2)
				}
				topLeft = topLeft?.addDisease(lat: lat, long: long)
				//Top Left
				return self
			} else {
				if(topRight == nil) {
					topRight = DiseaseBranch(latMin: latMin + latWidth / 2, latMax: latMax, longMin: longMin + longWidth / 2, longMax: longMax)
				}
				topRight = topRight?.addDisease(lat: lat, long: long)
				//Top Right
				return self
			}
		}
	}
	
	//Returns the weight for this branch in the given range
	//If the range is out of bounds, it returns zero
	//Else it returns this count + the count for every sub branch
	func getWeightForRange(curLatMin: Double, curLatMax: Double, curLongMin: Double, curLongMax: Double) -> Int {
		if(curLatMin > self.latMax || curLatMax < self.latMin || curLongMin > self.longMax || curLongMax < self.longMin) {
			return 0
		} else {
			var total = 0
			if(topLeft != nil
				&& curLatMin <= self.topLeft!.latMax && curLatMax >= self.topLeft!.latMin
				&& curLongMin <= self.topLeft!.longMax && curLongMax >= self.topLeft!.longMin) {
				total = total + (self.topLeft!.getWeightForRange(curLatMin: curLatMin, curLatMax: curLatMax, curLongMin: curLongMin, curLongMax: curLongMax))
			}
			if(self.topRight != nil
				&& curLatMin <= self.topRight!.latMax && curLatMax >= self.topRight!.latMin
				&& curLongMin <= self.topRight!.longMax && curLongMax >= self.topRight!.longMin) {
				total = total + (self.topRight!.getWeightForRange(curLatMin: curLatMin, curLatMax: curLatMax, curLongMin: curLongMin, curLongMax: curLongMax))
				
			}
			if(self.bottomLeft != nil
				&& curLatMin <= self.bottomLeft!.latMax && curLatMax >= self.bottomLeft!.latMin
				&& curLongMin <= self.bottomLeft!.longMax && curLongMax >= self.bottomLeft!.longMin) {
				total = total + (self.bottomLeft!.getWeightForRange(curLatMin: curLatMin, curLatMax: curLatMax, curLongMin: curLongMin, curLongMax: curLongMax))
				
			}
			if(self.bottomRight != nil
				&& curLatMin <= self.bottomRight!.latMax && curLatMax >= self.bottomRight!.latMin
				&& curLongMin <= self.bottomRight!.longMax && curLongMax >= self.bottomRight!.longMin) {
				total = total + (self.bottomRight!.getWeightForRange(curLatMin: curLatMin, curLatMax: curLatMax, curLongMin: curLongMin, curLongMax: curLongMax))
				
			}
			return self.numDiseases + total
		}
	}
	
	// Returns the count of every disease stored in this branch
	func getAll() -> Int {
		var total = self.numDiseases
		if(self.topLeft != nil) {
			total += self.topLeft!.getAll()
		}
		if(self.topRight != nil) {
			total += self.topRight!.getAll()
		}
		if(self.bottomLeft != nil) {
			total += self.bottomLeft!.getAll()
		}
		if(self.bottomRight != nil) {
			total += self.bottomRight!.getAll()
		}
		return total
	}
}
