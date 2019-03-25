//
//  OTPField.swift
//  Protect_Security
//
//  Created by Jatin Garg on 18/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

extension OTPField: OTPBoxDelegate {
    func didEnter(digit: Int, in box: OTPBox) {
        let index = box.tag
        if index < digitCount - 1 {
            _=self.otpBoxes[index+1].becomeFirstResponder()
        }
    }
    
    func didTapBackspace(in box: OTPBox) {
        let index = box.tag
        if index > 0 {
            _=self.otpBoxes[index-1].becomeFirstResponder()
        }
    }
}

class OTPField: View {
    @IBInspectable public var digitCount: Int {
        get{
            return otpBoxes.count
        }set{
            renderOTPBoxes(newValue)
        }
    }
    
    public var otpBoxes: [OTPBox] = []
    private let inset: CGFloat = 8
    private let paddingVertical: CGFloat = 5
    private let paddingHorizontal: CGFloat = 10
    
    public var otpText: String? {
        get {
            var otp = ""
            for box in otpBoxes {
                if let text = box.text {
                    otp += text
                }else{
                    return nil
                }
            }
            return otp
        }
    }
    override func setup() {
        super.setup()
        backgroundColor = .clear
    }
    
    private func renderOTPBoxes(_ count: Int) {
        otpBoxes.forEach {
            $0.removeFromSuperview()
        }
        otpBoxes = []
        
        for i in 0..<count {
            let newBox = OTPBox()
            newBox.delegate = self
            newBox.tag = i
            addSubview(newBox)
            
            let leftAnchorView = i == 0 ? self : otpBoxes[i-1]
            let leftAnchorViewEdge: HorizontalEdge = i == 0 ? .left : .right
            let verticalOffset = i == 0 ? paddingVertical : 0
            let horizontalOffset = i == 0 ? paddingHorizontal : inset
            
            newBox.anchor(toView: leftAnchorView, myHorizontalEdge: .left, viewHorizontalEdge: leftAnchorViewEdge, shouldUseSafeAreaHorizontally: false, horizontalOffset: horizontalOffset, myVerticalEdge: .top, viewVerticalEdge: .top, shouldUseSafeAreaVertically: false, verticalOffset: verticalOffset)
            newBox.anchor(toView: leftAnchorView, myHorizontalEdge: nil, viewHorizontalEdge: nil, shouldUseSafeAreaHorizontally: false, horizontalOffset: 0, myVerticalEdge: .bottom, viewVerticalEdge: .bottom, shouldUseSafeAreaVertically: false, verticalOffset: -verticalOffset)
            
            if i == count - 1 {
                newBox.anchor(toView: self, myHorizontalEdge: .right, viewHorizontalEdge: .right, shouldUseSafeAreaHorizontally: false, horizontalOffset: -paddingHorizontal, myVerticalEdge: nil, viewVerticalEdge: nil, shouldUseSafeAreaVertically: false, verticalOffset: 0)
            }
            if i > 0 {
                //equate width to previously rendered box
                newBox.setWidth(equalToView: otpBoxes[i-1])
            }
            otpBoxes.append(newBox)
        }
    }
}
