//
//  String + extension.swift
//  ITAcademy_WeatherApp
//
//  Created by Влад Муравьев on 04.07.2024.
//

import Foundation

extension String {
    
    func edited() -> String {
        
        var editedText = self
        
        while editedText.hasSuffix(" ") {
            print("Removed - \(editedText.removeLast())")
        }
        
        while editedText.hasPrefix(" ") {
            print("Removed - \(editedText.removeFirst())")
        }
        
        editedText = editedText.replacingOccurrences(of: " ", with: "%20")
        
        return editedText
    }
}
