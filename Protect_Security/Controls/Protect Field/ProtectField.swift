//
//  ProtectField.swift
//  Protect_Security
//
//  Created by Jatin Garg on 13/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

extension ProtectField: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.fieldDidEndEditing?(field: self)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.fieldDidBeginEditing?(field: self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return delegate?.shouldChange?(charactersInRange: range, replacementString: string, field: self) ?? true
    }
}
class ProtectField: View {
    private var messageLabel: UILabel = {
        let l = UILabel()
        l.font = Font.font(ofSize: 13, andFace: .regular)
        l.textColor = Color.placeholderColor
        l.text = "Placeholder"
        l.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return l
    }()
    
    private lazy var textfield: UITextField = {
        let t = UITextField()
        t.font = Font.font(ofSize: 16, andFace: .regular)
        t.textColor = normalTextcolor
        t.setContentHuggingPriority(.defaultLow, for: .vertical)
        t.setContentHuggingPriority(.defaultLow, for: .horizontal)
        t.delegate = self
        return t
    }()
    
    private lazy var rightAction: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(named: "eye-off"), for: .normal)
        b.addTarget(self, action: #selector(rightActionTapped(_:)), for: .touchUpInside)
        return b
    }()
    
    private let horizontalPadding: CGFloat = 12
    private let verticalPadding: CGFloat = 8
    private let innerInset: CGFloat = 0
    private var rightActionWidthAnchor: NSLayoutConstraint!
    private let errorColor: UIColor = Color.errorColor
    private let normalTextcolor: UIColor = Color.textColor
    
    @IBInspectable var placeholder: String? {
        get{
            return messageLabel.text
        }set{
            messageLabel.text = newValue
        }
    }
    
    @IBInspectable public var text: String?{
        get{
            return textfield.text
        }set{
            textfield.text = newValue
        }
    }
    
    @IBInspectable public var textColor: UIColor?{
        get{
            return textfield.textColor
        }set{
            textfield.textColor = newValue
        }
    }
    
    @IBInspectable public var rightImage: UIImage? {
        get{
            return rightAction.image(for: .normal)
        }set{
            rightAction.setImage(newValue, for: .normal)
            
            rightActionWidthAnchor?.constant = newValue == nil ? 0 : 30
            layoutIfNeeded()
        }
    }
    
    @IBInspectable public var rightActionTint: UIColor = Color.defaultImageTintColor {
        didSet{
            rightAction.tintColor = rightActionTint
        }
    }
    
    @IBInspectable public var isSecure: Bool = false {
        didSet{
            textfield.isSecureTextEntry = isSecure
        }
    }
    
    @IBInspectable public var keyboardType: UIKeyboardType {
        get{
            return textfield.keyboardType
        }set{
            textfield.keyboardType = newValue
        }
    }
    
    public weak var delegate: ProtectFieldDelegate?
    public var shouldIndicateError: Bool = false {
        didSet{
            textfield.textColor = shouldIndicateError ? errorColor : normalTextcolor
        }
    }
    
    override func setup() {
        addSubview(messageLabel)
        addSubview(textfield)
        addSubview(rightAction)
        
        //setup anchors
        messageLabel.anchor(toView: self, myHorizontalEdge: .left, viewHorizontalEdge: .left, shouldUseSafeAreaHorizontally: false, horizontalOffset: horizontalPadding, myVerticalEdge: .top, viewVerticalEdge: .top, shouldUseSafeAreaVertically: false, verticalOffset: verticalPadding)
        
        rightAction.anchor(toView: self, myHorizontalEdge: .right, viewHorizontalEdge: .right, shouldUseSafeAreaHorizontally: false, horizontalOffset: -horizontalPadding, myVerticalEdge: nil, viewVerticalEdge: nil, shouldUseSafeAreaVertically: false, verticalOffset: 0)
        rightAction.anchor(toView: textfield, myHorizontalEdge: .left, viewHorizontalEdge: .right, shouldUseSafeAreaHorizontally: false, horizontalOffset: 0, myVerticalEdge: nil, viewVerticalEdge: nil, shouldUseSafeAreaVertically: false, verticalOffset: 0)
        rightAction.setCenter(withRespectTo: textfield, axis: .vertical)
        rightAction.setHeight(equalToView: textfield)
        rightActionWidthAnchor = NSLayoutConstraint(item: rightAction, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        addConstraint(rightActionWidthAnchor)
        
        textfield.anchor(toView: messageLabel, myHorizontalEdge: .left, viewHorizontalEdge: .left, shouldUseSafeAreaHorizontally: false, horizontalOffset: 0, myVerticalEdge: .top, viewVerticalEdge: .bottom, shouldUseSafeAreaVertically: false, verticalOffset: innerInset)
        
        textfield.anchor(toView: self, myHorizontalEdge: nil, viewHorizontalEdge: nil, shouldUseSafeAreaHorizontally: false, horizontalOffset: 0, myVerticalEdge: .bottom, viewVerticalEdge: .bottom, shouldUseSafeAreaVertically: false, verticalOffset: verticalPadding)
        
        //extras
        layer.masksToBounds = true
        layer.cornerRadius = 3
        layer.borderWidth = 1
        layer.borderColor = Color.textfieldBorderColor.cgColor
        rightAction.tintColor = rightActionTint
    }
    
    @objc func rightActionTapped(_ sender: UIButton) {
        delegate?.didTapRightActionButton?(field: self)
    }
}
