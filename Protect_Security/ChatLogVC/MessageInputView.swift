//
//  MessageInputView.swift
//  Protect_Security
//
//  Created by Jatin Garg on 22/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit
import SAMTextView

class MessageInputView: UIView {
    @IBInspectable public var font: UIFont = Font.font(ofSize: 15, andFace: .regular)
    @IBInspectable public var fontColor: UIColor = .black
    @IBInspectable public var placeholder: String = "Type a message.."
    @IBInspectable public var maxLines: Int = 14
    
    public var sendBtnSize: CGFloat = 36
    public var textFieldVerticalMargin: CGFloat = 4
    public var sendTapHandler: ((String?)->Void)?
    private var originalHeight: CGFloat?
    
    private var previousHeight: CGFloat?
    private var timesIncremented: Int = 0
    public var myHeightConstraint: NSLayoutConstraint? {
        for constraint in constraints {
            if constraint.firstAttribute == NSLayoutAttribute.height {
                if originalHeight == nil {
                    originalHeight = constraint.constant
                }
                return constraint
            }
        }
        return nil
    }
    
    lazy var textView: SAMTextView = {
        let t = SAMTextView()
        t.autocorrectionType = .no
        t.delegate = self
        t.font = font
        t.textColor = fontColor
        t.placeholder = placeholder
        return t
    }()
    
    lazy var textViewContainer: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.masksToBounds = true
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.gray.cgColor
        return v
    }()
    
    lazy var sendBtn: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(named: "send")!, for: .normal)
        b.backgroundColor = Color.accentColor
        b.tintColor = .white
        b.addTarget(self, action: #selector(sendPressed), for: .touchUpInside)
        return b
    }()
    
    @objc func sendPressed(_ sender: UIButton) {
        if textView.text != "" {
           sendTapHandler?(textView.text.trim())
            self.myHeightConstraint?.constant = 50
            self.layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup(){
        textViewContainer.addSubview(textView)
        addSubview(textViewContainer)
        addSubview(sendBtn)
        
        addConstraintsWithFormat("H:|-8-[v0]-8-[v1(\(sendBtnSize))]-8-|", views: textViewContainer,sendBtn)
        addConstraintsWithFormat("V:[v0(\(sendBtnSize))]", views: sendBtn)
        addConstraintsWithFormat("V:|-\(textFieldVerticalMargin)-[v0]-\(textFieldVerticalMargin)-|", views: textViewContainer)
        sendBtn.constraintCenterYToSuperview()
        
        //layout textview inside container
        textViewContainer.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: textView)
        textViewContainer.addConstraintsWithFormat("V:|-4-[v0]-4-|", views: textView)
        
        layoutIfNeeded()
        
        textViewContainer.layer.cornerRadius = textViewContainer.bounds.height/2
        sendBtn.layer.masksToBounds = true
        sendBtn.layer.cornerRadius = sendBtn.bounds.width/2
    }
}


extension MessageInputView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let newHeight = textView.contentSize.height
        
        if previousHeight == nil {
            previousHeight = newHeight
        }else{
            if previousHeight! != newHeight{
                //calculate difference
                let difference = newHeight - previousHeight!
                if difference > 0 && timesIncremented > maxLines {
                    return
                }
                myHeightConstraint?.constant += difference/2
                timesIncremented += difference > 0 ? 1 : 0
                previousHeight = newHeight
                UIView.animate(withDuration: 0.3, animations: {
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let previousChar = textView.text.last
        
        //resign first responder if previous char is nil and the new one is "\n"
        if text == "\n"{
            if previousChar == nil {
                textView.resignFirstResponder()
            }
            return previousChar != "\n"
        }
        return true
    }
    
    func resetViewToNormalHeight(){
        guard let height = originalHeight else {
            return
        }
        myHeightConstraint?.constant = height
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        //restore textfield height to normal if not visible text is there
        let text = textView.text.trim()
        
        if text.count == 0{
            resetViewToNormalHeight()
            textView.text = nil
        }
    }
    public func toggleSendButton(isEnabled:Bool) {
        if isEnabled{
            sendBtn.isUserInteractionEnabled = true
        } else {
            sendBtn.isUserInteractionEnabled = false
        }
    }
}
