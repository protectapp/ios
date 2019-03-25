//
//  BubbleView.swift
//  Protect_Security
//
//  Created by Jatin Garg on 24/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class BubbleView: UIView {
    private var maskLayer: CAShapeLayer?
    private var roundedCorners: UIRectCorner?
    public var cornerRadius: CGFloat = 8
    
    private var roundedPath: UIBezierPath? {
        if roundedCorners != nil {
            return UIBezierPath(roundedRect: bounds, byRoundingCorners: roundedCorners!, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        }
        return nil
    }
    
    public func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        roundedCorners = corners
        cornerRadius = radius
        
        if maskLayer == nil {
            maskLayer = CAShapeLayer()
        }
        maskLayer?.path = roundedPath?.cgPath
        layer.mask = maskLayer!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if roundedCorners != nil {
            roundCorners(corners: roundedCorners!, radius: cornerRadius)
        }
    }
}
