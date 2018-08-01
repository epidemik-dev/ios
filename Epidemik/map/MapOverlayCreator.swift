//
//  MapOverlay.swift
//  Epidemik
//
//  Created by Ryan Bradford on 9/30/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import MapKit

public class MapOverlayCreator {
	
	//The number of overlays in the given direction
	var numLat = 35.0
	var numLong = 35.0
	
	//The average intensity of an EXISTING overlay
	//Does not include empty overlays
	var averageIntensity: Double = 1.0
	
	//All the disease data of people currently sick
	var data: Array<Disease>
	
	//The data structure that keeps track of the disease points
	var manager: DiseaseManager!
	
	//Initalizes this map with all its fields
	//Also begins to load the data and create the overlays
	//This class is only created when the DataCenter has proper disease data
	init(data: Array<Disease>) {
		self.data = data
		
		self.loadData()
	}
	
	func loadData() {
		self.manager = DiseaseManager()
		for dataPoint in data {
			manager.addDisease(lat: dataPoint.lat, long: dataPoint.long, diseaseName: dataPoint.diseaseName)
		}
	}
	
	// Combine create and process into one
	// Processes the array, and makes the visual graphic look slightly nicer
	func createOverlays(longWidth: Double, latWidth: Double, startLong: Double, startLat: Double, diseaseName: String?) -> Array<DiseasePolygon> {
		let minLat = startLat
		let minLong = startLong
		
		let maxLat = latWidth + startLat
		let maxLong = longWidth + startLong
		
		//Keeps track of every diseasePolygon to draw
		var toDraw = Array<DiseasePolygon>()
		
		//Keeps track of what X,Y cordinates have polygons in them
		var averageCounter = Dictionary<String, Int>()
		//The total number of disease points in the region
		var total = 0.0
		
		//Keeps track of what lat,long region we are currently in
		var realLat = minLat
		var realLong = minLong

		//The number of degrees that fall into every block
		let scaleLat = latWidth / self.numLat
		let scaleLong = longWidth / self.numLong
		
		//The average intensity of every NON EMPTY overlay field
		self.averageIntensity = 0
		
		while realLat < maxLat {
			realLong = minLong
			let deltaLat = realLat - minLat
			let posnLat =  Int(floor(deltaLat / scaleLat))
			while realLong < maxLong {
				//Gets the number of points in the current region
				let intensity = Double(manager!.getWeightForRange(curLatMin: realLat, curLatMax: realLat+scaleLat, curLongMin: realLong, curLongMax: realLong+scaleLong, diseaseName: diseaseName))
				total += intensity
				//Does not inlucde of no intensity
				if(intensity != 0) {
					let deltaLong = realLong - minLong
					let posnLong = Int(floor(deltaLong / scaleLong))
					//Adds the current point to the average counter so it will not be counted again
					let combination = String(posnLat) + "," + String(posnLong)
					averageCounter[combination] = 0
					
					//Creating the overlays
					var points=[CLLocationCoordinate2DMake(realLat,  realLong),CLLocationCoordinate2DMake(realLat+scaleLat,  realLong),CLLocationCoordinate2DMake(realLat+scaleLat,  realLong+scaleLong),CLLocationCoordinate2DMake(realLat,  realLong+scaleLong)]
					let toAdd = DiseasePolygon(coordinates: &points, count: points.count)
					toAdd.intensity = intensity
					toDraw.append(toAdd)
				}
				realLong += scaleLong
			}
			realLat += scaleLat
		}
		//Stops div by zero errors
		if(averageCounter.count == 0){
			self.averageIntensity = 1
		} else {
			self.averageIntensity = total / Double(averageCounter.count)
		}
		
		return toDraw
	}
	
}
