//
//  SearchUnavailableConfiguration.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import UIKit

enum SearchUnavailableConfiguration {
    static let noSearchingResults: UIContentUnavailableConfiguration = {
        var config = UIContentUnavailableConfiguration.empty()
        config.secondaryText = "원하는 검색 결과를 찾지 못했습니다"
        config.secondaryTextProperties.color = CHColor.lightLabelBackground
        return config
    }()
}

