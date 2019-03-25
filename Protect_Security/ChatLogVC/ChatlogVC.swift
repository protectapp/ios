//
//  ChatlogVC.swift
//  Protect_Security
//
//  Created by Jatin Garg on 22/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ChatLogVC: MessagesViewController {
    
    public var fbChat: FirebaseChatObserver!
    public var chatPartner: ChatContactModel!
    public var recenMessObjDelegate: recentMessageDataDelegate?
    public var isComingFromSelectMember = false
    private var isAnylastMessageSent = false
    
    init() {
        super.init(nibName: "MessagesViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = chatPartner.name ?? ""
        view.showLoadingView(atPostion: .top)
        messageInput.toggleSendButton(isEnabled: false)
        fbChat.getChats { [weak self] (messages, error) in
            guard let `self` = self else { return }
            self.messageInput.toggleSendButton(isEnabled: true)
            self.view.hideLoadingView()
            if error != nil {
                System.showInfo(withMessage: error!.localizedDescription, ofType: .error, onVC: self)
            }else if messages != nil {
                self.addNewMessages(messages!)
            }
            self.shouldLoadPrevious = true
            self.fbChat.startObservingChats {[weak self] (message) in
                guard let `self` = self, let msg = message else {
                    return
                }
                self.insertNewMessage(msg)
            }
        }
        configureNavigationBar()
        resetUnreadCountApiCalling()
        
        let newBackButton = UIBarButtonItem(image: UIImage(named: "arrow-up"), landscapeImagePhone: UIImage(named: "arrow-up"), style: .plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    //#MARK: Adding Call button on top-right corner
    private func configureNavigationBar() {
        let phoneCall = UIImage(named: "phone")
        let menuItem = UIBarButtonItem(image: phoneCall, style: .plain, target: self, action: #selector(callButtonTapped))
        navigationItem.rightBarButtonItems = [menuItem]
    }
    
    @objc func back(sender: UIBarButtonItem) {
        //#MARK: Reset Unread count logic on back to Chats list
        if !isAnylastMessageSent {
            recenMessObjDelegate?.updateUnreadCount(unreadCount: 0)
        }
        resetUnreadCountApiCalling()
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: RecentChatsViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    @objc func callButtonTapped(_ sender: UIBarButtonItem) {
        if let chatPartnerContactNo = chatPartner.contactNumber, chatPartnerContactNo.trim().count > 0 {
            callNumber(phoneNumber: chatPartnerContactNo.trim())
        } else {
            System.showInfo(withMessage: "Contact Number not found", ofType: .information, onVC: self)
        }
    }
    
    private func callNumber(phoneNumber:String) {
        if phoneNumber.isValid(regex: .phone) {
            phoneNumber.makeAColl()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let unreadCount = chatPartner.unreadMessages, unreadCount > 0 {
            let updatedBadgeCount = BadgeManager.shared.chatBadgeCount - unreadCount
            BadgeManager.shared.chatBadgeCount = max(0, updatedBadgeCount)
        }
    }
    
    override func didSendTextMessage(_ message: String?) {
        guard let senderID = UserPreferences.userDetails?.id,
            let senderName = UserPreferences.userDetails?.name,
            message != nil,
            message!.trim().count > 0
            else{
                return
        }
        
        let cmessage = ChatMessageModel(snapshotID: "", chatDate: nil , chatTime: nil, senderID: senderID, chatMessage: message!, senderName: senderName)
        fbChat.sendChat(cmessage)
        
        updatelastMessageApiCalling(lastMessage: message!, recieverId : chatPartner.id)
    }
    
    func updatelastMessageApiCalling(lastMessage: String, recieverId : Int ) {
        isAnylastMessageSent = true
        let service = UpdateLastMessageService(lastMessage: lastMessage, receiverID: recieverId)
        service.fire { (model, error) in
            
            if var chatObj = model {
                chatObj.unreadMessages = 0
                if self.isComingFromSelectMember{
                    NotificationCenter.default.post(name: Notification.Name("updateRecentListIdentifier"), object: chatObj)
                } else {
                    self.recenMessObjDelegate?.getRecentMessageObj(recentMessageData: chatObj)
                }
            }
        }
    }
    //#MARK: Reset unread count Api call
    private func resetUnreadCountApiCalling(){
        let service = ResetUnreadCountService(receiverId: chatPartner.id)
        service.fire { (model, error) in
        }
    }
    
    override func queryForPreviousMessages() {
        guard !fbChat.isBusy && fbChat.canLoadMore else {
            return
        }
        guard shouldLoadPrevious else {
            return
        }
        shouldLoadPrevious = false
        view.showLoadingView(atPostion: .top)
        fbChat.getChats { (chats, error) in
            self.view.hideLoadingView()
            if error != nil {
                System.showInfo(withMessage: error!.localizedDescription, ofType: .error, onVC: self)
            }
            guard let c = chats else {
                return
            }
            
            //prepend each message to our existing chats
            self.prependMessages(c)
            self.shouldLoadPrevious = true
        }
    }
}
