//
//  BaseUIViewController+NotificationCenter.swift
//  BookStore
//
//  Created by Amr Elghadban on 27/12/2021.
//  Copyright © 2021 ADKA Tech. All rights reserved.
//

import UIKit

// MARK: - NotificationCenter
extension UIViewController {
    
    @objc
    func receivedNotification(_ notification: Notification) {
        // let userInfo = notification.userInfo
        guard let message = notification.object as? NotificationMessage else {
            return
        }
        debugPrint("Notification received: \(message)")
    }
}
