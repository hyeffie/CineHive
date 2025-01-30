//
//  TMDBImage.swift
//  CineHive
//
//  Created by Effie on 1/30/25.
//

import Foundation

enum TMDBImage {
    case original(_ path: String)
    case w500(_ path: String)
    
    private var urlString: String {
        switch self {
        case .original(let path):
            return "https://image.tmdb.org/t/p/original/\(path)"
        case .w500(let path):
            return "https://image.tmdb.org/t/p/w500/\(path)"
        }
    }
    
    var url: URL? {
        return URL(string: urlString)
    }
}
