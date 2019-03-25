//
//  Fonts.swift
//  Protect_Security
//
//  Created by Jatin Garg on 13/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

enum FontFace {
    case regular, bold, semiBold
    public var fontWeight: UIFont.Weight {
        switch self {
        case .regular:
            return .regular
        case .bold:
            return .bold
        case .semiBold:
            return .semibold
        }
    }
}

struct Font {
    static func font(ofSize size: CGFloat, andFace face: FontFace) -> UIFont{
        return UIFont.systemFont(ofSize: size, weight: face.fontWeight)
    }
}
