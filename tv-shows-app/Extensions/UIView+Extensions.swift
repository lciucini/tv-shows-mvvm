//
//  UIView+Extensions.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 19/11/2020.
//

import UIKit

extension UIView{
    // For insert layer in Foreground
    func addGradientLayerInForeground(frame: CGRect, colors:[UIColor], opacity: Float = 1){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        gradient.opacity = opacity
        self.layer.addSublayer(gradient)
    }
    // For insert layer in background
    func addGradientLayerInBackground(frame: CGRect, colors:[UIColor], opacity: Float = 1){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        gradient.opacity = opacity
        self.layer.insertSublayer(gradient, at: 0)
    }
    func fadeIn(_ duration: TimeInterval? = 0.2) {
        guard let oldColor = backgroundColor, oldColor != .bgVisibleLigth else { return }
        self.isHidden = false
        backgroundColor = .bgHidden
        UIView.animate(withDuration: duration!, animations: { self.backgroundColor = .bgVisibleLigth })
    }
    
    func fadeOut(_ duration: TimeInterval? = 0.2) {
        guard let oldColor = backgroundColor, oldColor != .bgHidden else { return }
        UIView.animate(withDuration: duration!,
                       animations: { self.backgroundColor = .bgHidden },
                       completion: { (value: Bool) in self.isHidden = true })
    }
}
