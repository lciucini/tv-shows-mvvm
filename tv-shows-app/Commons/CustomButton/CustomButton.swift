//
//  RoundedButton.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 19/11/2020.
//

import Foundation
import UIKit
import PureLayout
import RxCocoa

class CustomButton: UIButton {
    var disabledColorHandle: UInt8 = 0
    var highlightedColorHandle: UInt8 = 0
    var selectedColorHandle: UInt8 = 0
    
    enum Style {
        case rounded, square
        
        var bgColor: UIColor {
            switch self {
            case .rounded:
                return .clear
            case .square:
                return .clear
            }
        }
        
        var titleColor: UIColor {
            switch self {
            case .rounded:
                return .light
            case .square:
                return .gray_ligth
            }
        }
    }
    
    private var style: Style = .rounded
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setStyle()
    }
    
    func setStyle(style: Style = .rounded) {
        self.style = style

        switch style {
        case .rounded:
            self.applyRoundedStyle()
        case .square:
            self.applySquareStyle()
        }
    }
    
    private func applyRoundedStyle() {
        tintColor = .clear
        titleLabel?.textColor = .clear
        contentEdgeInsets = UIEdgeInsets(top: 14, left: 41, bottom: 14, right: 41)
        // Layer
        layer.cornerRadius = 25
        layer.masksToBounds = true
        backgroundColor = nil
        // Border
        layer.borderWidth = 2
        layer.borderColor = UIColor.light.cgColor
        // Title Colors
        setTitleColor(.light, for: .normal)
        setTitleColor(UIColor.light.withAlphaComponent(0.8), for: .highlighted)
    }
    
    private func applySquareStyle() {
        tintColor = .clear
        titleLabel?.textColor = .clear
        contentEdgeInsets = UIEdgeInsets(top: 4, left: 11, bottom: 4, right: 11)
        // Layer
        layer.cornerRadius = 2
        layer.masksToBounds = true
        backgroundColor = nil
        // Border
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray_ligth.cgColor
        // Title Colors
        setTitleColor(.gray, for: .normal)
    }
}

extension CustomButton {
    private func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(image(withColor: color), for: state)
    }

    @IBInspectable
    var disabledColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &disabledColorHandle) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .disabled)
                objc_setAssociatedObject(self, &disabledColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .disabled)
                objc_setAssociatedObject(self, &disabledColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    @IBInspectable
    var highlightedColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &highlightedColorHandle) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .highlighted)
                objc_setAssociatedObject(self, &highlightedColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .highlighted)
                objc_setAssociatedObject(self, &highlightedColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    @IBInspectable
    var selectedColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &selectedColorHandle) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .selected)
                objc_setAssociatedObject(self, &selectedColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .selected)
                objc_setAssociatedObject(self, &selectedColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
