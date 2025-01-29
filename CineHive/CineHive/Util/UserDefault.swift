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
  let defaultValue: T
  
  var wrappedValue: T {
    get {
        guard
            let data = UserDefaults.standard.object(forKey: key) as? Data,
            let object = try? JSONDecoder().decode(T.self, from: data)
        else {
            return defaultValue
        }
        return object
    }
    set {
        do {
            let encoded = try JSONEncoder().encode(newValue)
            UserDefaults.standard.set(encoded, forKey: key)
        } catch {
            print("저장 실패")
        }
    }
  }
}

enum UserDefaultKey {
    static let userProfile = "userProfile"
}
