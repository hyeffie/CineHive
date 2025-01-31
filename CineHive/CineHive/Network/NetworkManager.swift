//
//  NetworkManager.swift
//  CineHive
//
//  Created by Effie on 1/30/25.
//

import Foundation
import Alamofire

final class NetworkManager {
    func getTrendingMovies(
        timeWindow: TimeWindow = .day,
        trendingMovieParameter: TrendingMovieRequestParameter = .init(page: 1, language: "ko-KR"),
        successHandler: @escaping (TrendingMovieResponse) -> (),
        failureHandler: @escaping (NetworkError) -> ()
    ) {
        let components = TMDBRequestComponents(
            path: "trending/movie/\(timeWindow)",
            queryParamerters: trendingMovieParameter
        )
        callTMDBGET(
            requestComponents: components,
            successHandler: successHandler,
            failureHandler: failureHandler
        )
    }
    
    func getSearchResult(
        searchMovieParameter: SearchMovieRequestParameter,
        successHandler: @escaping (SearchMovieResponse) -> (),
        failureHandler: @escaping (NetworkError) -> ()
    ) {
        let components = TMDBRequestComponents(
            path: "search/movie",
            queryParamerters: searchMovieParameter
        )
        callTMDBGET(
            requestComponents: components,
            successHandler: successHandler,
            failureHandler: failureHandler
        )
    }
    
    private func tmdbAuth() -> HTTPHeader? {
        guard
            let apiKey = KeyLoader.loadKey(scope: .TMDB, item: .apiKey)
        else {
            return nil
        }
        return HTTPHeader.authorization(bearerToken: apiKey)
    }
    
    private func callTMDBGET<
        RequestParameter: Encodable,
        SuccessResponse: Decodable
    >(
        requestComponents components: TMDBRequestComponents<RequestParameter>,
        successHandler: @escaping (SuccessResponse) -> (),
        failureHandler: @escaping (NetworkError) -> ()
    ) {
        let baseURL = "https://api.themoviedb.org/3/"
        guard let authorization = tmdbAuth() else {
            failureHandler(.accessKeyNotFound)
            return
        }
        AF
            .request(
                baseURL + components.path,
                parameters: components.queryParamerters,
                encoder: URLEncodedFormParameterEncoder(destination: .queryString),
                headers: [ authorization ],
                requestModifier: { request in
                    dump(request)
                }
            )
            .responseDecodable(of: TMDBResponse<SuccessResponse>.self) { [weak self] afResponse in
                guard let self else { return }
                
                switch afResponse.result {
                case .success(let response):
                    switch response {
                    case .success(let searchResponse):
                        successHandler(searchResponse)
                    case .failure(let response):
                        guard let statusCode = afResponse.response?.statusCode else {
                            failureHandler(.unknown)
                            return
                        }
                        let networkError = self.convertTMDBErrorResponseToNetworkError(
                            statusCode: statusCode,
                            message: response.status_message
                        )
                        failureHandler(networkError)
                    }
                case .failure(let afError):
                    let networkError = self.convertAFErrorToNetworkError(afError: afError)
                    failureHandler(networkError)
                }
            }
    }
    
    private func convertAFErrorToNetworkError(afError: AFError) -> NetworkError {
        if afError.isParameterEncoderError {
            return .encodingError
        } else if afError.isResponseSerializationError {
            return .decodingError
        } else {
            return .afError(afDescription: afError.localizedDescription)
        }
    }
    
    private func convertTMDBErrorResponseToNetworkError(
        statusCode: Int,
        message: String
    ) -> NetworkError {
        let tmdbError = TMDBError(
            statusCode: statusCode,
            messsage: message
        )
        return .tmdbError(tmdbError)
    }
}
