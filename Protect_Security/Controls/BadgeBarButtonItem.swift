//
//  BadgeBarButtonItem.swift
//  Protect_Security
//
//  Created by Jatin Garg on 22/01/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import UIKit

public class BadgeBarButtonItem: UIBarButtonItem {

    @IBInspectable
    public var badgeNumber: Int = 0 {
        didSet {
            self.updateBadge()
        }
    }
    
    private var badgeLabel: UILabel?
    
    private var genericLabel: UILabel  {
        let label = UILabel()
        label.backgroundColor = .red
        label.alpha = 0.9
        label.clipsToBounds = true
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.layer.zPosition = 1
        return label
    }

    
    public override init() {
        super.init()
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addObserver(self, forKeyPath: "view", options: [], context: nil)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        self.updateBadge()
    }
    
    private func updateBadge(){
        guard let view = self.value(forKey: "view") as? UIView else { return }
        badgeLabel?.removeFromSuperview()
        badgeLabel = genericLabel
        badgeLabel!.text = "\(badgeNumber)"
        badgeLabel!.sizeToFit()
        let idealHeight = badgeLabel!.bounds.size.height + 4
        let idealWidth = badgeLabel!.bounds.size.width + 8
        
        
        let greaterDim = max(idealHeight, idealWidth)
        
        let shouldEquateDim = badgeLabel!.text!.trim().count == 1
        badgeLabel!.layer.cornerRadius = (shouldEquateDim ? greaterDim : idealHeight)/2
        
        let finalHeight = shouldEquateDim ? greaterDim : idealHeight
        let finalWidth = shouldEquateDim ? greaterDim : idealWidth
        view.addSubview(badgeLabel!)
        badgeLabel!.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 9).isActive = true
        badgeLabel!.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -9).isActive = true
        badgeLabel?.widthAnchor.constraint(equalToConstant: finalWidth).isActive = true
        badgeLabel?.heightAnchor.constraint(equalToConstant: finalHeight).isActive = true
    
        if badgeNumber == 0 {
            badgeLabel!.isHidden = true
        }else{
            badgeLabel!.isHidden = false
        }
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "view")
    }
}
