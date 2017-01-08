//
//  AppDelegate.swift
//  FirebaseHelperExample
//
//  Created by Nguyen Nguyen on 12/22/16.
//  Copyright © 2016 Nguyen Nguyen. All rights reserved.
//

import UIKit
import UserNotifications

import FirebaseHelper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: - Notification Variables
    let notificationManger = NotificationManager()

    // MARK: - Firebase Helper Variables
    var firebaseNotification: FirebaseHelper.FirebaseNotification!

    // MARK: - Handlers
    // Message Handling
    func DidReceiveNotification(_ message: FirebaseHelper.FirebaseNotification.Message) {
        // Send a notification
        notificationManger.sendNotification(title: message.Title, subtitle: message.Subtitle, body: message.Body, userInfo: nil, badge: message.Badge, categoryID: "", timeInterval: 1)
    }
    
    // MARK: - Events
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let DocumentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print(DocumentDirectory)
        // Firebase - Initialize
        FirebaseHelper.registerForFirebase()
        
        // Notification - Register
        notificationManger.registerForNotifications()
        
        // [START FirebaseHelper-Notification]
        // Create a Firebase Helper instance.
        firebaseNotification = FirebaseHelper.FirebaseNotification(application)
        
        // Handler
        firebaseNotification.DidReceiveNotification = self.DidReceiveNotification
        // [END FirebaseHelper-Notification]

        
        // Login/Register
        CheckLoginStatus()
        
        return true
    }

    // [START receive_message - Available for IOS 8.* - 9.*]
    @available(iOS 8.0, *)
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        firebaseNotification.application(application, didReceiveRemoteNotification: userInfo)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the InstanceID token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        // FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        firebaseNotification.applicationDidBecomeActive(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        firebaseNotification.applicationDidBecomeActive(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    // MARK: - Functions
    func CheckLoginStatus() {
        if !FirebaseHelper.Authentication.IsSignedIn {
            // Present Login View Controller
            self.window!.rootViewController = LoginViewController.instanceFromNib()
        }
    }
}
