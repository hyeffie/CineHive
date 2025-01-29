//
//  ProfileInfoForm.swift
//  CineHive
//
//  Created by Effie on 1/29/25.
//

struct ProfileInfoForm {
    var imageNumber: Int
    var nickname: String
    
    init(
        imageNumber: Int = (0..<12).randomElement() ?? 0,
        nickname: String = ""
    ) {
        self.imageNumber = imageNumber
        self.nickname = nickname
    }
}
