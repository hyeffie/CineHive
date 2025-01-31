//
//  NetworkError.swift
//  CineHive
//
//  Created by Effie on 1/30/25.
//

enum NetworkError: PresentableError {
    case afError(afDescription: String)
    case encodingError
    case decodingError
    case tmdbError(TMDBError)
    case accessKeyNotFound
    case unknown
    
    var message: String {
        switch self {
        case .afError(let afDescription):
            return "네트워크 에러가 발생했어요"
        case .encodingError, .decodingError:
            return "앱에서 데이터를 처리하는 데에 문제가 생겼어요"
        case .tmdbError(let tmdbError):
            return "TMDB에서 데이터를 가져오는 중에 문제가 생겼어요\n\(tmdbError.messsage)"
        case .accessKeyNotFound:
            return "데이터에 접근할 수 있는 권한이 없어요"
        case .unknown:
            return "에러가 발생했어요"
        }
    }
}
