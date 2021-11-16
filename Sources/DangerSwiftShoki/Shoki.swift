//
//  Shoki.swift
//  
//
//  Created by 史 翔新 on 2021/11/16.
//

import Danger

public struct Shoki {
    
    let markdownResolver: (String) -> Void
    let messageResolver: (String) -> Void
    
}

extension Shoki {
    
    public func report(_ result: CheckResult) {
        
        markdownResolver(result.markdownTitle)
        
        if !result.markdownMessage.isEmpty {
            markdownResolver(result.markdownMessage)

        }
        
        if !result.markdownTodos.isEmpty {
            markdownResolver(result.markdownTodos)
        }
        
        if result.warningsCount == 0 && result.errorsCount == 0 {
            messageResolver("Good Job :white_flower:")
        }
        
    }
    
}
