//
//  UIView+Extensions.swift
//  Protect_Security
//
//  Created by Jatin Garg on 13/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit
enum HorizontalEdge {
    case left,right
}

enum VerticalEdge{
    case top, bottom
}

enum CenterAxis {
    case horizontal, vertical
}

extension UIView {
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    func anchor(toView view: UIView,
                myHorizontalEdge: HorizontalEdge? = nil,
                viewHorizontalEdge: HorizontalEdge? = nil,
                shouldUseSafeAreaHorizontally: Bool = false,
                horizontalOffset: CGFloat,
                myVerticalEdge: VerticalEdge? = nil,
                viewVerticalEdge: VerticalEdge? = nil,
                shouldUseSafeAreaVertically: Bool = false,
                verticalOffset: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if myHorizontalEdge != nil && viewHorizontalEdge != nil {
            let targetAnchor = myHorizontalEdge! == .left ? self.leftAnchor : self.rightAnchor
            var viewAnchor: NSLayoutXAxisAnchor!
            if #available(iOS 11.0, *) {
                viewAnchor = viewHorizontalEdge! == .left ? shouldUseSafeAreaHorizontally ? view.safeAreaLayoutGuide.leftAnchor : view.leftAnchor : shouldUseSafeAreaHorizontally ? view.safeAreaLayoutGuide.rightAnchor : view.rightAnchor
            } else {
                viewAnchor = viewHorizontalEdge! == .left ? view.leftAnchor : view.rightAnchor
            }
            targetAnchor.constraint(equalTo: viewAnchor, constant: horizontalOffset).isActive = true
        }
        
        if myVerticalEdge != nil && viewVerticalEdge != nil {
            let targetAnchor = myVerticalEdge! == .top ? self.topAnchor : self.bottomAnchor
            var viewAnchor: NSLayoutYAxisAnchor!
            if #available(iOS 11.0, *) {
                viewAnchor = viewVerticalEdge! == .top ? shouldUseSafeAreaVertically ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor : shouldUseSafeAreaVertically ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor
            } else {
                viewAnchor = viewVerticalEdge! == .top ? view.topAnchor : view.bottomAnchor
            }
            targetAnchor.constraint(equalTo: viewAnchor, constant: verticalOffset).isActive = true
        }
        
    }
    
    func fixWidth(to width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func fixHeight(to height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(equalToView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    func setHeight(equalToView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func equateWidthAndHeight() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    func setCenter(withRespectTo view: UIView, axis: CenterAxis) {
        translatesAutoresizingMaskIntoConstraints = false
        
        switch axis {
        case .horizontal:
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        case .vertical:
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }
    
    public func addConstraintsWithFormat(_ format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    public func anchorCenterYToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    public func constraintCenterYToSuperview(){
        translatesAutoresizingMaskIntoConstraints = false
        superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    public func constraintCenterXToSuperview(){
        translatesAutoresizingMaskIntoConstraints = false
        superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 0))
    }
    
    public func anchorCenterXToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    public func anchorCenterSuperview() {
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }
    
    static func animateAsSpring(withDuration duration: TimeInterval,
                                _ animationBlock: @escaping ()->Void,
                                _ completionBlock: (()->Void)?) {
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            animationBlock()
        }, completion: { _ in
            completionBlock?()
        })
    }
    
    public func showIndicator() {
        IndicatorView.showOver(self)
    }
    
    public func startBlinking() {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { (timer) in
            let targetAlpha: CGFloat = self.alpha == 1 ? 0.3 : 1.0
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.alpha = targetAlpha
            }, completion: nil)
            
        }
        stopBlinking()
        blinkingTimer = timer
        
        timer.fire()
    }
    
    public func stopBlinking() {
        if blinkingTimer != nil {
            blinkingTimer?.invalidate()
            blinkingTimer = nil
        }
        alpha = 1
    }
    
    public func hideIndicator() {
        IndicatorView.hideFrom(self)
    }

    func showEmptyDatasetView(withTitle title: String?, actionTitle: String?, image: UIImage?, actionBlock: (()->())?) {
        emptyDatasetView?.removeFromSuperview()
        let newInstance = EmptyDatasetView(image: image,
                                           infoText: title,
                                           actionText: actionTitle,
                                           action: actionBlock)
        emptyDatasetView = newInstance
        addSubview(newInstance)
        newInstance.translatesAutoresizingMaskIntoConstraints = false
        newInstance.anchorCenterSuperview()
        newInstance.setWidth(equalToView: self)
        newInstance.setHeight(equalToView: self)
    }
    
    func showShimmerView<T: NSObject>(usingCellType cell: T.Type) {
        removeShimmerView()
        let newView = ShimmerAnimationView<T>()
        addSubview(newView)
        newView.shimmerCount = 5
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        newView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        newView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        newView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        shimmerView = newView
    }
    
    func removeShimmerView() {
        (shimmerView as? UIView)?.removeFromSuperview()
    }
    
    public func removeEmptydatasetView() {
        emptyDatasetView?.removeFromSuperview()
    }
    
    struct Holder {
        static var _blinkingTimer: Timer? = nil
        static var _loadingView: LoadingAnimation? = nil
        static var _emptyDatasetView: EmptyDatasetView? = nil
        static var _shimmerView: Any? = nil
    }
    
    weak var blinkingTimer: Timer? {
        get{
            return Holder._blinkingTimer
        }set{
            Holder._blinkingTimer = newValue
        }
    }
    
    weak var bottomLoader: LoadingAnimation? {
        
        get{
            return Holder._loadingView
        }set{
            Holder._loadingView = newValue
        }
    }
    
    weak var emptyDatasetView: EmptyDatasetView? {
        get{
            return Holder._emptyDatasetView
        }set{
            Holder._emptyDatasetView = newValue
        }
    }
    
    var shimmerView: Any? {
        get{
            return Holder._shimmerView
        }set{
            Holder._shimmerView = newValue
        }
    }
    
    func showLoadingView(atPostion position: LoadingPosition = .bottom) {
        let loadingView = LoadingAnimation()
        bottomLoader = loadingView
        loadingView.loadOnView(view: self, atPosition: position)
        bottomLoader?.isHidden = false
    }
    
    func hideLoadingView(){
        bottomLoader?.isHidden = true
    }
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
