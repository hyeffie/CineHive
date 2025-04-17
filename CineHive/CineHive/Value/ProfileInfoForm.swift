//
//  ProfileInfoForm.swift
//  CineHive
//
//  Created by Effie on 1/29/25.
//

struct ProfileInfoForm {
    var imageNumber: Int
    var nickname: String
    var mbti: UserMBTI
    
    init(
        imageNumber: Int = (0..<12).randomElement() ?? 0,
        nickname: String = "",
        mbti: UserMBTI
    ) {
        self.imageNumber = imageNumber
        self.nickname = nickname
        self.mbti = mbti
    }
}

struct UserMBTI: Codable {
    let ei: MBTI.EI
    let ns: MBTI.NS
    let tf: MBTI.TF
    let pj: MBTI.PJ
    
    init(_ ei: MBTI.EI, _ ns: MBTI.NS, _ tf: MBTI.TF, _ pj: MBTI.PJ) {
        self.ei = ei
        self.ns = ns
        self.tf = tf
        self.pj = pj
    }
}
