//
//  PushNotificationManager.swift
//  BookStore
//
//  Created by Amr Elghadban on 28/12/2021.
//  Copyright © 2021 ADKA Tech. All rights reserved.
//

import UIKit
import FirebaseMessaging

enum NotificationEnumLevel: String {
    case fcm
    
    var value: String {
        self.rawValue
    }
}

enum NotificationPermissionStatus: String {
    case denied // The application is not authorized to post user notifications.
    case notDetermined // The user has not yet made a choice regarding whether the application may post user notifications.
    case authorized /* The application is authorized to post user notifications. */
    
    var value: String {
        self.rawValue
    }
}

class PushNotificationManager: NSObject {
    // MARK: - Push Notification
    static let serviceName = "PushNotifications"
    private let apnViewActionIdentifier = "pushNotificationViewActionIdentifier"
    private let apnCategoryIdentifier1 = "pushNotificationXYZCategoryIdentifier"
    private let apnCategoryIdentifier2 = "pushNotificationXYZCategoryIdentifier_2"
    static let tokenKey = "toke"
    
    // Alternatively, you can listen for an NSNotification named kFIRMessagingRegistrationTokenRefreshNotification
    // rather than supplying a delegate method. The token property always has the current token value.
    
    static let shared = PushNotificationManager()
    
    private override init() {
        super.init()
        
        //Firebase Messaging -PushNotification-
        Messaging.messaging().delegate = self
        //the library uploads the identifier and configuration data to Firebase
        Messaging.messaging().isAutoInitEnabled = true
    }
    
    /// 1- Check for push notification settings and act according
    /// - Parameter application: UIApplication
    func configureUserNotificationIfNeeded() {
        // Request Notification Settings
        getNotificationSettings(completion: { [weak self] permission in
            switch permission {
            case .denied: // Application Not Allowed to Display Notifications
                break
            case .notDetermined:
                self?.requestPushNotificationPermission()
            case .authorized:
                // Schedule Local Notification or Remote Notification
                // self.registerForPushNotifications()
                // self.scheduleLocalNotification()
                // notificationSettings.badgeSetting
                
                /*
                 * Scenario
                 1- user first denied push notification request.
                 2- User Allow notification via app settings in device settings.
                 */
                self?.requestPushNotificationPermission()
            }
        })
        
    }
    
    /// getting Notification permission status
    /// - Returns: NotificationPermissionStatus
    @available(iOS 13.0.0, *)
    func notificationSettingsPermission() async -> NotificationPermissionStatus {
        // Request Notification Settings
        let userNotification = UNUserNotificationCenter.current()
        let notificationSettings = await userNotification.notificationSettings()
        debugPrint("Notification settings: \(notificationSettings)")
        switch notificationSettings.authorizationStatus {
        case .denied: // The application is not authorized to post user notifications.
            return .denied
        case .notDetermined: // The user has not yet made a choice regarding whether the application may post user notifications.
            return .notDetermined
        case .authorized, /* The application is authorized to post user notifications. */
                .provisional, /* The application is authorized to post non-interruptive user notifications. */
                .ephemeral: /* The application is temporarily authorized to post notifications. Only available to app clips. */
            return .authorized
        @unknown default:
            return .notDetermined
        }
    }
    
    /// getting Notification permission status
    /// - Parameter completion: ResultResponse with Success or Failure
    func getNotificationSettings(completion: @escaping ((NotificationPermissionStatus) -> Void)) {
        let userNotification = UNUserNotificationCenter.current()
        userNotification.getNotificationSettings { notificationSettings in
            debugPrint("Notification settings: \(notificationSettings)")
            switch notificationSettings.authorizationStatus {
            case .denied: // The application is not authorized to post user notifications.
                completion(.denied)
            case .notDetermined: // The user has not yet made a choice regarding whether the application may post user notifications.
                completion(.notDetermined)
            case .authorized, /* The application is authorized to post user notifications. */
                    .provisional, /* The application is authorized to post non-interruptive user notifications. */
                    .ephemeral: /* The application is temporarily authorized to post notifications. Only available to app clips. */
                completion(.authorized)
            @unknown default:
                break
            }
        }
    }
    
