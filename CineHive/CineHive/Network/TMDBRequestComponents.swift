//
//  TMDBRequestComponents.swift
//  CineHive
//
//  Created by Effie on 1/30/25.
//

import Foundation

struct TMDBRequestComponents<Parameters: Encodable> {
    let path: String
    let queryParamerters: Parameters?
}

struct GeneralEncodable: Encodable {}
