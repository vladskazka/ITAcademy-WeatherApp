//
//  CALayer + extension.swift
//  ITAcademy_WeatherApp
//
//  Created by Влад Муравьев on 11.07.2024.
//

import UIKit

extension CALayer {
    
    func setWhiteShadow() {
        self.shadowColor = UIColor.white.cgColor
        self.shadowOpacity = 1
        self.shadowOffset = CGSize(width: 0, height: 0)
        self.shadowRadius = 10
        
    }
}
