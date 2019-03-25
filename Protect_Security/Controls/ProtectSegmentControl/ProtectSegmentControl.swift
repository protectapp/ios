//
//  ProtectSegmentControl.swift
//  Protect_Security
//
//  Created by Jatin Garg on 26/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class ProtectSegmentControl: View {
    //Private preferences
    private let selectionColor = Color.accentColor
    private let deSelectedColor = Color.backgroundColorUIColor
    private let selectedTextColor = UIColor.white
    private let deSelectedTextColor = Color.textColor
    
    //public API
    public var selectedIndex: Int = 0
    public var segmentNames: [String]! {
        didSet{
            renderSegments()
        }
    }
    public var segmentFont: UIFont = Font.font(ofSize: 17, andFace: .regular) {
        didSet{
            setSegmentFont()
        }
    }
    
    public weak var delegate: ProtectSegmentControlDelegate?
    
    //private
    private var renderedSegments: [UIButton] {
        return subviews.filter({$0 as? UIButton != nil}) as! [UIButton]
    }
    
    private var segmentButton: UIButton {
        let b = UIButton(type: .system)
        b.titleLabel?.font = segmentFont
        b.tintColor = deSelectedTextColor
        b.addTarget(self, action: #selector(segmentButtonTapped), for: .touchUpInside)
        b.titleLabel?.textAlignment = .center
        return b
    }
    
    private let internalMargin: CGFloat = 1
    
    override func setup() {
        super.setup()
        backgroundColor = Color.segmentControlbackgroundColor
        renderSegments()
    }
    
    private func renderSegments() {
        guard segmentNames != nil else {
            return
        }
        
        renderedSegments.forEach {
            $0.removeFromSuperview()
        }
        
        var index = 0
        segmentNames.forEach({
            let newSegmentButton = segmentButton
            newSegmentButton.setTitle($0, for: .normal)
            newSegmentButton.tag = index
            addSubview(newSegmentButton)
            if index == selectedIndex {
                newSegmentButton.backgroundColor = selectionColor
                newSegmentButton.tintColor = selectedTextColor
            }else{
                newSegmentButton.backgroundColor = deSelectedColor
                newSegmentButton.tintColor = deSelectedTextColor
            }
            let leftView = index == 0 ? self : renderedSegments[index-1]
            let horizontalEdge1: HorizontalEdge = index == 0 ? .left : .right
            
            //left and top
            newSegmentButton.anchor(toView: leftView, myHorizontalEdge: .left, viewHorizontalEdge: horizontalEdge1, shouldUseSafeAreaHorizontally: false, horizontalOffset: internalMargin, myVerticalEdge: .top, viewVerticalEdge: .top, shouldUseSafeAreaVertically: false, verticalOffset: 0)
            
            //bottom
            newSegmentButton.anchor(toView: self, myHorizontalEdge: nil, viewHorizontalEdge: nil, shouldUseSafeAreaHorizontally: false, horizontalOffset: 0, myVerticalEdge: .bottom, viewVerticalEdge: .bottom, shouldUseSafeAreaVertically: false, verticalOffset: -internalMargin)
            
            //right
            if index == segmentNames.count - 1 {
                newSegmentButton.anchor(toView: self, myHorizontalEdge: .right, viewHorizontalEdge: .right, shouldUseSafeAreaHorizontally: false, horizontalOffset: -internalMargin, myVerticalEdge: nil, viewVerticalEdge: nil, shouldUseSafeAreaVertically: false, verticalOffset: 0)
            }
            
            //equate widths
            if index > 0 {
                let previousSegment = renderedSegments[index - 1]
                newSegmentButton.setWidth(equalToView: previousSegment)
            }
            index += 1
        })
    }
    
    private func selectSegment(atIndex index: Int) {
        guard selectedIndex != index else { return }
        renderedSegments.forEach({
            $0.backgroundColor = deSelectedColor
            $0.tintColor = deSelectedTextColor
        })
        let selectedSegment = renderedSegments[index]
        selectedSegment.backgroundColor = selectionColor
        selectedSegment.tintColor = selectedTextColor
        selectedIndex = index
        delegate?.didSelect(item: selectedSegment.title(for: .normal)!, atIndex: index)
    }
    
    private func setSegmentFont() {
        renderedSegments.forEach( {
            $0.titleLabel?.font = segmentFont
        })
    }
    
    @objc func segmentButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        selectSegment(atIndex: tag)
    }
}
