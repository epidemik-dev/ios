//
//  AppDelegate.swift
//  Epidemik
//
//  Created by Ryan Bradford on 9/15/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	var mainVC: ViewController?
	var accCreation: LoginScreen?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		
		if CommandLine.arguments.contains("--reset") {
			FileRW.deleteFile(fileName: "username.epi")
			FileRW.deleteFile(fileName: "password.epi")
		}
		
		if CommandLine.arguments.contains("--login") {
			FileRW.writeFile(fileName: "username.epi", contents: "ryan")
			FileRW.writeFile(fileName: "password.epi", contents: "pass")
		}
		
		mainVC = ViewController()
		NetworkAPI.view = mainVC?.view
		
		let window = UIWindow(frame: UIScreen.main.bounds)
		window.rootViewController = mainVC
		window.makeKeyAndVisible()
		self.window = window
		return true
	}
	
	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}
	
	func applicationWillEnterForeground(_ application: UIApplication) {
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
	//If the user says no to notifications
	//EFFECT: creates an account with no deviceID
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		accCreation?.createAccount(deviceID: "null")
	}
	
	//If the user says yes to notifications
	//EFFECT: creates an account with the proper devID
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
		accCreation?.createAccount(deviceID: deviceTokenString)
	}
	
	//What is called when the user recieves a notification
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
	}

	//What is called when the user quicktouches something
	//SHOULD NEVER BE CALLED NOW
	func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
		completionHandler(shouldPerformActionFor(shortcutItem: shortcutItem, application: application))
	}
	
	//No clue
	private func shouldPerformActionFor(shortcutItem: UIApplicationShortcutItem, application: UIApplication) -> Bool {
		return false
	}

}

