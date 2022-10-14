//
//  Extensions.swift
//  MovieApp
//
//  Created by Jawed on 13/10/2022.
//

import UIKit

extension UIView {
    
    func blurView(color : UIColor)
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.restorationIdentifier = "blurView"
        //         blurEffectView.alpha = 0.8
        
        // TODO couleur blur
        blurEffectView.backgroundColor = color.withAlphaComponent(0.2)
        
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.frame = blurEffectView.contentView.bounds
        
        
        blurEffectView.contentView.addSubview(vibrancyView)
        
        self.addSubview(blurEffectView)
    }
    
    
}
