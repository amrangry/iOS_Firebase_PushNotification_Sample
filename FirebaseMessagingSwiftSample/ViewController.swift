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
        
    deinit {
        NotificationCenter.default.removeObserver(self, name: .apnToken, object: nil)
        NotificationCenter.default.removeObserver(self, name: .fcmToken, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(displayDeviceToken(notification:)),
            name: .apnToken,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(displayFCMToken(notification:)),
            name: .fcmToken,
            object: nil
        )
    }
    
    @objc
    func displayFCMToken(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let fcmToken = userInfo["token"] as? String {
            let text = "Received FCM token: \(fcmToken)"
            setFCMToken(text)
        }
    }
    
    @IBAction func showDeviceTokenButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func shareDeviceTokenButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func showFCMTokenButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func shareFCMDeviceTokenButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func handleLogTokenTouch(_ sender: UIButton) {
        let token = Messaging.messaging().fcmToken
        self.setFCMToken("Logged FCM token: \(token ?? "")")
        
        Messaging.messaging().token { [weak self] token, error in
            guard let self = self else { return }
            var value = ""
            if let error = error {
                value = "Error fetching remote FCM registration token: \(error)"
            } else if let token = token {
                value = "Remote FCM registration token: \(token)"
            }
            self.setFCMToken(value)
        }
    }
    
    @IBAction func handleSubscribeTouch(_ sender: UIButton) {
        Messaging.messaging().subscribe(toTopic: "weather") { error in
            print("Subscribed to weather topic")
        }
    }
    
    func setFCMToken(_ token: String) {
        DispatchQueue.main.async {
            self.fcmTokenLabel?.text = token
        }
    }
    
    func setDeviceToken(_ token: String) {
        DispatchQueue.main.async {
            self.deviceTokenLabel?.text = token
        }
    }
    
}
