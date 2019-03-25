//
//  RecentChatsViewController.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 04/01/2019.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import UIKit

//#MARK: Delegate declaration for updaing chats list
protocol recentMessageDataDelegate {
    func getRecentMessageObj(recentMessageData: ChatContactModel?)
    func updateUnreadCount(unreadCount:Int)
}

class RecentChatsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shimmerView: UIView!
  
    private var securityList = [ChatContactModel]()
    private let cellID: String = "contactCell"
    private var isDataLoading:Bool = false
    private var didEndReached:Bool = false
    private var contacts = [ChatContactModel]()
    private var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ChatsTVC", bundle: nil), forCellReuseIdentifier: cellID)
        navigationItem.title = "Chats"

        DispatchQueue.main.async {
            self.configureNavigationBar()
        }
        getRecentChats()
        shimmerView.showShimmerView(usingCellType: ShimmerEffectView.self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RecentChatsViewController.updateRecentList(notification:)), name: Notification.Name("updateRecentListIdentifier"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if securityList.count > 0 {
            self.shouldToggleEmptyDatasetView(shouldShow: false)
        } else  {
            self.shouldToggleEmptyDatasetView(shouldShow: true)
        }
    }
    
    @objc func updateRecentList(notification: Notification) {
        if let chatObj = notification.object as? ChatContactModel {
            if let chatUserEmail = chatObj.email{
               securityList = securityList.filter{$0.email != chatUserEmail}
               securityList.insert(chatObj, at: 0)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            if securityList.count > 0 {
                self.shouldToggleEmptyDatasetView(shouldShow: false)
            } else  {
                self.shouldToggleEmptyDatasetView(shouldShow: true)
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("updateRecentListIdentifier"), object: nil)
    }
    
    //#MARK: Get recent chats list
    func getRecentChats(){
        let services = GetContactsService(page: 0, isRecent: true)
        services.fire { (model, error) in

            if let contacts = model?.contacts {
                for cont in contacts {
                    self.securityList.append(cont)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            self.shimmerView.removeShimmerView()
            self.shimmerView.isHidden = true
            
            if self.securityList.count > 0 {
                self.shouldToggleEmptyDatasetView(shouldShow: false)
            } else  {
                self.shouldToggleEmptyDatasetView(shouldShow: true)
            }
        }
    }
    //#MARK: Showing empty state when there is no conversation
    public func shouldToggleEmptyDatasetView(shouldShow: Bool){
        shouldShow ? tableView.showEmptyDatasetView(withTitle:"Sorry no messages yet. Tap plus icon on top right corner to chat with security members.", actionTitle: nil, image: UIImage(named: "emptyChat"), actionBlock: nil) : tableView.removeEmptydatasetView()
    }
    //#Set up navigation toolbar
    private func configureNavigationBar() {
        #if Protect_Security
        let selectMembers = UIImage(named: "plus")
        let addMember = UIBarButtonItem(image: selectMembers, style: .plain, target: self, action: #selector(selectMemberTapped))
        navigationItem.rightBarButtonItems = [addMember]
        #endif
    }
    
    func btnNoChatsFoundTapped(_ sender: Any) {
        let chatsVC = ChatsVC()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(chatsVC, animated: true)
    }
    
    @objc func menuTapped(_ sender: UIBarButtonItem) {
        menuAnimationController?.showMenu()
    }
    
    @objc func selectMemberTapped(_ sender: UIBarButtonItem) {
        let chatsVC = ChatsVC()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(chatsVC, animated: true)
    }
    
    public func launchChatLog(forUser tappedUser: ChatContactModel) {
        if let _ = UserPreferences.userDetails?.id {
            let chatID = tappedUser.nodeIdentifier!
            let fbchat = FirebaseChatObserver(chatID: "\(chatID)")
            let chatlog = ChatLogVC()
            chatlog.fbChat = fbchat
            chatlog.chatPartner = tappedUser
            chatlog.recenMessObjDelegate = self
            
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(chatlog, animated: true)
        } else {
            RequestHandler.shared.redirectToAuth()
        }
    }
}
//#MARK: Datasouce and Delegate
extension RecentChatsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return securityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! ChatsTVC
        let chatObj = securityList[indexPath.row]
        cell.nameLabel.text = chatObj.name ?? ""
        cell.lastMessage.text = chatObj.lastMessage ?? ""
        
        if let profileImage = chatObj.profileImageURL {
            cell.userImage.sd_setImage(with: URL(string: profileImage), placeholderImage: UIImage(named: "default_user"))
        }
        
        let timeStampStrToDate = getDate(dateString: chatObj.timeStamp ?? "")
        let dateText = timeStampStrToDate?.getElapsedInterval()
        cell.lblTimeStamp.text = dateText
        
        let unreadCount = securityList[indexPath.row].unreadMessages ?? 0
        if unreadCount == 0 {
            cell.unreadCountView.isHidden = true
        } else {
            cell.unreadCountView.isHidden = false
            cell.unreadCountLabel.text = unreadCount.description
        }
        return cell
    }
    
    func getDate(dateString:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: dateString)
    }

    public func getContact(atIndex index: Int) -> ChatContactModel {
        return contacts[index]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        launchChatLog(forUser:securityList[indexPath.row])
    }
}

//#MARK: Recent message delegate confirmation for updating chat list
extension RecentChatsViewController: recentMessageDataDelegate{
    func updateUnreadCount(unreadCount: Int) {
        if securityList.count>selectedIndex{
            var selectedMessageObj = securityList[selectedIndex]
            selectedMessageObj.unreadMessages = unreadCount
            securityList[selectedIndex] = selectedMessageObj
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getRecentMessageObj(recentMessageData: ChatContactModel?){
        if securityList.count>selectedIndex{
           securityList.remove(at: selectedIndex)
        }
        if var chatObj = recentMessageData {
            chatObj.unreadMessages = 0
            securityList.insert(chatObj, at: 0)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        if securityList.count > 0 {
            self.shouldToggleEmptyDatasetView(shouldShow: false)
        } else  {
            self.shouldToggleEmptyDatasetView(shouldShow: true)
        }
    }
}
public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}
