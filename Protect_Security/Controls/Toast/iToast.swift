//
//  iToast.swift
//  Shitisha
//
//  Created by Jatin Garg on 3/7/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class iToast: UIView {
    private let internalPadding: CGFloat = 8
    private let externalPadding: CGFloat = 20
    
    var toastLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        l.setContentHuggingPriority(.defaultLow, for: .horizontal)
        l.setContentHuggingPriority(.defaultLow, for: .vertical)
        l.font = UIFont.systemFont(ofSize: 14)
        l.textAlignment = .center
        l.textColor = .white
        return l
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    convenience init(text: String) {
        self.init()
        toastLabel.text = text
        toastLabel.sizeToFit()
    }
    
    public func show(){
        //set dim
        let screenBounds = UIScreen.main.bounds
        let insetRect = screenBounds.insetBy(dx: screenBounds.width * 0.2, dy: 0)
        let maxWidth = insetRect.width
        
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        layer.zPosition = CGFloat(MAXFLOAT)
        guard let keyWindow = UIApplication.shared.windows.last else {
            return
        }
        keyWindow.addSubview(self)
        
        let toastWidth = min(toastLabel.frame.width + (2*internalPadding), maxWidth)
        
        let calculatedHeight = toastLabel.text!.height(withConstrainedWidth: toastWidth, font: toastLabel.font) + 30
        let toastHeight = max(toastLabel.frame.height + (internalPadding),calculatedHeight)
        
        self.frame = CGRect(origin: CGPoint(x: screenBounds.midX - toastWidth/2, y: screenBounds.maxY - toastHeight - 50), size: CGSize(width: toastWidth, height: toastHeight))
        alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        }){ _ in
            //start the timer
            Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(self.showTimeExpired), userInfo: nil, repeats: false)
        }
        layer.cornerRadius = toastHeight * 0.2
        setLabelDim()
    }
    
    private func setLabelDim(){
        addConstraintsWithFormat("H:|-\(internalPadding)-[v0]-\(internalPadding)-|", views: toastLabel)
        addConstraintsWithFormat("V:|-\(internalPadding)-[v0]-\(internalPadding)-|", views: toastLabel)
    }
    
    @objc func showTimeExpired(timer: Timer) {
        timer.invalidate()
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }){ _ in
            self.removeFromSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup(){
        addSubview(toastLabel)
    }
}
