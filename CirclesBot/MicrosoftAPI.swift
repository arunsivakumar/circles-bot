//
//  MicrosoftAPI.swift
//  CirclesBot
//
//  Created by Lakshmi on 2/9/18.
//  Copyright © 2018 com.arunsivakumar. All rights reserved.
//

import Foundation
import SwiftyJSON
import JSQMessagesViewController


//        let parameters: [String: String] = [
//            "question":"whats is circles life"
//        ]
//
//
//        NetworkHelper.postRequest(url: "https://westus.api.cognitive.microsoft.com/qnamaker/v2.0/knowledgebases/e9126937-83ed-4adf-bb61-17e642b1748e/generateAnswer", params: parameters, header: ["Ocp-Apim-Subscription-Key":"a74ef73882bc4069b20d7763be26c8b6"]) { (_) in
//
//        }

enum MicrosoftError: Error{
    case processingJSON
}

enum MicrosoftMethod:String{
    case qna = "/knowledgebases/e9126937-83ed-4adf-bb61-17e642b1748e/generateAnswer"
}

struct MicrosoftAPI{

    private static let baseURLString =  "https://westus.api.cognitive.microsoft.com/qnamaker/v2.0"
    private static let keyQuestion   =  "question"
    
    
    
    private static func constructURL(method: MicrosoftMethod) -> String{
        return baseURLString + method.rawValue
    }
    
    static func postMessage(using text:String)->(MicrosoftAPIRequest){
        let header = [Credentials.headerSubscriptionKey:Credentials.headerSubscriptionValue]
        
        return MicrosoftAPIRequest(url: constructURL(method: .qna), parameters: [keyQuestion : text], header: header)
    }
    
    static func message(from json: JSON) -> ChatResult{
        print(json)
        if let answersArry = json["answers"].array{
            let answer = answersArry[0]
            let answerDescription = answer["answer"].description
            let message = JSQMessage( senderId: User.bot.rawValue, senderDisplayName: User.getName(User.bot), date: Date(),text: answerDescription)!
            return .success(message)
        }else{
            return .failure(MicrosoftError.processingJSON)
        }
    }


}

class MicrosoftAPIRequest{
    
    let url:String
    let parameters: [String:String]
    let header:[String:String]
    
    init(url:String,parameters:[String:String],header:[String:String]){
        self.url = url
        self.parameters = parameters
        self.header = header
    }
    
}
