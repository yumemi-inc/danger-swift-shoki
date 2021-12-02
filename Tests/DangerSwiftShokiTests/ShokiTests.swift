//
//  ShokiTests.swift
//  
//
//  Created by 史 翔新 on 2021/11/16.
//

import XCTest
@testable import DangerSwiftShoki

final class ShokiTests: XCTestCase {
    
    private typealias ExpectedString = (line: UInt, input: String, expectation: XCTestExpectation)
    private func makeExecutor(_ expectations: [ExpectedString]) -> (String) -> Void {
        var expectations = expectations
        return {
            guard let currentExpectation = expectations.first else {
                XCTFail("Calling resolver more times than expected from: \($0).")
                return
            }
            switch $0 {
            case currentExpectation.input:
                currentExpectation.expectation.fulfill()
                
            case let invalid:
                XCTFail(#"Invalid message. Expected: "\#(currentExpectation.input)"; Received: "\#(invalid)."#, line: currentExpectation.line)
            }
            expectations.removeFirst()
        }
    }
    
    func test_report() {
        
        XCTContext.runActivity(named: "Good CheckResult") { _ in
            
            let inputReport = { () -> Report in
                var result = Report(title: "Good Result")
                result.checkItems.append(("Good Check", .good))
                result.todos.append("Good Todo")
                return result
            }()
            
            let titleExpectation = expectation(description: "Title")
            let messageExpectation = expectation(description: "Message")
            let todosExpectation = expectation(description: "Todos")
            let rewardExpectation = expectation(description: "Reward")
            
            let expectedTitle = "## Good Result"
            let expectedMessage = """
                Checking Item | Result
                | ---| --- |
                Good Check | :tada:
                """
            let expectedTodos = "- [ ] Good Todo"
            let expectedReward = "Good Job :white_flower:"
            
            let markdownExecutor = makeExecutor([
                (#line, expectedTitle, titleExpectation),
                (#line, expectedMessage, messageExpectation),
                (#line, expectedTodos, todosExpectation),
            ])
            let messageExecutor = makeExecutor([
                (#line, expectedReward, rewardExpectation)
            ])
            let shoki = Shoki(
                markdownExecutor: markdownExecutor,
                messageExecutor: messageExecutor,
                warningExecutor: { _ in XCTFail() },
                failureExecutor: { _ in XCTFail() }
            )
            
            shoki.report(inputReport)
            wait(for: [titleExpectation, messageExpectation, todosExpectation, rewardExpectation], timeout: 0, enforceOrder: true)
            
        }
        
        XCTContext.runActivity(named: "Empty CheckResult") { _ in
            
            let inputReport = Report(title: "Empty Result")
            
            let titleExpectation = expectation(description: "Title")
            let rewardExpectation = expectation(description: "Reward")
            
            let expectedTitle = "## Empty Result"
            let expectedReward = "Good Job :white_flower:"
            
            let markdownExecutor = makeExecutor([
                (#line, expectedTitle, titleExpectation),
            ])
            let messageExecutor = makeExecutor([
                (#line, expectedReward, rewardExpectation),
            ])
            let shoki = Shoki(
                markdownExecutor: markdownExecutor,
                messageExecutor: messageExecutor,
                warningExecutor: { _ in XCTFail() },
                failureExecutor: { _ in XCTFail() }
            )
            
            shoki.report(inputReport)
            wait(for: [titleExpectation, rewardExpectation], timeout: 0, enforceOrder: true)
            
        }
        
        XCTContext.runActivity(named: "Rejected Result") { _ in
            
            let inputReport = { () -> Report in
                var result = Report(title: "Rejected Result")
                result.checkItems.append(("Rejected Check", .rejected(failureMessage: nil)))
                return result
            }()
            
            let titleExpectation = expectation(description: "Title")
            let messageExpectation = expectation(description: "Message")
            let failureExpectation = expectation(description: "Failure")
            
            let expectedTitle = "## Rejected Result"
            let expectedMessage = """
            Checking Item | Result
            | ---| --- |
            Rejected Check | :no_good:
            """
            let expectedFailure = "Rejected Check failed."
            
            let markdownExecutor = makeExecutor([
                (#line, expectedTitle, titleExpectation),
                (#line, expectedMessage, messageExpectation),
            ])
            let messageExecutor = makeExecutor([])
            let failureExecutor = makeExecutor([
                (#line, expectedFailure, failureExpectation),
            ])
            let shoki = Shoki(
                markdownExecutor: markdownExecutor,
                messageExecutor: messageExecutor,
                warningExecutor: { _ in XCTFail() },
                failureExecutor: failureExecutor
            )
            
            shoki.report(inputReport)
            wait(for: [titleExpectation, messageExpectation, failureExpectation], timeout: 0, enforceOrder: true)
            
        }
        
    }
    
}
