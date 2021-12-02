//
//  MarkdownConfiguration.swift
//  
//
//  Created by 史 翔新 on 2021/12/02.
//

public struct MarkdownConfiguration {
    
    var titleMarkdownFormatter: (String) -> String
    var messageMarkdownFormatter: ([Report.CheckItem]) -> String
    var warningMarkdownFormatter: (Report.WarningMessage) -> String
    var failureMarkdownFormatter: (Report.FailureMessage) -> String
    var todosMarkdownFormatter: ([String]) -> String
    var congratulationsMessage: String
    
    public static func defaultTitleMarkdown(title: String) -> String {
        
        "## " + title
        
    }
    
    public static func defaultMessageMarkdown(checkItems: [Report.CheckItem]) -> String {
        
        guard !checkItems.isEmpty else {
            return ""
        }
        
        let chartHeader = """
            Checking Item | Result
            | ---| --- |
            
            """
        let chartContent = checkItems.map {
            "\($0.title) | \($0.result.markdownSymbol)"
        } .joined(separator: "\n")
        
        return chartHeader + chartContent
        
    }
    
    public static func defaultWarningMarkdown(warning: Report.WarningMessage) -> String {
        
        let messageSuffix = warning.message.map { ": \($0)" } ?? " has a warning."
        return warning.title + messageSuffix
        
    }
    
    public static func defaultFailureMarkdown(failure: Report.FailureMessage) -> String {
        
        let messageSuffix = failure.message.map { ": \($0)" } ?? " failed."
        return failure.title + messageSuffix
        
    }
    
    public static func defaultTodosMarkdown(todos: [String]) -> String {
        
        guard !todos.isEmpty else {
            return ""
        }
        
        let todoContent = todos.map {
            "- [ ] \($0)"
        }
        
        return todoContent.joined(separator: "\n")
        
    }
    
    public static var defaultCongratulationsMessage: String {
        
        "Good Job :white_flower:"
        
    }
    
    public init(
        titleMarkdownFormatter: @escaping (String) -> String = defaultTitleMarkdown(title:),
        messageMarkdownFormatter: @escaping ([Report.CheckItem]) -> String = defaultMessageMarkdown(checkItems:),
        warningMarkdownFormatter: @escaping (Report.WarningMessage) -> String = defaultWarningMarkdown(warning:),
        failureMarkdownFormatter: @escaping (Report.FailureMessage) -> String = defaultFailureMarkdown(failure:),
        todosMarkdownFormatter: @escaping ([String]) -> String = defaultTodosMarkdown(todos:),
        congratulationsMessage: String = defaultCongratulationsMessage
    ) {
        self.titleMarkdownFormatter = titleMarkdownFormatter
        self.messageMarkdownFormatter = messageMarkdownFormatter
        self.warningMarkdownFormatter = warningMarkdownFormatter
        self.failureMarkdownFormatter = failureMarkdownFormatter
        self.todosMarkdownFormatter = todosMarkdownFormatter
        self.congratulationsMessage = congratulationsMessage
    }
    
    public static var `default`: MarkdownConfiguration {
        .init()
    }
    
}

private extension Report.CheckItem.Result {
    
    var markdownSymbol: String {
        switch self {
        case .good:
            return ":tada:"
            
        case .acceptable:
            return ":thinking:"
            
        case .rejected:
            return ":no_good:"
        }
    }
    
}
