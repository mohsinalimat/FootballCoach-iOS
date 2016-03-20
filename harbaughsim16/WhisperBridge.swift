//
//  WhisperBridge.swift
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/19/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

import Foundation
import Whisper

@objc public class WhisperBridge: NSObject {
    
    static public func whisper(text: String, backgroundColor: UIColor, toNavigationController: UINavigationController, silenceAfter: NSTimeInterval) {
        let message = Message(title: text, textColor: backgroundColor)
        Whisper(message, to: toNavigationController)
        
        if silenceAfter > 0.1 {
            Silent(toNavigationController, after: silenceAfter)
        }
    }
    
    static public func shout(title: String, message: String, toViewController: UIViewController) {
        let announcement = Announcement(title: title, subtitle: message)
        Shout(announcement, to: toViewController)
    }
}