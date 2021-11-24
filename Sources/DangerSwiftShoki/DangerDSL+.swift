//
//  DangerDSL+.swift
//  
//
//  Created by 史 翔新 on 2021/11/13.
//

import Danger

extension DangerDSL {
    
    public var shoki: Shoki {
        return .init(markdownExecutor: { markdown($0) },
                     messageExecutor: { message($0) })
    }
    
}
