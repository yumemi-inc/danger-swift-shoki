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
    
    func markdown(_ message: String) {
        markdownResolver(message)
    }
    
    func message(_ message: String) {
        messageResolver(message)
    }
    
}

extension Shoki {
    
    public func report(_ result: CheckResult) {
        
        markdown(result.markdownTitle)
        
        if !result.markdownMessage.isEmpty {
            markdown(result.markdownMessage)

        }
        
        if !result.markdownTodos.isEmpty {
            markdown(result.markdownTodos)
        }
        
        if result.warningsCount == 0 && result.errorsCount == 0 {
            message("Good Job :white_flower:")
        }
        
    }
    
}
