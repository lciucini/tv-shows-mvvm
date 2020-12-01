//
//  UILabel+Extensions.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 18/11/2020.
//

import UIKit

enum TextStyle {
    case regular, bold, medium
}

extension UILabel {
    func bold(_ size: Size, _ color: UIColor) {
        textColor = color
        font = .bold(size.body)
    }
    func title(_ size: Size, _ color: UIColor, _ style: TextStyle = .bold) {
        textColor = color
        
        switch style {
        case .regular:
            font = .regular(size.title)
        case .bold:
            font = .bold(size.title)
        case .medium:
            font = .medium(size.title)
        }
    }
    func body(_ size: Size, _ color: UIColor, _ style: TextStyle = .medium) {
        textColor = color
        
        switch style {
        case .regular:
            font = .regular(size.title)
        case .bold:
            font = .bold(size.title)
        case .medium:
            font = .medium(size.title)
        }
    }
}
