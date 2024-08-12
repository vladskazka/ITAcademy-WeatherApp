//
//  Bindable.swift
//  ITAcademy_WeatherApp
//
//  Created by Влад Муравьев on 25.07.2024.
//

import Foundation

class Bindable<T> {
    typealias Listener = (T) -> Void
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    private var listener: Listener?
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
