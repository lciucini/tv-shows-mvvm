//
//  UIFont+Extensions.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 23/11/2020.
//

import UIKit


/**
 Enum for sizes reference
 */
enum Size {
    /**
     body 12 - title 14
     */
    case xs
    /**
     body 14 - title 16
     */
    case s
    /**
     body 16 - title 17
     */
    case m
    /**
     body 18 - title 18
     */
    case l
    /**
     body 24 - title 24
     */
    case xl
    
    var body: CGFloat {
        switch self {
        case .xs:
            return 12
        case .s:
            return 14
        case .m:
            return 16
        case .l:
            return 18
        case .xl:
            return 24
        }
    }
    
    var title: CGFloat {
        switch self {
        case .xs:
            return 14
        case .s:
            return 16
        case .m:
            return 17
        case .l:
            return 18
        case .xl:
            return 24
        }
    }
}

extension UIFont {
    
    static func regular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Regular", size: size)!
    }
    
    static func medium(_ size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Medium", size: size)!
    }
    
    static func bold(_ size: CGFloat) -> UIFont {        
        return UIFont(name: "SFProText-Bold", size: size)!
    }
}
