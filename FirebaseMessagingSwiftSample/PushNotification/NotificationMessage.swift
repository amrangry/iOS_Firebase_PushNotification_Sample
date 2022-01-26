//
//  NotificationMessage.swift
//  BookStore
//
//  Created by Amr Elghadban on 13/01/2022.
//  Copyright © 2022 ADKA Tech. All rights reserved.
//

import Foundation

struct NotificationMessage {
    
    private let gcmMessageIDKey = "gcm.message_id"
    
    let badge: String?
    let title: String?
    let body: String?
    let image: String?
    let customeKey1: String?
    let customeKey2: String?
    
    init?(_ userInfo: [AnyHashable: Any?]) {
        if let messageID = userInfo[gcmMessageIDKey] as? String {
            debugPrint("FCM Message ID: \(messageID)")
        }
        
        let aps = userInfo["aps"] as? [String: Any?]
        let badge = aps?["badge"] as? String
        
        let alert = aps?["alert"] as? [String: Any?]
        let title = alert?["title"] as? String
        let body = alert?["body"] as? String
        
        let options = userInfo["fcm_options"] as? [String: Any?]
        let image = options?["image"] as? String
        
        let customeKey1 = userInfo["customeKey1"] as? String //nil
        let customeKey2 = userInfo["customeKey2"] as? String //nil
        
        self.badge = badge
        self.title = title
        self.body = body
        self.image = image
        
        self.customeKey1 = customeKey1
        self.customeKey2 = customeKey2
    }
    
    // let notificationMessage =  NotificationMessage.tempTest()
    // NotificationCenter.default.post(name: .pushNotificationReceived, object: notificationMessage, userInfo: nil)
    static func tempTest() -> NotificationMessage? {
        var userInfo: [AnyHashable: Any?] = ["gcm.message_id": "1234567",
                                             "fcm_options": ["image": "Https//image.com"],
                                             "aps":
                                                ["alert":
                                                    [
                                                        "title": "title here to display",
                                                        "body": "body here to show"
                                                    ],
                                                 "badge": 95
                                                ]
        ]
        userInfo["customeKey1"] = "value customeKey1"
        userInfo["customeKey2"] = "value customeKey2"
        let temp = NotificationMessage(userInfo)
        return temp
    }
    
}
