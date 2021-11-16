//
//  DangerDSL+.swift
//  
//
//  Created by 史 翔新 on 2021/11/13.
//

import Danger

extension DangerDSL {
    
    public var shoki: Shoki {
        return .init(markdownResolver: { markdown($0) },
                     messageResolver: { message($0) })
    }
    
}
