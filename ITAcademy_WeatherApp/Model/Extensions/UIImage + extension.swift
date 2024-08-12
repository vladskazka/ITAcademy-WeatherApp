//
//  UIImage + extension.swift
//  ITAcademy_WeatherApp
//
//  Created by Влад Муравьев on 09.07.2024.
//

import UIKit

extension UIImage {
    
    func withPalette(_ colors: [UIColor]) -> UIImage? {
        let config = UIImage.SymbolConfiguration(paletteColors: colors)
        return self.applyingSymbolConfiguration(config)
    }
    
}
