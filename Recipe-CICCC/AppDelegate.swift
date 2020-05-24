//
//  AppDelegate.swift
//  Recipe-CICCC
//
//  Created by Argus Chen on 2019-12-10.
//  Copyright © 2019 Argus Chen. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn
import GoogleMaps
import GooglePlaces
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate{
    
    let apiKey = "AIzaSyA8iI9CDqKxnyvCAuWoBbSyZYdRqf_WQLk"

    var window: UIWindow?
    
    let statusBarTappedNotification = Notification(name: Notification.Name(rawValue: "statusBarTappedNotification"))


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let apiKey = KeyManager().getValue(key: "apiKey") as? String {
            GMSServices.provideAPIKey(apiKey)
            GMSPlacesClient.provideAPIKey(apiKey)
            print("\n Hello \(apiKey)\n")
        }
        
//        Fabric.sharedSDK().debug = true
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance()?.clientID = "247475802290-slfc1mtet3ilq9at7m5nqg1rtom53ggo.apps.googleusercontent.com"//FirebaseApp.app()?.options.clientID
        UINavigationBar.appearance().tintColor = UIColor.orange
        UINavigationBar.appearance().barTintColor = UIColor.white
//
//
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//            options: authOptions,
//            completionHandler: {_, _ in })
//            // For iOS 10 data message (sent via FCM
//            Messaging.messaging().delegate = self
//        } else {
//            let settings: UIUserNotificationSettings =
//            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//              application.registerUserNotificationSettings(settings)
//        }
//
//        application.registerForRemoteNotifications()
//
//        Messaging.messaging().delegate = self
        
         FirebaseApp.configure()
         
        return true
    }
    
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        
    }
    
    // Facebook signin
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        var handled = false
        
        if url.absoluteString.contains("fb") {
            handled = ApplicationDelegate.shared.application(app, open:url, options: options)
        } else {
            handled = GIDSignIn.sharedInstance().handle(url)
        }
        
        return handled
    }

    
   
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)

            let statusBarRect = UIApplication.shared.statusBarFrame
            guard let touchPoint = event?.allTouches?.first?.location(in: self.window) else { return }

            if statusBarRect.contains(touchPoint) {
                NotificationCenter.default.post(statusBarTappedNotification)
            }
        }
//
//    // The callback to handle data message received via FCM for devices running iOS 10 or above.
//    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
//        print(remoteMessage.appData)
//    }
    
    
 
}

