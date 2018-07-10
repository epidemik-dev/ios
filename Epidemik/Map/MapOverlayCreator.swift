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
	var numLat = 50.0
	var numLong = 50.0
	
	//The map field itself
	var map: Map!
	
	//The average intensity of an EXISTING overlay
	//Does not include empty overlays
	var averageIntensity: Double = 1.0
	
	//The minimum cordinates of the map
	var minLat: Double!
	var minLong: Double!
	
	//The maximum cordinates of the map
	var maxLat: Double!
	var maxLong: Double!
	
	//All the disease data of people currently sick
	var data: Array<Disease>
	
	//The data structure that keeps track of the disease points
	var manager: DiseaseManager!
	
	//Initalizes this map with all its fields
	//Also begins to load the data and create the overlays
	//This class is only created when the DataCenter has proper disease data
	init(map: Map, longWidth: Double, latWidth: Double, startLong: Double, startLat: Double, data: Array<Disease>) {
		self.data = data
		
		self.minLat = startLat
		self.minLong = startLong
		
		self.maxLat = latWidth + startLat
		self.maxLong = longWidth + startLong
		
		self.map = map
		
		self.loadData()
		self.drawOverlays(toDraw: self.createOverlays())
	}
	
	func loadData() {
		self.manager = DiseaseManager()
		for dataPoint in data {
			manager.addDisease(lat: dataPoint.lat, long: dataPoint.long)
		}
	}
	
	// Combine create and process into one
	// Processes the array, and makes the visual graphic look slightly nicer
	func createOverlays() -> Array<DiseasePolygon> {
		
		//Keeps track of every diseasePolygon to draw
		var toDraw = Array<DiseasePolygon>()
		
		//Keeps track of what X,Y cordinates have polygons in them
		var averageCounter = Dictionary<String, Int>()
		//The total number of disease points in the region
		let total = manager!.getWeightForRange(curLatMin: minLat, curLatMax: maxLat, curLongMin: minLong, curLongMax: maxLong)
		
		//Removes every overlay from the map
		map.removeOverlays(map.overlays)
		
		//Keeps track of what lat,long region we are currently in
		var realLat = self.minLat!
		var realLong = self.minLong!
		
		//The total width of the map display
		let latWidth = (self.maxLat - self.minLat)
		let longWidth = (self.maxLong - self.minLong)
		
		//The number of degrees that fall into every block
		let scaleLat = latWidth / self.numLat
		let scaleLong = longWidth / self.numLong
		
		//The average intensity of every NON EMPTY overlay field
		self.averageIntensity = 0
		
		while realLat < self.maxLat {
			realLong = self.minLong!
			let deltaLat = realLat - self.minLat
			let posnLat =  Int(floor(deltaLat / scaleLat))
			while realLong < self.maxLong {
				//Gets the number of points in the current region
				let intensity = Double(manager!.getWeightForRange(curLatMin: realLat, curLatMax: realLat+scaleLat, curLongMin: realLong, curLongMax: realLong+scaleLong))
				//Does not inlucde of no intensity
				if(intensity != 0) {
					let deltaLong = realLong - self.minLong
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
			self.averageIntensity = Double(total / averageCounter.count)
		}
		
		return toDraw
	}
	
	//Adds all the overlays to the map\
	func drawOverlays(toDraw: Array<DiseasePolygon>) {
		for cur in toDraw {
			map.add(cur)
		}
	}
	
	func updateOverlay() {
		//Resets this creators fields based on the maps current fields
		let latWidth = map.region.span.latitudeDelta
		let longWidth = map.region.span.longitudeDelta
		self.minLat = map.region.center.latitude - latWidth
		self.minLong = map.region.center.longitude - longWidth
		self.maxLat = map.region.center.latitude + latWidth
		self.maxLong = map.region.center.longitude + longWidth
		
		// Calls create overlays
		self.drawOverlays(toDraw: self.createOverlays())
	}
	
}
