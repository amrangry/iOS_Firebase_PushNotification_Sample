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
    let type: String?
    let linkedID: String?
    
    init?(_ userInfo: [AnyHashable: Any?]) {
        if let messageID = userInfo[gcmMessageIDKey] as? String {
            Debugger().printOut("FCM Message ID: \(messageID)", context: .none)
        }
        
        let aps = userInfo["aps"] as? [String: Any?]
        let badge = aps?["badge"] as? String
        
        let alert = aps?["alert"] as? [String: Any?]
        let title = alert?["title"] as? String
        let body = alert?["body"] as? String
        
        let options = userInfo["fcm_options"] as? [String: Any?]
        let image = options?["image"] as? String
        
        let type = userInfo["type"] as? String //nil
        let linkedID = userInfo["linked_id"] as? String //nil
        
        self.badge = badge
        self.title = title
        self.body = body
        self.image = image
        self.type = type
        self.linkedID = linkedID
    }
    
    // let notificationMessage =  NotificationMessage.tempTest()
    // NotificationCenter.default.post(name: .pushNotificationReceived, object: notificationMessage, userInfo: nil)
    static func tempTest() -> NotificationMessage? {
        var userInfo: [AnyHashable: Any?] = ["gcm.message_id": "1234567",
                                             "fcm_options": ["image": "https://www.aseeralkotb.com/storage/media/257344/conversions/%D9%81%D8%AC%D8%B1-%D8%A5%D9%8A%D8%A8%D9%8A%D8%B1%D9%8A%D8%A9-16975-200x300-webp.webp"],
                                             "aps":
                                                ["alert":
                                                    [
                                                        "title": "فجر إيبيرية",
                                                        "body": "لم تك أيامًا عادية فما قبل الفجر ليل طويل حالك أرخى سدوله الظالمة، وتصارعت فيه ‏وحوش نكراء، أجدبت شبه الجزيرة الغناء، وباتت شبحًا مخيفًا توارى منه الحبُ غير آسف.‏حتى وقع موعدٌ فارقٌ، لقاء الهوى والوغى، حين أصابت سهام الحق قلب الشفق فخُط فاصل ‏عهد وبداية مجد.‏ فأشرقت الشمس تاجًا على العروس الحسناء"
                                                    ],
                                                 "badge": 95
                                                ]
        ]
        userInfo["type"] = "book"
        userInfo["linked_id"] = "4"
        let temp = NotificationMessage(userInfo)
        return temp
    }
    
    //    let newsModel = NewsModel()
    //    let decoder = JSONDecoder()
    //    decoder.dateDecodingStrategy = .iso8601
    //    guard
    //      let url = Bundle.main.url(forResource: "MockNewsItems", withExtension: "json"),
    //      let data = try? Data(contentsOf: url),
    //      let newsItems = try? decoder.decode([NewsItem].self, from: data)
    //    else {
    //      return newsModel
    //    }
    
}
