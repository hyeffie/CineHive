//
//  MBTI.swift
//  CineHive
//
//  Created by Effie on 2/10/25.
//

import UIKit

struct MBTI {
    protocol Element: CaseIterable {
        var character: String { get }
    }
    
    enum EI: String, Element {
        case e = "E"
        case i = "I"
        
        var character: String { self.rawValue }
    }
    
    enum NS: String, Element {
        case n = "N"
        case s = "S"
        
        var character: String { self.rawValue }
    }
    
    enum TF: String, Element {
        case t = "T"
        case f = "F"
        
        var character: String { self.rawValue }
    }
    
    enum PJ: String, Element {
        case p = "P"
        case j = "J"
        
        var character: String { self.rawValue }
    }
    
    var ei: EI?
    var ns: NS?
    var tf: TF?
    var pj: PJ?
}
