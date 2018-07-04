//
//  StatusDataCenter.swift
//  Epidemik
//
//  Created by Ryan Bradford on 3/13/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import SwiftyJSON

class StatusDataCenter {
	
	var sicknessScreen: SicknessView!
	
	init(sicknessScreen: SicknessView) {
		self.sicknessScreen = sicknessScreen
	}
	
	//Inits the sickness buttons and writes the post string if applicable
	//EFFECT: initilizes the sicknessScreen with the proper boolean when done
	//Also stops any loading animations
	func getUserStatus() {
		NetworkAPI.amISickHuh(username: FileRW.readFile(fileName: "username.epi")!, result: {(response: JSON?) -> Void in
			sleep(1)
			if(response!.string! == "false") {
				DispatchQueue.main.sync {
					self.sicknessScreen.mainHolder.loadingView.stopAnimation()
					self.sicknessScreen.initButton(isSick: false)
				}
			} else {
				DispatchQueue.main.sync {
					self.sicknessScreen.mainHolder.loadingView.stopAnimation()
					self.sicknessScreen.initButton(isSick: true)
				}
			}
		})
	}
}
