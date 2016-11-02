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
import ParseFacebookUtils

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if let installation = PFInstallation.current() {
            installation.setDeviceTokenFrom(deviceToken)
        }
    }
    
    static func shouldSkipSurvey() -> Bool {
        let val = ProcessInfo.processInfo.environment["skipSurvey"]
        return val != nil && val! == "yes"
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
        
        User.registerSubclass()
        User.ProfilePic.registerSubclass()
        League.registerSubclass()
        Workout.registerSubclass()
        Achievement.registerSubclass()
        
        let parseConfig = ParseClientConfiguration {
            $0.applicationId = "vparU3ObgnU7Fl9mQMwKGrI0GaK1kXfcFKq7UpXS"
            $0.clientKey = ""
            $0.server = "https://libero-parse.herokuapp.com/parse"
        }
        Parse.initialize(with: parseConfig)
        
        
        PFAnalytics.trackAppOpened(launchOptions: launchOptions)
        
        PFFacebookUtils.initializeFacebook()
        PFFacebookUtils.setFacebookLoginBehavior(.useSystemAccountIfPresent)
//        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if let user = User.current() {
            if user.completedSetup || AppDelegate.shouldSkipSurvey() { // add skipSurvey to environment variables to skip survey
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                self.window?.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabController")
            }else{
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                self.window?.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "formerNav") as! UINavigationController
            }
        }
        
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
//        FBSDKAppEvents.activateApp()
        FBAppCall.handleDidBecomeActive(with: PFFacebookUtils.session())
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBAppCall.handleOpen(url, sourceApplication: sourceApplication, with: PFFacebookUtils.session())
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

