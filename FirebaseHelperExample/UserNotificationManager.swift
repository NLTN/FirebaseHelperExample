//
//  UserNotificationManager.swift
//  TabbedAppNotif
//
//  Created by Nguyen Nguyen on 12/21/16.
//  Copyright © 2016 Nguyen Nguyen. All rights reserved.
//

import UIKit
import UserNotifications

enum NotificationActions: String {
    case HighFive = "highfiveidentifier"
}

class NotificationManager: NSObject {

    // MARK: - Internal Variables
    internal let notificationDelegate = DefaultDelegate()

    func registerForNotifications() {

        let application = UIApplication.shared

        // IOS 10.0
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                if granted {
                    print("Authorization granted")
                    self.setupAndGenerateLocalNotification()
                }
            }
        } else {
            // Since IOS 8.0
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            
        }
        
        application.registerForRemoteNotifications()

    }
    
    
    @available(iOS 10.0, *)
    func setupAndGenerateLocalNotification() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { granted, error in
//            // handle error if there is one
//        })
        
        print("generate notification")
        
        let answerOne = UNNotificationAction(identifier: "answerOne", title: "29", options: [.foreground])
        let answerTwo = UNNotificationAction(identifier: "answerTwo", title: "55", options: [.foreground])
        let clue = UNNotificationAction(identifier: "clue", title: "Get a clue...", options: [.foreground])

        let quizCategory = UNNotificationCategory(identifier: "quizCategory", actions: [answerOne, answerTwo, clue], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([quizCategory])


        // Notification Delegate
        UNUserNotificationCenter.current().delegate = notificationDelegate
    }

    func sendNotification(title: String, subtitle: String, body: String, userInfo:[AnyHashable : Any]?, badge: NSNumber?, categoryID: String, timeInterval: Double) {
        
        if #available(iOS 10.0, *) {
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.subtitle = subtitle
            content.body = body
            content.badge = badge
            content.categoryIdentifier = categoryID
            
            if userInfo != nil {
                content.userInfo = userInfo!
            }
            
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            
            let requestIdentifier = "africaQuiz"
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                // handle error
            })
            
        } else {
            print("IOS 8.0 - send notification")
            // create a corresponding local notification
            let notification = UILocalNotification()
            notification.alertBody = body // text that will be displayed in the notification
            notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
            notification.fireDate = Date(timeInterval: timeInterval, since: Date()) // todo item due date (when notification will be fired)
            notification.soundName = UILocalNotificationDefaultSoundName // play default sound
            if badge != nil {
                notification.applicationIconBadgeNumber = badge as! Int
            } else {
                notification.applicationIconBadgeNumber = 0
            }
            
            notification.userInfo = userInfo // assign a unique identifier to the notification so that we can retrieve it later
            notification.category = categoryID
            UIApplication.shared.scheduleLocalNotification(notification)
            
        }
    }
    
    func sendAnExampleNotification() {
        print(">>sendAnExampleNotification")
        sendNotification(title: "Updates", subtitle: "Database updates available", body: "You should udate your DB right now", userInfo: nil, badge: nil, categoryID: "quizCategory", timeInterval: 3)
    }
}
extension NotificationManager {
    // Notification Delegate
    class DefaultDelegate: NSObject, UNUserNotificationCenterDelegate {
        // Handler when the app is in foreground
        @available(iOS 10.0, *)
        public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            // some other way of handling notification
            
            // Show Notification when the app is in foreground
            completionHandler([.alert, .sound])
        }
        
        // Notification's Action
        @available(iOS 10.0, *)
        public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            
            switch response.actionIdentifier {
            case "answerOne":
                // imageView.image = UIImage(named: "wrong")
                print(">> Wrong")
                break
            case "answerTwo":
                // imageView.image = UIImage(named: "correct")
                print(">> Correct")
                break
            case "clue":
                
                let alert = UIAlertController(title: "Hint", message: "The answer is greater than 29", preferredStyle: .alert)
                let action = UIAlertAction(title: "Thanks!", style: .default, handler: nil)
                alert.addAction(action)
                //present(alert, animated: true, completion: nil)
                break
            default:
                break
            }
            completionHandler()
            
        }
    }
}

extension AppDelegate {
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TodoListShouldRefresh"), object: self)
        
        print(">>Notification Received.")
        
        //application.presentLocalNotificationNow(notification)
        
        
        UIApplication.shared.scheduledLocalNotifications?.removeAll()
        
        UIAlertView(title: "notification.alertTitle", message: notification.alertBody, delegate: nil, cancelButtonTitle: "OK").show()
        
        
    }
}
