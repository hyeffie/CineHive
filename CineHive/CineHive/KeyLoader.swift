//
//  KeyLoader.swift
//  CineHive
//
//  Created by Effie on 1/30/25.
//

import Foundation

enum KeyLoader {
    private struct FileExtension {
        static let propertyList = "plist"
    }
    
    private enum ResourceName {
        static let Credential = "Credential"
    }
    
    private static let confidentialDictionary: NSDictionary?  = {
        guard
            let confidentialURL = Bundle.main.path(forResource: ResourceName.Credential, ofType: FileExtension.propertyList)
        else {
            return nil
        }
        return NSDictionary(contentsOfFile: confidentialURL)
    }()
    
    static func loadKey(scope: Confidential.Scope, item: Confidential.Item) -> String? {
        guard
            let scope = confidentialDictionary?[scope.rawValue] as? NSDictionary,
            let result = scope[item.rawValue] as? String
        else {
            return nil
        }
        return String(result)
    }
}

enum Confidential {
    enum Scope: String {
        case TMDB
    }
    
    enum Item: String {
        case apiKey = "API Key"
    }
}

