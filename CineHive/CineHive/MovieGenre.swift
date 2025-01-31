//
//  MovieGenre.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

struct MovieGenre {
    let id: Int
    let name: String
    
    private init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    static let action = MovieGenre(id: 28, name: "액션")
    static let animation = MovieGenre(id: 16, name: "애니메이션")
    static let criminal = MovieGenre(id: 80, name: "범죄")
    static let drama = MovieGenre(id: 18, name: "드라마")
    static let fantasy = MovieGenre(id: 14, name: "판타지")
    static let horror = MovieGenre(id: 27, name: "공포")
    static let mystery = MovieGenre(id: 9648, name: "미스터리")
    static let sciFi = MovieGenre(id: 878, name: "SF")
    static let thriller = MovieGenre(id: 53, name: "스릴러")
    static let western = MovieGenre(id: 37, name: "서부")
    static let adventure = MovieGenre(id: 12, name: "모험")
    static let comedy = MovieGenre(id: 35, name: "코미디")
    static let documentary = MovieGenre(id: 99, name: "다큐멘터리")
    static let family = MovieGenre(id: 10751, name: "가족")
    static let history = MovieGenre(id: 36, name: "역사")
    static let music = MovieGenre(id: 10402, name: "음악")
    static let romance = MovieGenre(id: 10749, name: "로맨스")
    static let tvMovie = MovieGenre(id: 10770, name: "TV 영화")
    static let war = MovieGenre(id: 10752, name: "전쟁")
    
    static let all: [MovieGenre] = [
        action, animation, criminal, drama, fantasy, horror, mystery,
        sciFi, thriller, western, adventure, comedy, documentary,
        family, history, music, romance, tvMovie, war
    ]
    
    static func getName(by id: Int) -> String? {
        return all.first { $0.id == id }?.name
    }
}
