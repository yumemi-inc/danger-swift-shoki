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
    
    private func makeUnexpectedExecutor(line: UInt = #line) -> (String) -> Void {
        return { _ in XCTFail(line: line) }
    }
    
    private func dummyShoki(line: UInt = #line) -> Shoki {
        .init(
            markdownExecutor: makeUnexpectedExecutor(line: line),
            messageExecutor: makeUnexpectedExecutor(line: line),
            warningExecutor: makeUnexpectedExecutor(line: line),
            failureExecutor: makeUnexpectedExecutor(line: line)
        )
    }
    
    func test_markdown() {
        
        let expectedInput = "My Markdown"
        let executionExpectation = expectation(description: "Markdown")
        let executor = makeExecutor([
            (#line, expectedInput, executionExpectation),
        ])
        let shoki = Shoki(
            markdownExecutor: executor,
            messageExecutor: makeUnexpectedExecutor(),
            warningExecutor: makeUnexpectedExecutor(),
            failureExecutor: makeUnexpectedExecutor()
        )
        
        shoki.markdown(expectedInput)
        wait(for: [executionExpectation], timeout: 0)
        
    }
    
    func test_message() {
        
        let expectedInput = "My Message"
        let executionExpectation = expectation(description: "Message")
        let executor = makeExecutor([
            (#line, expectedInput, executionExpectation),
        ])
        let shoki = Shoki(
            markdownExecutor: makeUnexpectedExecutor(),
            messageExecutor: executor,
            warningExecutor: makeUnexpectedExecutor(),
            failureExecutor: makeUnexpectedExecutor()
        )
        
        shoki.message(expectedInput)
        wait(for: [executionExpectation], timeout: 0)
        
    }
    
    func test_warn() {
        
        let expectedInput = "My Warn"
        let executionExpectation = expectation(description: "Warn")
        let executor = makeExecutor([
            (#line, expectedInput, executionExpectation),
        ])
        let shoki = Shoki(
            markdownExecutor: makeUnexpectedExecutor(),
            messageExecutor: makeUnexpectedExecutor(),
            warningExecutor: executor,
            failureExecutor: makeUnexpectedExecutor()
        )
        
        shoki.warn(expectedInput)
        wait(for: [executionExpectation], timeout: 0)
        
    }
    
    func test_fail() {
        
        let expectedInput = "My Fail"
        let executionExpectation = expectation(description: "Fail")
        let executor = makeExecutor([
            (#line, expectedInput, executionExpectation),
        ])
        let shoki = Shoki(
            markdownExecutor: makeUnexpectedExecutor(),
            messageExecutor: makeUnexpectedExecutor(),
            warningExecutor: makeUnexpectedExecutor(),
            failureExecutor: executor
        )
        
        shoki.fail(expectedInput)
        wait(for: [executionExpectation], timeout: 0)
        
    }
    
    func test_makeInitialReport() {
        
        let shoki = dummyShoki()
        let report = shoki.makeInitialReport(title: "Title")
        let expected = Report(title: "Title")
        XCTAssertEqual(report, expected)
        
    }
    
    func test_check() {
        
        let shoki = dummyShoki()
        var report = Report(title: "Title")
        shoki.check("Check 1", into: &report, execution: { .good })
        shoki.check("Check 2", into: &report, execution: { .acceptable(warningMessage: nil) })
        shoki.check("Check 3", into: &report, execution: { .rejected(failureMessage: nil) })
        let expected: Report = {
            var report = Report(title: "Title")
            report.checkItems = [
                .init(title: "Check 1", result: .good),
                .init(title: "Check 2", result: .acceptable(warningMessage: nil)),
                .init(title: "Check 3", result: .rejected(failureMessage: nil)),
            ]
            return report
        }()
        XCTAssertEqual(report, expected)
        
    }
    
    func test_askReviewer() {
        
        let shoki = dummyShoki()
        var report = Report(title: "Title")
        shoki.askReviewer(to: "TODO 1", into: &report)
        shoki.askReviewer(to: "TODO 2", into: &report)
        let expected: Report = {
            var report = Report(title: "Title")
            report.todos = [
                "TODO 1",
                "TODO 2",
            ]
            return report
        }()
        XCTAssertEqual(report, expected)
        
    }
    
    func test_realWorldUsage() {
        
        XCTContext.runActivity(named: "Good CheckResult") { _ in
            
            let inputReport = { () -> Report in
                var result = Report(title: "Good Result")
                result.checkItems.append(.init(title: "Good Check", result: .good))
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
                warningExecutor: makeUnexpectedExecutor(),
                failureExecutor: makeUnexpectedExecutor()
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
                warningExecutor: makeUnexpectedExecutor(),
                failureExecutor: makeUnexpectedExecutor()
            )
            
            shoki.report(inputReport)
            wait(for: [titleExpectation, rewardExpectation], timeout: 0, enforceOrder: true)
            
        }
        
        XCTContext.runActivity(named: "Rejected Result") { _ in
            
            let inputReport = { () -> Report in
                var result = Report(title: "Rejected Result")
                result.checkItems.append(.init(title: "Rejected Check", result: .rejected(failureMessage: nil)))
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
                warningExecutor: makeUnexpectedExecutor(),
                failureExecutor: failureExecutor
            )
            
            shoki.report(inputReport)
            wait(for: [titleExpectation, messageExpectation, failureExpectation], timeout: 0, enforceOrder: true)
            
        }
        
    }
    
}
