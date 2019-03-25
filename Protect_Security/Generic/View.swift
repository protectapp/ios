//
//  View.swift
//  Protect_Security
//
//  Created by Jatin Garg on 13/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class View: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public func setup() {
        
    }
    
    public func loadNib(named nibName: String) {
        guard let nib = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView
            else{
                fatalError("Couldn't find any nib named : \(nibName)")
        }
        
        addSubview(nib)
        nib.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        nib.frame = bounds
        
    }
}
