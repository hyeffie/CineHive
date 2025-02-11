//
//  Observable.swift
//  CineHive
//
//  Created by Effie on 2/9/25.
//

import Foundation

final class Observable<Value> {
    var value: Value {
        didSet {
            observer?(self.value)
        }
    }
    
    init(value: Value) {
        self.value = value
    }
    
    private var observer: ((Value) -> ())?
    
    func bind(to observer: @escaping (Value) -> ()) {
        self.observer = observer
        self.observer?(self.value)
    }
    
    func lazyBind(to observer: @escaping (Value) -> ()) {
        self.observer = observer
    }
}
