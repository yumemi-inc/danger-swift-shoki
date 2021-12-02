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
    
    public func makeInitialReport(title: String) -> Report {
        
        .init(title: title)
        
    }
    
    public func check(_ title: String, into report: inout Report, execution: () -> Report.CheckItem.Result) {
        
        let executionResult = execution()
        report.checkItems.append(.init(title: title, result: executionResult))
        
    }
    
    public func askReviewer(to taskToDo: String, into report: inout Report) {
        
        report.todos.append(taskToDo)
        
    }
    
    public func report(_ report: Report, using configuration: MarkdownConfiguration = .default) {
        
        let markdownTitle = configuration.titleMarkdownFormatter(report.title)
        if !markdownTitle.isEmpty {
            markdown(markdownTitle)
        }
        
        let markdownMessage = configuration.messageMarkdownFormatter(report.checkItems)
        if !markdownMessage.isEmpty {
            markdown(markdownMessage)
        }
        
        for warning in report.warnings {
            let markdownWarning = configuration.warningMarkdownFormatter(warning)
            warn(markdownWarning)
        }
        
        for failure in report.failures {
            let markdownFailure = configuration.failureMarkdownFormatter(failure)
            fail(markdownFailure)
        }
        
        let markdownTodos = configuration.todosMarkdownFormatter(report.todos)
        if !markdownTodos.isEmpty {
            markdown(markdownTodos)
        }

        if report.warnings.isEmpty && report.failures.isEmpty {
            message(configuration.congratulationsMessage)
        }
        
    }
    
}
