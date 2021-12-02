//
//  Shoki.swift
//  
//
//  Created by 史 翔新 on 2021/11/16.
//

import Danger

public struct Shoki {
    
    private let markdownExecutor: (String) -> Void
    private let messageExecutor: (String) -> Void
    private let warningExecutor: (String) -> Void
    private let failureExecutor: (String) -> Void
    
    init(
        markdownExecutor: @escaping (String) -> Void,
        messageExecutor: @escaping (String) -> Void,
        warningExecutor: @escaping (String) -> Void,
        failureExecutor: @escaping (String) -> Void
    ) {
        self.markdownExecutor = markdownExecutor
        self.messageExecutor = messageExecutor
        self.warningExecutor = warningExecutor
        self.failureExecutor = failureExecutor
    }
    
}

extension Shoki {
    
    func markdown(_ message: String) {
        markdownExecutor(message)
    }
    
    func message(_ message: String) {
        messageExecutor(message)
    }
    
    func warn(_ warning: String) {
        warningExecutor(warning)
    }
    
    func fail(_ failure: String) {
        failureExecutor(failure)
    }
    
}

extension Shoki {
    
    public func report(_ result: CheckResult, using configuration: MarkdownConfiguration = .default) {
        
        let markdownTitle = configuration.titleMarkdownFormatter(result.title)
        if !markdownTitle.isEmpty {
            markdown(markdownTitle)
        }
        
        let markdownMessage = configuration.messageMarkdownFormatter(result.checkItems)
        if !markdownMessage.isEmpty {
            markdown(markdownMessage)
        }
        
        for warning in result.warnings {
            let markdownWarning = configuration.warningMarkdownFormatter(warning)
            warn(markdownWarning)
        }
        
        for failure in result.failures {
            let markdownFailure = configuration.failureMarkdownFormatter(failure)
            fail(markdownFailure)
        }
        
        let markdownTodos = configuration.todosMarkdownFormatter(result.todos)
        if !markdownTodos.isEmpty {
            markdown(markdownTodos)
        }

        if result.warnings.isEmpty && result.failures.isEmpty {
            message(configuration.congratulationsMessage)
        }
        
    }
    
}
