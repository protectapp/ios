//
//  ChatsVC.swift
//  Protect_Security
//
//  Created by Jatin Garg on 22/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class ChatsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shimmerView: UIView!
 
    var securityList = [ChatContactModel]()
    private let cellID: String = "contactCell"
    public var pageCount = 0
    private var isLoading = false
    private var cantFetchMore = false
    private var isFirstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ChatsTVC", bundle: nil), forCellReuseIdentifier: cellID)
        navigationItem.title = "Select Member"
        getContacts(pageCount: 0)
        shimmerView.showShimmerView(usingCellType: ShimmerEffectView.self)
    }
    //#MARK: Get List of security members
    private func getContacts(pageCount: Int) {
        isLoading = true
        if isFirstTime == false {
            self.view.showLoadingView()
        }
        let services = GetContactsService(page: pageCount, isRecent: false)
        services.fire { (model, error) in
            
            if let contacts = model?.contacts {
                if contacts.count == 0 {
                    self.cantFetchMore = true
                } else {
                    self.cantFetchMore = false
                }
                for cont in contacts {
                    self.securityList.append(cont)
                }
            }
            
            self.shimmerView.removeShimmerView()
            self.shimmerView.isHidden = true
            
            self.view.hideLoadingView()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            self.isLoading = false
            self.isFirstTime = false
            
            if self.securityList.count > 0 {
                self.shouldToggleEmptyDatasetView(shouldShow: false)
            } else  {
                self.shouldToggleEmptyDatasetView(shouldShow: true)
            }
        }
    }
    //#MARK: Showing Negative state message
    private func shouldToggleEmptyDatasetView(shouldShow: Bool){
        shouldShow ? tableView.showEmptyDatasetView(withTitle:"No security members available except you.", actionTitle: nil, image: UIImage(named: "emptyChat"), actionBlock: nil) : tableView.removeEmptydatasetView()
    }
}
//#MARK: Datasource and delegate implemetaion starts **************
extension ChatsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return securityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! ChatsTVC
        cell.item = securityList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tappedUser = securityList[indexPath.row]
        let chatID = tappedUser.nodeIdentifier!
        let fbchat = FirebaseChatObserver(chatID: "\(chatID)")
        let chatlog = ChatLogVC()
        chatlog.fbChat = fbchat
        chatlog.chatPartner = tappedUser
        chatlog.isComingFromSelectMember = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(chatlog, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (indexPath.row + 1  == securityList.count) && !isLoading && !self.cantFetchMore {
            
            self.pageCount = pageCount + 1
            getContacts(pageCount: pageCount)
        }
    }
}

