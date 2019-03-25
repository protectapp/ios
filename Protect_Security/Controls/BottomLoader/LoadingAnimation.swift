//
//  BottomLoaderView.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 11/01/2019.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import UIKit

enum LoadingPosition {
    case top, bottom
}
class LoadingAnimation: UIView {
    private let verticalMargin: CGFloat = 20
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpLoadingView()
    }
    
    private lazy var lazyLoaderImageView : UIImageView = {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        imageView.contentMode = .scaleAspectFit
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "loader", withExtension: "gif")!)
        imageView.image = UIImage.gifImageWithData(data: imageData! as NSData)
        self.addSubview(imageView)
        return imageView
    }()
    
    convenience init(lazyLoaderImageView : UIImageView) {
        self.init()
        self.lazyLoaderImageView = lazyLoaderImageView
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpLoadingView() {
        lazyLoaderImageView.translatesAutoresizingMaskIntoConstraints = false
        lazyLoaderImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        lazyLoaderImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        lazyLoaderImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        lazyLoaderImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.layoutIfNeeded()
    }
    
    func loadOnView(view: UIView, atPosition position: LoadingPosition){
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        switch position {
        case .top:
            if #available(iOS 11.0, *) {
                topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalMargin).isActive = true
            } else {
                // Fallback on earlier versions
                topAnchor.constraint(equalTo: view.topAnchor, constant: verticalMargin).isActive = true
            }
        case .bottom:
            if #available(iOS 11.0, *) {
                bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -verticalMargin).isActive = true
            } else {
                // Fallback on earlier versions
                bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -verticalMargin).isActive = true
            }
        }
        
        layoutIfNeeded()
    }
}
