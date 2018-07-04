//
//  Map.swift
//  Epidemik
//
//  Created by Ryan Bradford on 10/1/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class Map: MKMapView, MKMapViewDelegate, UIGestureRecognizerDelegate {
	
	// The field that creates the overlays
	var overlayCreator: MapOverlayCreator!
	
	//The data center which gathers the data
	var dataCenter: DataCenter!
	
	//Whether the loading animation should run
	var isLoading = true
	
	//The settings button for the map
	var settingsButton: UIButton!
	
	// Creates the map view, given a view frame, a lat,long width in meters, and a start lat,long in degrees
	// OTHER: starts the loading animation
	init(frame: CGRect, settingsButton: UIButton) {
		super.init(frame: frame)
		self.accessibilityIdentifier = "Map"
		self.settingsButton = settingsButton
		
		doLoadingAnimation()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	//Creates all the map fields
	//EFFECT: creates all the data for the map and draws everything
	func initAfterData() {
		initOverlayCreator()
		initMapPrefs()
		initGestureControls()
	}
	
	//Runs the loading animation
	//EFFECT: repeats until isLoading is false
	func doLoadingAnimation() {
		UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
			self.settingsButton.transform = self.settingsButton.transform.rotated(by: .pi)
		}) { finished in
			if(self.isLoading) {
				self.doLoadingAnimation()
			}
		}
	}
	
	// Uses the MapKit to create the map display
	//EFFECT: updates this map for the given preferences
	func initMapPrefs() {
		self.mapType = MKMapType.standard
		self.delegate = self
		let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(39), longitude: CLLocationDegrees(-98))
		let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: CLLocationDegrees(120), longitudeDelta: CLLocationDegrees(120)))
		self.setRegion(region, animated: true)
		self.isRotateEnabled = false
	}
	
	//Creates the overlay creator
	//EFFECT: creates a new overlay creator and updates the map overlays
	func initOverlayCreator() {
		let region = self.region
		let latWidth = region.span.latitudeDelta*2 //I dont know why this is *2
		let longWidth = region.span.longitudeDelta*2 //I dont know why this is *2
		let startLat = region.center.latitude
		let startLong = region.center.longitude
		overlayCreator = MapOverlayCreator(map: self, longWidth: longWidth, latWidth: latWidth, startLong: startLong - longWidth/2, startLat: startLat - latWidth/2, data: dataCenter.getDiseaseData())
	}
	
	//Updates the overlay creator
	//EFFECT: creates a new overlay creator and updates the map overlays
	func updateOverlays() {
		let region = self.region
		let latWidth = region.span.latitudeDelta
		let longWidth = region.span.longitudeDelta
		let startLat = region.center.latitude
		let startLong = region.center.longitude
		overlayCreator = MapOverlayCreator(map: self, longWidth: longWidth, latWidth: latWidth, startLong: startLong - longWidth/2, startLat: startLat - latWidth/2, data: dataCenter.getDiseaseData())
	}
	
	// The function that is called when the map draws a new overlay
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		let dataPolygon = overlay as! DiseasePolygon
		
		let polygonView = MKPolygonRenderer(overlay: overlay)
		
		let power = CGFloat(dataPolygon.intensity / overlayCreator.averageIntensity)
		let color = PRESETS.getOverlayColor(weight: power)
		polygonView.strokeColor = color
		polygonView.fillColor = color
		return polygonView
	}
	
	//Makes it so you can move around the map
	func initGestureControls() {
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didDragMap))
		// make your class the delegate of the pan gesture
		panGesture.delegate = self
		
		// add the gesture to the mapView
		self.addGestureRecognizer(panGesture)
	}
	
	// Resolves conflicts with other gesture recognizers
	// But honestly I don't know why this method exists
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	
	//If the user moves, the overlays update
	@objc func didDragMap(sender: UIGestureRecognizer!) {
		if sender.state == .ended {
			overlayCreator.updateOverlay()
		}
	}

	//If the user zooms too far, it unzooms to save privacy
	func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		if mapView.getZoomLevel() > 10 {
			mapView.setCenter(coordinate: mapView.centerCoordinate, zoomLevel: 10, animated: true)
		}
	}
	
}
