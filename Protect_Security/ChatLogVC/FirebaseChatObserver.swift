//
//  FirebaseChatObserver.swift
//  Protect_Security
//
//  Created by Jatin Garg on 22/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseChatObserver {
    
    let chatID: String
    let queryLimit: Int
    private var chatRef: DatabaseReference?
    private var msgsRef: DatabaseReference?
    public var isBusy: Bool = false
    public var lastSnapshot: String?
    private let messagesPerPage: Int = 12
    public var canLoadMore: Bool = true
    
    init(chatID: String) {
        //remove the first set of id from this
        self.chatID = chatID
        self.queryLimit = 1
        chatRef = Database.database().reference().child(Constants.FIREBASE_CHAT_BRANCH_KEY)
        msgsRef = chatRef?.child(self.chatID)
    }
    
    //#MARK: Fetch messages from firebase server
    public func startObservingChats(_ observationHandler : @escaping (ChatMessageModel?)->Void) {
        msgsRef?.queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot) in
            
            guard var messageDict = snapshot.value as? [String:Any] else{
                return
            }
            messageDict["snapshotID"] = snapshot.key
            
            if let serverTimestamp = messageDict["timestamp"] as? Double {
                let convertedDate = Date(timeIntervalSince1970: serverTimestamp/1000)
                let formatter = DateFormatter()
                //get time
                formatter.dateFormat = ChatMessageModel.twelveHourFormat
                let timeString = formatter.string(from: convertedDate)
                //get date
                formatter.dateFormat = ChatMessageModel.dateFormat
                let dateString = formatter.string(from: convertedDate)
                messageDict["chatDate"] = dateString
                messageDict["chatTime"] = timeString
            }
            
            do {
                let chatdata = try JSONSerialization.data(withJSONObject: messageDict, options: [])
                let model = try JSONDecoder().decode(ChatMessageModel.self, from: chatdata)
                observationHandler(model)
            } catch {
                print("Error casting to message model : \(error)")
                observationHandler(nil)
            }
        })
    }
    
    public func stopObservingChats(){
        msgsRef?.removeAllObservers()
    }
    
    public func getChats(_ completion: (([ChatMessageModel]?,Error?) -> Void)?) {
        isBusy = true
        let isLoadingMore = lastSnapshot != nil
        let query = isLoadingMore ? msgsRef?.queryOrderedByKey().queryLimited(toLast: UInt(messagesPerPage)).queryEnding(atValue: lastSnapshot!) : msgsRef?.queryOrderedByKey().queryLimited(toLast: UInt(messagesPerPage))
        
        query?.observeSingleEvent(of: .value, with: { snapshot in
            
            self.isBusy = false
            var messageModels: [ChatMessageModel] = []
            guard let messages = snapshot.children.allObjects as? [DataSnapshot] else {
                self.canLoadMore = false
                completion?(nil, NSError(domain: "Failed to get messages", code: 101, userInfo: nil))
                return
            }
            
            for message in messages {
                let snapshotID = message.key
                var messageDictionary = message.value as! [String:Any]
                messageDictionary["snapshotID"] = snapshotID
                
                if let serverTimestamp = messageDictionary["timestamp"] as? Double {
                    let convertedDate = Date(timeIntervalSince1970: serverTimestamp/1000)
                    let formatter = DateFormatter()
                    //get time
                    formatter.dateFormat = ChatMessageModel.twelveHourFormat
                    let timeString = formatter.string(from: convertedDate)
                    //get date
                    formatter.dateFormat = ChatMessageModel.dateFormat
                    let dateString = formatter.string(from: convertedDate)
                    messageDictionary["chatDate"] = dateString
                    messageDictionary["chatTime"] = timeString
                }
                do {
                    let messageData = try JSONSerialization.data(withJSONObject: messageDictionary, options: [])
                    let model = try JSONDecoder().decode(ChatMessageModel.self, from: messageData)
                    messageModels.append(model)
                }catch{
                    completion?(nil, error)
                    return
                }
            }
            //Remove the repeated item
            if self.lastSnapshot != nil {
                messageModels.removeLast()
            }
            self.lastSnapshot = messageModels.first?.snapshotID
            self.canLoadMore = messageModels.count > 0 ? true : false
            completion?(messageModels,nil)
        })
    }
    
    public func sendChat(_ message: ChatMessageModel) {
        do {
            let messageData = try JSONEncoder().encode(message)
            var messageDictionary: Dictionary<String,Any> = try JSONSerialization.jsonObject(with: messageData, options: []) as! Dictionary<String,Any>
            messageDictionary["snapshotID"] = nil
            messageDictionary["timestamp"] = ServerValue.timestamp()
            msgsRef?.childByAutoId().setValue(messageDictionary)
        }catch {
            print("unable to send chat message: \(error)")
        }
    }
}
