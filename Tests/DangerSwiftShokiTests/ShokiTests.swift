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
    private func makeResolver(_ expectations: [ExpectedString]) -> (String) -> Void {
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
                XCTFail("Invalid call from: \(invalid)", line: currentExpectation.line)
            }
            expectations.removeFirst()
        }
    }
    
    func test_report() {
        
        XCTContext.runActivity(named: "Good CheckResult") { _ in
            
            let inputResult = { () -> CheckResult in
                var result = CheckResult(title: "Good Result")
                result.check("Good Check", execution: { .good })
                result.askReviewer(to: "Good Todo")
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
            
            let markdownResolver = makeResolver([
                (#line, expectedTitle, titleExpectation),
                (#line, expectedMessage, messageExpectation),
                (#line, expectedTodos, todosExpectation),
            ])
            let messageResolver = makeResolver([
                (#line, expectedReward, rewardExpectation)
            ])
            let shoki = Shoki(markdownResolver: markdownResolver, messageResolver: messageResolver)
            
            shoki.report(inputResult)
            wait(for: [titleExpectation, messageExpectation, todosExpectation, rewardExpectation], timeout: 0, enforceOrder: true)
            
        }
        
        XCTContext.runActivity(named: "Empty CheckResult") { _ in
            
            let inputResult = CheckResult(title: "Empty Result")
            
            let titleExpectation = expectation(description: "Title")
            let rewardExpectation = expectation(description: "Reward")
            
            let expectedTitle = "## Empty Result"
            let expectedReward = "Good Job :white_flower:"
            
            let markdownResolver = makeResolver([
                (#line, expectedTitle, titleExpectation),
            ])
            let messageResolver = makeResolver([
                (#line, expectedReward, rewardExpectation),
            ])
            let shoki = Shoki(markdownResolver: markdownResolver, messageResolver: messageResolver)
            
            shoki.report(inputResult)
            wait(for: [titleExpectation, rewardExpectation], timeout: 0, enforceOrder: true)
            
        }
        
        XCTContext.runActivity(named: "Rejected Result") { _ in
            
            let inputResult = { () -> CheckResult in
                var result = CheckResult(title: "Rejected Result")
                result.check("Rejected Check", execution: { .rejected })
                return result
            }()
            
            let titleExpectation = expectation(description: "Title")
            let messageExpectation = expectation(description: "Message")
            
            let expectedTitle = "## Rejected Result"
            let expectedMessage = """
            Checking Item | Result
            | ---| --- |
            Rejected Check | :no_good:
            """
            
            let markdownResolver = makeResolver([
                (#line, expectedTitle, titleExpectation),
                (#line, expectedMessage, messageExpectation),
            ])
            let messageResolver = makeResolver([])
            let shoki = Shoki(markdownResolver: markdownResolver, messageResolver: messageResolver)
            
            shoki.report(inputResult)
            wait(for: [titleExpectation, messageExpectation], timeout: 0, enforceOrder: true)
            
        }
        
    }
    
}
