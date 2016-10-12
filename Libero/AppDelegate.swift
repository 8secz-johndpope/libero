//
//  AppDelegate.swift
//  Libero
//
//  Created by John Kotz on 9/30/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import UIKit
import Parse
import UserNotifications
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if let installation = PFInstallation.current() {
            installation.setDeviceTokenFrom(deviceToken)
        }
    }
    
//    private func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        if (error.code == 3010) {
//            print("Push notifications are not supported in the iOS Simulator.");
//        } else {
//            // show some alert or otherwise handle the failure to register.
//            print("application:didFailToRegisterForRemoteNotificationsWithError: \(error)");
//        }
//    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        if (error._code == 3010) {
            print("Push notifications are not supported in the iOS Simulator.");
        } else {
            // show some alert or otherwise handle the failure to register.
            print("application:didFailToRegisterForRemoteNotificationsWithError: \(error)");
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        PFAnalytics.trackAppOpened(launchOptions: userInfo)
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Parse.setLogLevel(.error)
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
        
        
        let parseConfig = ParseClientConfiguration {
            $0.applicationId = "vparU3ObgnU7Fl9mQMwKGrI0GaK1kXfcFKq7UpXS"
            $0.clientKey = ""
            $0.server = "https://libero-parse.herokuapp.com/parse"
        }
        Parse.initialize(with: parseConfig)
        
        
        PFAnalytics.trackAppOpened(launchOptions: launchOptions)
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
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
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

