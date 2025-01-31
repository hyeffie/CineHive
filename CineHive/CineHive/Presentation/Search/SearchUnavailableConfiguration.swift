//
//  SearchUnavailableConfiguration.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import UIKit

enum SearchUnavailableConfiguration {
    static let beforeSearch = UIContentUnavailableConfiguration.empty()
    
    static let noSearchingResults: UIContentUnavailableConfiguration = {
        var config = UIContentUnavailableConfiguration.empty()
        config.image = UIImage(systemName: "exclamationmark.magnifyingglass")
        config.text = "검색 결과가 없습니다"
        config.secondaryText = "원하는 검색 결과를 찾지 못했습니다"
        return config
    }()
}

