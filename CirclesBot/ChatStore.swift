//
//  ChatStore.swift
//  CirclesBot
//
//  Created by Lakshmi on 2/9/18.
//  Copyright © 2018 com.arunsivakumar. All rights reserved.
//

import Foundation
import JSQMessagesViewController

typealias MessageFetchCompletion = (ChatResult) -> Void

enum ChatResult{
    case success(JSQMessage) // Photos, page, pages, perpage, total
    case failure(Error)
}

class ChatStore{

    func fetchText(message:String,completion: @escaping MessageFetchCompletion){
        let request = MicrosoftAPI.postMessage(using: message)
        
        NetworkHelper.postRequest(url: request.url, params: request.parameters, header: request.header) { (result) in
            
            let result = self.processRequest(for: result)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
    }
    
    private func processRequest(for result:NetworkResult) -> ChatResult{
        switch result{
        case .success(let json):
            return MicrosoftAPI.message(from: json)
        case .failure(let error):
            return .failure(error)
        }
    }

}
