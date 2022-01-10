//
//  ViewController.swift
//  FirebaseMessagingSwiftSample
//
//  Created by Amr Elghadban on 10/01/2022.
//
import UIKit
import Firebase

@objc(ViewController)
class ViewController: UIViewController {
    
    
    @IBOutlet weak var deviceTokenLabel: UILabel?
    @IBOutlet weak var fcmTokenLabel: UILabel?
    
    
    @IBAction func showDeviceTokenButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func shareDeviceTokenButtonPressed(_ sender: Any) {
    }
    
    @IBAction func showFCMTokenButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func shareFCMDeviceTokenButtonPressed(_ sender: Any) {
    }
    
    
    
  @IBOutlet var fcmTokenMessage: UILabel!
  @IBOutlet var remoteFCMTokenMessage: UILabel!

  override func viewDidLoad() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(displayFCMToken(notification:)),
      name: Notification.Name("FCMToken"),
      object: nil
    )
  }

  @IBAction func handleLogTokenTouch(_ sender: UIButton) {
    // [START log_fcm_reg_token]
    let token = Messaging.messaging().fcmToken
    print("FCM token: \(token ?? "")")
    // [END log_fcm_reg_token]
    fcmTokenMessage.text = "Logged FCM token: \(token ?? "")"

    // [START log_iid_reg_token]
    Messaging.messaging().token { token, error in
      if let error = error {
        print("Error fetching remote FCM registration token: \(error)")
      } else if let token = token {
        print("Remote instance ID token: \(token)")
        self.remoteFCMTokenMessage.text = "Remote FCM registration token: \(token)"
      }
    }
    // [END log_iid_reg_token]
  }

  @IBAction func handleSubscribeTouch(_ sender: UIButton) {
    // [START subscribe_topic]
    Messaging.messaging().subscribe(toTopic: "weather") { error in
      print("Subscribed to weather topic")
    }
    // [END subscribe_topic]
  }

  @objc func displayFCMToken(notification: NSNotification) {
    guard let userInfo = notification.userInfo else { return }
    if let fcmToken = userInfo["token"] as? String {
      fcmTokenMessage.text = "Received FCM token: \(fcmToken)"
    }
  }
}
