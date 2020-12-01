//
//  UIColor+Extensions.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 18/11/2020.
//

import UIKit
import Foundation

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hexString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    static var light: UIColor {
        UIColor.white
    }
    
    static var dark: UIColor {
        UIColor(hex: "#1e2b31")
    }
    
    static var dark_ligth: UIColor {
        UIColor(hex: "#1b1b1b")
    }
    
    static var gray_ligth: UIColor {
        UIColor(hex: "#ffffff", alpha: 0.30)
    }
    
    static var slate: UIColor {
        UIColor(hex: "#3c5663")
    }
    
    static var ice_blue: UIColor {
        UIColor(hex: "#e1f5ff")
    }

    static var dark_blue: UIColor {
        UIColor(hex: "#091920")
    }
    
    static var bgVisibleLigth: UIColor {
        UIColor.dark.withAlphaComponent(0.30)
    }

    static var bgHidden: UIColor {
        UIColor.dark.withAlphaComponent(0)
    }
    
    static var text_light: UIColor {
        UIColor.light.withAlphaComponent(0.56)
    }
}
