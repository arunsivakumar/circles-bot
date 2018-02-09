//
//  ViewController.swift
//  CirclesBot
//
//  Created by Lakshmi on 2/8/18.
//  Copyright © 2018 com.arunsivakumar. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ViewController: JSQMessagesViewController {

// MARK: Public API
    var chatStore:ChatStore!
    
    var messages = [JSQMessage]()
    

// MARK: Private Variables
    
    // Chat Bubble Configuration
    fileprivate var incomingMessage: JSQMessagesBubbleImage!
    fileprivate var incomingMessageTextColor = UIColor.black
    
    fileprivate var outgoingMessage: JSQMessagesBubbleImage!
    fileprivate var outgoingMessageTextColor = UIColor.white
 
    
// MARK: Lifecycle
    
    override func viewDidLoad() {
        setupSender() // Super expects sender to be set
        super.viewDidLoad()
        setupUI()
        setupChatUI()

    }
    
    fileprivate func sendMessage(message:String){
        chatStore.fetchText(message: message) { [weak self](result) in
            switch result{
            case .success(let message):
                    self?.messages.append(message)
                    self?.finishReceivingMessage()
            case .failure( _): break
                    // show error
            }
            
        }
    }
    
    private func setupSender() {
        senderId = User.me.rawValue
        senderDisplayName = User.getName(User.me)
    }
    
    private func setupUI(){
        self.navigationItem.title = "CirclesBot"
        self.navigationController?.navigationBar.barTintColor = Colors.defaultBlueColor
            self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    private func setupChatUI() {
        
        // messages
        
        let incomingMessageColor = UIColor.lightGray
        let outgoingMessageColor = Colors.defaultBlueColor
        incomingMessage = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: incomingMessageColor)
        outgoingMessage = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: outgoingMessageColor)
        
         self.inputToolbar.contentView.leftBarButtonItem = nil
        
        // test data
        //messages.append(JSQMessage( senderId: User.bot.rawValue, senderDisplayName: User.getName(User.me), date: Date(),text: "Hello"))
       
        
    }

}

// MARK: Send Button Delegate
extension ViewController {
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        
        // append to existing Data structure
        guard let message = JSQMessage( senderId: User.me.rawValue, senderDisplayName: User.getName(User.me), date: date,text: text)else {
            return // error checking / alert message
        }
        
        self.messages.append(message)
        self.finishSendingMessage(animated: true)
        
        sendMessage(message: text)
        
        // Send Actual data
        
    }
}

// MARK: JSQMessages Data Source

extension ViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!)
        -> JSQMessageData!{
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath:IndexPath!) -> JSQMessageBubbleImageDataSource!{
        let message = messages[indexPath.item]
        let messageBubble = (message.senderId == senderId) ? outgoingMessage : incomingMessage
        return messageBubble
    }
    
    override func collectionView( _ collectionView: JSQMessagesCollectionView!,avatarImageDataForItemAt indexPath: IndexPath!)
        -> JSQMessageAvatarImageDataSource!{
        let message = messages[indexPath.item]
        return User.getAvatar(message.senderId)
    }
    
    override func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) ->UICollectionViewCell{
        let cell = super.collectionView( collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        cell.textView.textColor = (message.senderId == senderId) ? outgoingMessageTextColor : incomingMessageTextColor
        return cell
    }
}
