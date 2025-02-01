//
//  SubmittedQuery.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import Foundation

struct SubmittedQuery: Codable {
    let submittedDate: Date
    let query: String
}

extension SubmittedQuery: Hashable {
    static func == (lhs: SubmittedQuery, rhs: SubmittedQuery) -> Bool {
        return lhs.query == rhs.query
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(query)
    }
}
