//
//  UserDefault.swift
//  CineHive
//
//  Created by Effie on 1/29/25.
//

import Foundation

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String
    
    var wrappedValue: T? {
        get {
            guard
                let data = UserDefaults.standard.object(forKey: key) as? Data,
                let object = try? JSONDecoder().decode(T.self, from: data)
            else {
                return nil
            }
            return object
        }
        set {
            do {
                if let newValue {
                    let encoded = try JSONEncoder().encode(newValue)
                    UserDefaults.standard.set(encoded, forKey: key)
                } else {
                    UserDefaults.standard.removeObject(forKey: key)
                }
            } catch {
                fatalError()
            }
        }
    }
}

enum UserDefaultKey {
    static let userProfile = "userProfile"
}
