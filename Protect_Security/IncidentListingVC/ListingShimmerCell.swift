//
//  ListingShimmerCell.swift
//  Protect_Security
//
//  Created by Jatin Garg on 14/01/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import UIKit

class ListingShimmerCell: ShimmerEffectView {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var incidentTypeBottomView: UIView!
    @IBOutlet weak var incidentTypeTopView: UIView!
    @IBOutlet weak var incidentTimeBottomView: UIView!
    @IBOutlet weak var incidentTimeTopView: UIView!
    @IBOutlet weak var incidentLocationBottomView: UIView!
    @IBOutlet weak var incidentLocationTopView: UIView!
    
    override func setup() {
        loadNib(named: "ListingShimmerCell")
        
        containerView.layer.masksToBounds = false
        containerView.layer.cornerRadius = 8
        containerView.layer.shadowOpacity = 0.6
        containerView.layer.shadowOffset = CGSize(width: 0.5, height: 1)
    }
    
    override func startShimmering() {
        animationWithviews(firstView: incidentTypeBottomView, secondView: incidentTypeTopView)
        animationWithviews(firstView: incidentTimeBottomView, secondView: incidentTimeTopView)
        animationWithviews(firstView: incidentLocationBottomView, secondView: incidentLocationTopView)
    }
}
