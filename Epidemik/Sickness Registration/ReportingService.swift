//
//  ReportingService.swift
//  Epidemik
//
//  Created by Ryan Bradford on 12/17/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

public class Reporting {
	
	static var FILE_NAME = "sickness.epi"
	
	//Reports that this user is sick with these synptoms and disease name
	//EFFECT: make sickness.epi non-null
	public static func amSick(diseaseName: String, symptoms: Array<Int>) {
		FileRW.writeFile(fileName: "sickness.epi", contents: "sick")
		NetworkAPI.setSick(username: FileRW.readFile(fileName: "username.epi")!, diseaseName: diseaseName, symptoms: symptoms)
	}
	
	//Reports that this user is healthy
	//EFFECT: deletes sickness.epi
	public static func amHealthy() {
		FileRW.writeFile(fileName: FILE_NAME, contents: "")
		NetworkAPI.setHealthy(username: FileRW.readFile(fileName: "username.epi")!)
	}
	
}
