//
//  WhatsNewHandler.swift
//  harbaughsim16
//
//  Created by Akshay Easwaran on 4/1/19.
//  Copyright © 2019 Akshay Easwaran. All rights reserved.
//

import UIKit
import WhatsNew

@objc class WhatsNewHandler: NSObject {
    
    public var updatedItems: Array<Dictionary<String, String>> = []
    
    @objc convenience init(items: Array<Dictionary<String, String>>) {
        self.init()
        self.updatedItems = items
    }
    
    @objc public func displayWhatsNewView(onViewController: UIViewController) {
        
        var wnItems: Array<WhatsNewItem> = []
        for item in self.updatedItems {
            if (item.keys.contains("image")) {
                wnItems.append(WhatsNewItem.image(title: item["title"]!, subtitle: item["subtitle"]!, image: UIImage.init(named: item["image"]!)!))
            } else {
                wnItems.append(WhatsNewItem.text(title: item["title"]!, subtitle: item["subtitle"]!))
            }
        }
        
        let whatsNew = WhatsNewViewController(items: wnItems)
        whatsNew.titleText = "What's New in This Version"
        whatsNew.buttonText = "Let's Play!"
        whatsNew.buttonTextColor = UIColor.white
        whatsNew.buttonBackgroundColor = HBSharedUtils.styleColor()
        whatsNew.presentIfNeeded(on: onViewController)
    }
}
