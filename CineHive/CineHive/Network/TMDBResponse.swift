//
//  TMDBResponse.swift
//  CineHive
//
//  Created by Effie on 1/30/25.
//

import Foundation

enum TMDBResponse<SuccessfulResponse: Decodable>: Decodable {
    case success(SuccessfulResponse)
    case failure(ErrorResponse)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let success = try? container.decode(SuccessfulResponse.self) {
            self = .success(success)
        } else if let failure = try? container.decode(ErrorResponse.self) {
            self = .failure(failure)
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "cannot decode to this type"
            )
        }
    }
    
    struct ErrorResponse: Decodable {
        let status_code: Int
        let status_message: String
        let success: Bool
    }
}
