//
//  TMDBError.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

struct TMDBError: Error {
    let statusCode: Int
    let messsage: String
}
