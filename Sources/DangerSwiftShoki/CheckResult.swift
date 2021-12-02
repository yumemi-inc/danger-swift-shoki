//
//  CheckResult.swift
//  
//
//  Created by 史 翔新 on 2020/07/11.
//

public struct CheckResult {
    
    public enum Result: Equatable {
        case good
        case acceptable(warningMessage: String?)
        case rejected(failureMessage: String?)
    }
    
    public typealias CheckItem = (title: String, result: Result)
    public typealias WarningMessage = (title: String, message: String?)
    public typealias FailureMessage = (title: String, message: String?)
    
    public let title: String
    
    internal(set) public var checkItems: [CheckItem] = []
    
    internal(set) public var todos: [String] = []
    
    public var warnings: AnyCollection<WarningMessage> {
        
        checkItems.lazy.compactMap { (title, result) in
            switch result {
            case .acceptable(warningMessage: let warning):
                return (title, warning)
                
            case .good, .rejected:
                return nil
            }
        }
        .eraseToAnyCollection()
        
    }
    
    public var failures: AnyCollection<FailureMessage> {
        
        checkItems.compactMap { (title, result) in
            switch result {
            case .rejected(failureMessage: let failure):
                return (title, failure)
                
            case .good, .acceptable:
                return nil
            }
        }
        .eraseToAnyCollection()
        
    }
    
    @available(*, deprecated, renamed: "warnings.count")
    public var warningsCount: Int {
        warnings.count
    }
    
    @available(*, deprecated, renamed: "failures.count")
    public var errorsCount: Int {
        failures.count
    }
    
    init(title: String) {
        self.title = title
    }
    
    @available(*, deprecated, message: "It's `Shoki`'s responsibility to format a message, not `CheckResult`'s, so stop using this property to get the formatted title, which you shouldn't have to care at first place.")
    public var markdownTitle: String {
        
        "## " + title
        
    }
    
    @available(*, deprecated, message: "It's `Shoki`'s responsibility to format a message, not `CheckResult`'s, so stop using this property to get the formatted message, which you shouldn't have to care at first place.")
    public var markdownMessage: String {
        
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
    
    @available(*, deprecated, message: "It's `Shoki`'s responsibility to format a message, not `CheckResult`'s, so stop using this property to get the formatted todos, which you shouldn't have to care at first place.")
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

private extension CheckResult.Result {
    
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

private extension Collection {
    
    func eraseToAnyCollection() -> AnyCollection<Element> {
        .init(self)
    }
    
}
