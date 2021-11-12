//
//  DangerDSL+.swift
//  
//
//  Created by 史 翔新 on 2021/11/13.
//

import Danger

extension DangerDSL {
    
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
