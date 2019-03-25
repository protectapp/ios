//
//  ContactsDatasource.swift
//  Protect_Security
//
//  Created by Jatin Garg on 22/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class ContactsDatasource: NSObject, UITableViewDataSource {

    var contacts = [ChatContactModel]()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellID = delegate?.identifierForCell() else {
            fatalError("Delegate for contact datasource is not defined")
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! ChatsTVC
        cell.item = contacts[indexPath.row]
        return cell
    }

    public func getContact(atIndex index: Int) -> ChatContactModel {
        return contacts[index]
    }
    public weak var delegate: ContactsDatasourceDelegate?
}
