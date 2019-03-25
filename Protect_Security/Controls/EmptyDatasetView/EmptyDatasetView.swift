//
//  EmptyDatasetView.swift
//  Protect_Security
//
//  Created by Jatin Garg on 11/01/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import UIKit

class EmptyDatasetView: View {
    typealias completion = ()->Void
    private var actionButton: UIButton = {
        let b = UIButton(type: .system)
        b.titleLabel?.numberOfLines = 0
        b.tintColor = .lightGray
        b.titleLabel?.textAlignment = .center
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private var infoLabel: UILabel = {
        let l = UILabel()
        l.textColor = .lightGray
        l.textAlignment = .center
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private var infoImageview: UIImageView = {
        let i = UIImageView()
        i.contentMode = .scaleAspectFit
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    
    private var verticalStack: UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        s.spacing = 5
        s.alignment = .center
        s.distribution = .equalSpacing
        return s
    }()
    
    convenience init(image: UIImage?,
                     infoText: String?,
                     actionText: String?,
                     action: completion?) {
        self.init(frame: .zero)
        
        infoImageview.image = image
        infoLabel.text = infoText
        
        if let buttontitle = actionText {
            let attrStr = NSAttributedString(string: buttontitle, attributes: [.foregroundColor : actionButton.tintColor, .font: actionButton.titleLabel!.font, .underlineStyle : NSUnderlineStyle.styleSingle.rawValue])
            actionButton.setAttributedTitle(attrStr, for: .normal)
        }else{
            verticalStack.removeArrangedSubview(actionButton)
        }
        
        if infoText == nil {
            verticalStack.removeArrangedSubview(infoLabel)
        }
        
        if image == nil {
            verticalStack.removeArrangedSubview(infoImageview)
        }
        
    }
    
    override func setup() {
        verticalStack.addArrangedSubview(infoImageview)
        verticalStack.addArrangedSubview(actionButton)
        verticalStack.addArrangedSubview(infoLabel)
        
        actionButton.leftAnchor.constraint(equalTo: verticalStack.leftAnchor).isActive = true
        actionButton.rightAnchor.constraint(equalTo: verticalStack.rightAnchor).isActive = true
        
        infoLabel.leftAnchor.constraint(equalTo: verticalStack.leftAnchor).isActive = true
        infoLabel.rightAnchor.constraint(equalTo: verticalStack.rightAnchor).isActive = true
        addSubview(verticalStack)
        
        verticalStack.anchorCenterSuperview()
        verticalStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        verticalStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
    }
}
