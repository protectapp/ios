//
//  ShimmerAnimationView.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 10/01/2019.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import UIKit

class ShimmerAnimationView<T: NSObject>: View {
    private var scrollView: UIScrollView = {
        let s = UIScrollView()
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    
    public var shimmerCount: Int = 1 {
        didSet{
            loadShimmers()
        }
    }
    
    
    override func setup() {
        super.setup()
        backgroundColor = .white
        addSubview(scrollView)
        scrollView.anchorCenterSuperview()
        scrollView.setWidth(equalToView: self)
        scrollView.setHeight(equalToView: self)
    }
    
    private var loadedShimmers: [ShimmerEffectView] {
        return scrollView.subviews.filter({ $0 as? ShimmerEffectView != nil}).map{$0 as! ShimmerEffectView}
    }
    
    private func loadShimmers() {
        loadedShimmers.forEach{
            $0.removeFromSuperview()
        }
        
        for i in 0..<shimmerCount {
            let newShimmer = T() as! ShimmerEffectView
            
            newShimmer.startShimmering()
            scrollView.addSubview(newShimmer)
            newShimmer.translatesAutoresizingMaskIntoConstraints = false
            newShimmer.anchor(toView: scrollView, myHorizontalEdge: .left, viewHorizontalEdge: .left, shouldUseSafeAreaHorizontally: false, horizontalOffset: 0, myVerticalEdge: nil, viewVerticalEdge: nil, shouldUseSafeAreaVertically: false, verticalOffset: 0)
            newShimmer.anchor(toView: scrollView, myHorizontalEdge: .right, viewHorizontalEdge: .right, shouldUseSafeAreaHorizontally: false, horizontalOffset: 0, myVerticalEdge: nil, viewVerticalEdge: nil, shouldUseSafeAreaVertically: false, verticalOffset: 0)
            
            newShimmer.anchor(toView: self, myHorizontalEdge: .left, viewHorizontalEdge: .left, shouldUseSafeAreaHorizontally: false, horizontalOffset: 0, myVerticalEdge: nil, viewVerticalEdge: nil, shouldUseSafeAreaVertically: false, verticalOffset: 0)
            newShimmer.anchor(toView: self, myHorizontalEdge: .right, viewHorizontalEdge: .right, shouldUseSafeAreaHorizontally: false, horizontalOffset: 0, myVerticalEdge: nil, viewVerticalEdge: nil, shouldUseSafeAreaVertically: false, verticalOffset: 0)
            
            newShimmer.fixHeight(to: 70)
            
            if i==0 {
                newShimmer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            }else{
                newShimmer.topAnchor.constraint(equalTo: loadedShimmers[i-1].bottomAnchor).isActive = true
            }
            
            if i == shimmerCount - 1 {
                newShimmer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            }
        }
    }
}
