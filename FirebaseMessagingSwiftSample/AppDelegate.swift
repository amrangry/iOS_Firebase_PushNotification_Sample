//
//  AppDelegate.swift
//  FirebaseMessagingSwiftSample
//
//  Created by Amr Elghadban on 10/01/2022.
//

import UIKit
import UserNotifications

import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    public static var shared: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    var window: UIWindow?
    static let notificationManager = PushNotificationManager.shared
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication
                                                                    .LaunchOptionsKey: Any]?) -> Bool {
        /* Use Firebase library to configure APIs */
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        //PushNotification
        Self.notificationManager.configureUserNotificationIfNeeded()
        
        // Check if launched from the remote notification and application is close
        // When the app launch after user tap on notification (originally was not running / not in background)
        if let remoteNotification = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
            // Do what you want to happen when a remote notification is tapped.
            //let aps = remoteNotification["aps" as String] as? [String: AnyObject]
            //let apsString = String(describing: aps)
            //UserDefaults.standard.set(apsString, forKey: "remoteNotification")
            // SetupRootView if needed
            // setupRootViewController()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                Self.notificationManager.proceedWithReceivedNotification(apsMessage: remoteNotification)
            })
        }
        
        return true
    }

}
