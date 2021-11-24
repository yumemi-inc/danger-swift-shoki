//
//  CheckResult.swift
//  
//
//  Created by 史 翔新 on 2020/07/11.
//

public struct CheckResult {
    
    public enum Result {
        
        case good
        case acceptable
        case rejected
        
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
    
    typealias Message = (content: String, result: Result)
    
    public let title: String
    
    private var messages: [Message] = []
    
    private var todos: [String] = []
    
    public var warningsCount: Int {
        messages.filter({ $0.result == .acceptable }).count
    }
    
    public var errorsCount: Int {
        messages.filter({ $0.result == .rejected }).count
    }
    
    public init(title: String) {
        self.title = title
    }
    
    public mutating func askReviewer(to taskToDo: String) {
        
        todos.append(taskToDo)
        
    }
    
    public mutating func check(_ item: String, execution: () -> Result) {
        
        let result = execution()
        messages.append((item, result))
        
    }
    
    public var markdownTitle: String {
        
        "## " + title
        
    }
    
    public var markdownMessage: String {
        
        guard !messages.isEmpty else {
            return ""
        }
        
        let chartHeader = """
            Checking Item | Result
            | ---| --- |
            
            """
        let chartContent = messages.map {
            "\($0.content) | \($0.result.markdownSymbol)"
        } .joined(separator: "\n")
        
        return chartHeader + chartContent
        
    }
    
    public var markdownTodos: String {
        
        guard !todos.isEmpty else {
            return ""
        }
        
        let todoContent = todos.map {
            "- [ ] \($0)"
        }
        
        return todoContent.joined(separator: "\n")
        
    }
    
}
