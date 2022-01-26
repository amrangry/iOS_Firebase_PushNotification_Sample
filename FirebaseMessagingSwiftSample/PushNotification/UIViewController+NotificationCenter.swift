//
//  BaseUIViewController+NotificationCenter.swift
//  BookStore
//
//  Created by Amr Elghadban on 27/12/2021.
//  Copyright © 2021 ADKA Tech. All rights reserved.
//

import Foundation
import SwiftMessages

// MARK: - NotificationCenter
extension UIViewController {
    
    @objc
    func receivedNotification(_ notification: Notification) {
        // let userInfo = notification.userInfo
        guard let message = notification.object as? NotificationMessage else {
            return
        }
        Debugger().printOut("Notification received: \(message)", context: .debug)
        display(type: message.type, id: message.linkedID)
        //displayPopUpNotificationBanner(message)
    }
    
    func display( type: String?, id: String?) {
        guard let typeValue = type, let idValue = id else { return }
        NavigationRouter.shared.show(type: typeValue, id: idValue)
    }
    
    func displayPopUpNotificationBanner(_ message: NotificationMessage) {
        let truncatedTo = 110
        var body = message.body
        if let count = body?.count, count > truncatedTo {
            body = body?.trimIfEmpty()?.truncated(limit: truncatedTo, position: .tail, leader: "read_more".localized) ?? ""
        }
        DispatchQueue.main.async {
            let messageView = MessageView.viewFromNib(layout: .messageView)
            messageView.configureTheme(.info)
            messageView.configureDropShadow()
            messageView.configureContent(title: message.title ?? "", body: body ?? "")
            // Hide when message view tapped
            messageView.tapHandler = { [weak self] _ in
                self?.display(type: message.type, id: message.linkedID)
                SwiftMessages.hide()
            }
            let theme = ThemeManager.default.theme
            messageView.backgroundView.backgroundColor = theme.notificationBackground
            messageView.backgroundView.layer.cornerRadius = 10
            messageView.titleLabel?.textColor = theme.notificationTitle
            messageView.bodyLabel?.textColor =  theme.notificationBody
            messageView.iconImageView?.isHidden = true
            messageView.button?.isHidden = true
            var config = SwiftMessages.defaultConfig
            config.presentationStyle = .top
            config.duration = .forever
            config.dimMode = .gray(interactive: true)   // blur(style: .dark, alpha: 1, interactive: true)
            config.presentationContext = .window(windowLevel: .normal)
            SwiftMessages.show(config: config, view: messageView)
        }
        
        //        let url = URL(string: message.image ?? "")
        //        var image: UIImage?
        //        UIImageView().setImage(url, nil) { result in
        //            guard let new = result else { return }
        //            print("new")
        //            image = new.resized(to: CGSize(width: 75, height: 100))
        //            DispatchQueue.main.async {
        //                let messageView = MessageView.viewFromNib(layout: .messageView)
        //                messageView.configureTheme(.info)
        //                messageView.configureDropShadow()
        //                messageView.configureContent(title: message.title ?? "", body: body ?? "")
        //                // Hide when message view tapped
        //                messageView.tapHandler = { [weak self] _ in
        //                    self?.display(type: message.type, id: message.linkedID)
        //                    SwiftMessages.hide()
        //                }
        //                let theme = ThemeManager.default.theme
        //                messageView.backgroundView.backgroundColor = theme.tintColor
        //                messageView.backgroundView.layer.cornerRadius = 10
        //                messageView.titleLabel?.textColor = theme.textTitleOnTintColor
        //                messageView.bodyLabel?.textColor =  theme.textTitleOnTintColor
        //                messageView.iconImageView?.isHidden = false
        //                messageView.iconImageView?.image = image
        //                messageView.button?.isHidden = true
        //                //messageView.button?.setTitleColor(theme.textButton, for: .normal)
        //                //messageView.button?.backgroundColor = theme.tintColor
        //                var config = SwiftMessages.defaultConfig
        //                config.presentationStyle = .top
        //                config.duration = .forever
        //                config.dimMode = .gray(interactive: true)   // blur(style: .dark, alpha: 1, interactive: true)
        //                config.presentationContext = .window(windowLevel: .normal)
        //                SwiftMessages.show(config: config, view: messageView)
        //            }
        //        }
        
        //        var itemID : Int
        //        var isArticale: Bool = false
        //        guard let aps = notification.userInfo?["aps"] as? [String: AnyObject] else {
        //            print("No userInfo found in notification")
        //            return
        //        }
        //        let payload = aps["payload"] as? [String: Any]
        //        // must have value in order to push correct vc
        //        guard let link_url = aps ["link_url"] else {
        //            print("No linkurl for id")
        //            return
        //        }
        //        itemID = link_url as! Int
        //        guard let payload_type = aps["payload_type"] as? String else {
        //            return
        //        }
        //        if payload_type == Constants.NotificationKey.PAYLOAD_TYPE_NEWs {
        //            let newsItem = payload.flatMap(NewsItem.init)
        //            print(newsItem?.title ?? "empty news")
        //            isArticale = false
        //        }else if payload_type == Constants.NotificationKey.PAYLOAD_TYPE_Articale {
        //            let article = payload.flatMap(Article.init)
        //            print(article?.title ?? "empty article")
        //            isArticale = true
        //        }
        //        guard let reciviedNotifcationObject =  notification.object as? String else{
        //            displayArticaleORNews(isArticale: isArticale, itemID: itemID)
        //            return
        //        }
        //        let titleTODisplayinMessageBody = aps["alert"] as? String ?? Constants.StringLocalizedKey.Swip_TO_Dismiss.localized
        //        if reciviedNotifcationObject == Constants.GlobalVariables.IS_Display_Notification {
        //            DispatchQueue.main.async {
        //                let messageView = MessageView.viewFromNib(layout: .messageView)
        //                messageView.configureTheme(.info)
        //                messageView.configureDropShadow()
        //                messageView.configureContent(title: Constants.StringLocalizedKey.NOTIFACTION_MESSAGE.localized,
        //body: titleTODisplayinMessageBody, iconImage: nil, iconText: "", buttonImage: nil, buttonTitle: Constants.StringLocalizedKey.NOTIFACTION_MESSAGE_BUTTON_OPEN_TITLE.localized ) { _ in
        //                    self.displayArticaleORNews(isArticale: isArticale, itemID: itemID)
        //                    SwiftMessages.hide()
        //                }
        //                messageView.backgroundView.backgroundColor = Constants.Theme.mainColor
        //                messageView.backgroundView.layer.cornerRadius = 10
        //                messageView.bodyLabel?.textColor = Constants.Theme.overMainColor
        //                messageView.titleLabel?.textColor = Constants.Theme.overMainColor
        //                messageView.button?.setTitleColor(UIColor.white, for: .normal)
        //                messageView.button?.backgroundColor = Constants.Theme.btnColor
        //                var messageViewConfig = SwiftMessages.defaultConfig
        //                messageViewConfig.presentationStyle = .top
        //                messageViewConfig.duration = .automatic
        //                messageViewConfig.dimMode = .gray(interactive: true)   // blur(style: .dark, alpha: 1, interactive: true)
        //                messageViewConfig.presentationContext = .window(windowLevel: UIWindowLevelNormal)
        //                SwiftMessages.show(config: messageViewConfig, view: messageView)
        //            }
        //        }
    }
    
}
