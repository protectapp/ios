//
//  ChatlogVC.swift
//  Protect_Security
//
//  Created by Jatin Garg on 22/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController {
    @IBOutlet weak var messageInputBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageInput: MessageInputView!
 
    public var messages: [ChatMessageModel] = []
    private var chatCellSizeCalculator = ChatCellSizeCalculator()
    public var shouldLoadPrevious = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(iWasTapped)))
        
        messageInput.sendTapHandler = {[weak self] messageText in
            self?.messageInput.textView.text = nil
            self?.didSendTextMessage(messageText)
        }
        
        collectionView.register(UINib(nibName: "ChatMessageCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        chatCellSizeCalculator.messageFont = Font.font(ofSize: 14, andFace: .regular)
        chatCellSizeCalculator.timeFont = Font.font(ofSize: 13, andFace: .regular)
        chatCellSizeCalculator.timeContainerVerticalMargin = 5
        chatCellSizeCalculator.timeMessageVerticalMargin = 0
        chatCellSizeCalculator.messageContainerVerticalMargin = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unRegisterForKeyboardNotifications()
    }
    
    @objc func iWasTapped(tap: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc private func handleKeyboardShow(notification: Notification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            messageInputBottomConstraint.constant = -keyboardSize.height
            UIView.animateAsSpring(withDuration: 0.5, {
                self.view.layoutIfNeeded()
                self.collectionView.scrollToLastItem()
            }, nil)
        }
    }
    
    @objc private func hadleKeyboardHide(notification: Notification){
        messageInputBottomConstraint.constant = 0
        UIView.animateAsSpring(withDuration: 0.5, {
            self.view.layoutIfNeeded()
        }, nil)
    }
    
    private func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hadleKeyboardHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    private func message(forIndexPath indexPath: IndexPath) -> ChatMessageModel? {
        if messages.indices.contains(indexPath.item) {
            return messages[indexPath.item]
        }
        return nil
    }
    
    public func queryForPreviousMessages() {
        
    }
    
    private func unRegisterForKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    public func addNewMessages(_ message: [ChatMessageModel]) {
        message.forEach {
            messages.append($0)
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.scrollToLastItem()
        }
    }
    
    public func insertNewMessage(_ message: ChatMessageModel) {
        
        if messages.filter({
            $0.snapshotID == message.snapshotID
        }).first != nil {
            return
        }
        messages.append(message)
        if messages.count>0{
            let newIndexPath = IndexPath(item: messages.count - 1, section: 0)
            DispatchQueue.main.async {
                self.collectionView.insertItems(at: [newIndexPath])
                self.collectionView.scrollToItem(at: newIndexPath, at: .bottom
                    , animated: true)
            }
        }
    }
    
    public func prependMessages(_ messages: [ChatMessageModel]) {
        collectionView.performBatchUpdates({
            var indexPaths = [IndexPath]()
            var index = 0
            messages.reversed().forEach({
                self.messages.insert($0, at: 0)
                indexPaths.append(IndexPath(item: index, section: 0))
                index += 1
            })
            self.collectionView.insertItems(at: indexPaths)
        }, completion: { _ in
            print("prepend complete")
        })
    }
    
    public func didSendTextMessage(_ message: String?) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension MessagesViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            queryForPreviousMessages()
        }
    }
}
extension MessagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        chatCellSizeCalculator.chatMessage = messages[indexPath.item]
        
        return CGSize(width: collectionView.frame.width, height: chatCellSizeCalculator.cellSize.height)
    }
}

extension MessagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChatMessageCell
        let currentChatMessage = message(forIndexPath: indexPath)!
        let previousChatMessage = message(forIndexPath: IndexPath(item: indexPath.item-1, section: indexPath.section))
        chatCellSizeCalculator.chatMessage = currentChatMessage
        chatCellSizeCalculator.previousMessage = previousChatMessage
        cell.chatMessage = currentChatMessage
        cell.bubbleTopConstraint.constant = chatCellSizeCalculator.verticalInsetToAdd
        cell.width = chatCellSizeCalculator.cellSize.width
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
