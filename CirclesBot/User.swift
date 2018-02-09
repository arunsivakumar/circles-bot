//
//  User.swift
//  CirclesBot
//
//  Created by Lakshmi on 2/9/18.
//  Copyright © 2018 com.arunsivakumar. All rights reserved.
//

import Foundation
import JSQMessagesViewController

enum User: String {
    case me = "me"
    case bot = "bot"
    
    static func getName(_ user: User) -> String {
        switch user {
        case .me: return "Me"
        case .bot: return "Customer Service"
        }
    }
    
    static func getAvatar(_ id: String) -> JSQMessagesAvatarImage? {
        let user = User(rawValue: id)!
        switch user {
        case .me: return nil
        case .bot: return JSQMessagesAvatarImageFactory.avatarImage(with: #imageLiteral(resourceName: "bot_image"), diameter: 20)

        }
    }
}