    /// 2- Request Authorization
    /// Register for remote notifications. This shows a permission dialog on first run, to
    /// show the dialog at a more appropriate time move this registration accordingly.
    func requestPushNotificationPermission() {
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.badge, .sound, .alert,
                                                       .criticalAlert, .providesAppNotificationSettings,
                                                       .provisional]
            UNUserNotificationCenter.current().requestAuthorization( options: authOptions, completionHandler: { [unowned self] granted, error in
                //Enable or disable features based on authorization.
                if let error = error {
                    debugPrint(error)
                    return
                }
                guard granted else { /* Don't Allow */ return }
                self.registerForPushNotifications()
            })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    
    /// 3- register device for APN by sending device token and language id
    func registerForPushNotifications() {
        // Schedule Local Notification or Remote Notification
        // 1
        let viewAction = UNNotificationAction(identifier: apnViewActionIdentifier, title: "View", options: [.foreground])
        // 2
        let category1 = UNNotificationCategory(identifier: apnCategoryIdentifier1, actions: [viewAction], intentIdentifiers: [], options: [])
        let category2 = UNNotificationCategory(identifier: apnCategoryIdentifier2, actions: [viewAction], intentIdentifiers: [], options: [])
        // 3
        UNUserNotificationCenter.current().setNotificationCategories([category1, category2])
        UNUserNotificationCenter.current().delegate = self
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    ///scheduleLocalNotification -Not used yet-
    private func scheduleLocalNotification() {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "Cocoacasts"
        notificationContent.subtitle = "Local Notifications"
        notificationContent.body = "In this tutorial, you learn how to schedule local notifications with the User Notifications framework."
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { error in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
    /// receivedNotificationMessageHandler
    /// - Parameter apsMessage: dictionary [AnyHashable: Any]
    func proceedWithReceivedNotification(apsMessage userInfo: [AnyHashable: Any]) {
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        UIApplication.shared.applicationIconBadgeNumber = 0
        let notificationMessage = NotificationMessage(userInfo)
        // You can determine your application state by
        let state = UIApplication.shared.applicationState
        switch state {
            // Do something when the app is active , app is in the background
        case .active:
            //open an dialog ask user display new coming notification
            NotificationCenter.default.post(name: .pushNotificationReceived, object: notificationMessage, userInfo: userInfo)
        case .background, .inactive:
            //can be cached to be used
            NotificationCenter.default.post(name: .pushNotificationReceived, object: notificationMessage, userInfo: userInfo)
        @unknown default:
            break
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate: (PushNotification)
extension PushNotificationManager: UNUserNotificationCenterDelegate {
    //* Receive displayed notifications for iOS 10 devices. ** while app opened will be invoked
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        //let userInfo = notification.request.content.userInfo
        //proceedWithReceivedNotification(apsMessage: userInfo)
        // Change this to your preferred presentation option
        //[.list] will only show the notification in the notification center (the menu that shows when you pull down from the top)
        //[.banner] will only pop down a banner from the top like a normal push notification
        //[.list, .banner] will do both: show the banner and also make sure it's on the list.
        var optionsSet: UNNotificationPresentationOptions = [.badge, .sound]
        if #available(iOS 14.0, *) {
            optionsSet.insert(.list)
            optionsSet.insert(.banner)
        } else if #available(iOS 10.0, *) {
            optionsSet.insert(.alert)
        }
        completionHandler([optionsSet])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // You can determine your application state by
        let state = UIApplication.shared.applicationState
        switch state {
            // Do something when the app is active , app is in the background
        case .active:
            //print("user tapped the notification bar when the app is in foreground")
            //open an dialog ask user display new coming notification
            proceedWithReceivedNotification(apsMessage: userInfo)
        case .inactive:
            //  print("user tapped the notification bar when the app is in background")
            //can be cached to be used
            proceedWithReceivedNotification(apsMessage: userInfo)
        case .background:
            proceedWithReceivedNotification(apsMessage: userInfo)
        @unknown default:
            break
        }
        
        completionHandler()
    }
}

// MARK: - MessagingDelegate: Firebase Messaging (PushNotification)
extension PushNotificationManager: MessagingDelegate {
    //[Firebase Messaging]:
    
    /// handling receiving FCM token Monitor token refresh
    /// Note: This callback is fired at each app startup and whenever a new token is generated.
    /// - Parameters:
    ///   - messaging: FIRMessaging
    ///   - fcmToken: String
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        //FCM token
        debugPrint("FCM Token: \(fcmToken ?? "N/A")")
    }
    
}

// MARK: - Messaging helper: AppDelegate call back (PushNotification)
extension PushNotificationManager {
    
    /// Available  prior to ios10
    /// If you are receiving a notification message while your app is in the background,
    /// this callback will not be fired till the user taps on the notification launching the application.
    /// - Parameter userInfo: [AnyHashable: Any]
    func didReceive(remoteNotification userInfo: [AnyHashable: Any]) {
        proceedWithReceivedNotification(apsMessage: userInfo)
    }
    
    /// Available  prior to ios10
    /// If you are receiving a notification message while your app is in the background,
    /// this callback will not be fired till the user taps on the notification launching the application.
    /// - Parameters:
    ///   - userInfo: [AnyHashable: Any]
    ///   - completionHandler: @escaping (UIBackgroundFetchResult)
    func didReceive( remoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                     -> Void) {
        proceedWithReceivedNotification(apsMessage: userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func didFailToRegister( forRemoteNotificationsWithError error: Error) {
        let value = "Unable to register for remote notifications: \(error.localizedDescription)"
        debugPrint(value)
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func didRegister( forRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //[Firebase Messaging]: With swizzling disabled you must set the APNs token here.
        Messaging.messaging().apnsToken = deviceToken
        let tokenParts = deviceToken.map { data -> String in
            // using String(decoding: deviceToken, as: UTF8.self) will return >> x}��i�Q�8��Lkʧ^�&V��*oˏB)�
            return String(format: "%02.2hhx", data)
        }
        let value = tokenParts.joined()
        print(value)
        Messaging.messaging().token { token, error in
            if let error = error {
                let errorMessage = "Error fetching FCM registration token: \(error)"
                debugPrint(errorMessage)
            } else if let fcmToken = token {
                //TODo you share token with server
                print(fcmToken)
            }
        }
    }
    
}
