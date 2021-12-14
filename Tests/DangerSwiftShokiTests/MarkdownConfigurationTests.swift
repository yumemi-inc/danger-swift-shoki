//
//  MarkdownConfigurationTests.swift
//  
//
//  Created by 史 翔新 on 2021/12/02.
//

import XCTest
@testable import DangerSwiftShoki

final class MarkdownConfigurationTests: XCTestCase {
    
    func test_defaultConfigurations() {
        
        typealias MC = MarkdownConfiguration
        let mc = MC.default
        
        XCTContext.runActivity(named: "Check Title Markdown") { _ in
            
            let title = "Test Title"
            let expected = "## Test Title"
            XCTAssertEqual(MC.defaultTitleMarkdown(title: title), expected)
            XCTAssertEqual(mc.titleMarkdownFormatter(title), expected)
            
        }
        
        XCTContext.runActivity(named: "Check Message Markdown") { _ in
            
            let emptyCheckItems: [Report.CheckItem] = []
            let expectedEmptyOutput = ""
            XCTAssertEqual(MC.defaultMessageMarkdown(checkItems: emptyCheckItems), expectedEmptyOutput)
            XCTAssertEqual(mc.messageMarkdownFormatter(emptyCheckItems), expectedEmptyOutput)
            
            let singleElementCheckItems: [Report.CheckItem] = [
                .init(title: "Test 1", result: .good)
            ]
            let expectedSingleElementOutput = """
                Checking Item | Result
                | ---| --- |
                Test 1 | :tada:
                """
            XCTAssertEqual(MC.defaultMessageMarkdown(checkItems: singleElementCheckItems), expectedSingleElementOutput)
            XCTAssertEqual(mc.messageMarkdownFormatter(singleElementCheckItems), expectedSingleElementOutput)
            
            let multipleElementCheckItems: [Report.CheckItem] = [
                .init(title: "Test 2", result: .acceptable(warningMessage: nil)),
                .init(title: "Test 3", result: .rejected(failureMessage: "NG"))
            ]
            let expectedMultipleElementOutput = """
                Checking Item | Result
                | ---| --- |
                Test 2 | :thinking:
                Test 3 | :no_good:
                """
            XCTAssertEqual(MC.defaultMessageMarkdown(checkItems: multipleElementCheckItems), expectedMultipleElementOutput)
            XCTAssertEqual(mc.messageMarkdownFormatter(multipleElementCheckItems), expectedMultipleElementOutput)
            
        }
        
        XCTContext.runActivity(named: "Check Warning Markdown") { _ in
            
            let warningTitle = "Warning Title"
            let nonNilMessage = "Needs Further Check"
            let expectedNilMessageOutput = "Warning Title has a warning."
            let expectedNonNilMessageOutput = "Warning Title: Needs Further Check"
            XCTAssertEqual(MC.defaultWarningMarkdown(warning: (warningTitle, nil)), expectedNilMessageOutput)
            XCTAssertEqual(mc.warningMarkdownFormatter((warningTitle, nil)), expectedNilMessageOutput)
            XCTAssertEqual(MC.defaultWarningMarkdown(warning: (warningTitle, nonNilMessage)), expectedNonNilMessageOutput)
            XCTAssertEqual(mc.warningMarkdownFormatter((warningTitle, nonNilMessage)), expectedNonNilMessageOutput)
            
        }
        
        XCTContext.runActivity(named: "Check Failure Markdown") { _ in
            
            let failureTitle = "Failure Title"
            let nonNilMessage = "NO GOOD"
            let expectedNilMessageOutput = "Failure Title failed."
            let expectedNonNilMessageOutput = "Failure Title: NO GOOD"
            XCTAssertEqual(MC.defaultFailureMarkdown(failure: (failureTitle, nil)), expectedNilMessageOutput)
            XCTAssertEqual(mc.failureMarkdownFormatter((failureTitle, nil)), expectedNilMessageOutput)
            XCTAssertEqual(MC.defaultFailureMarkdown(failure: (failureTitle, nonNilMessage)), expectedNonNilMessageOutput)
            XCTAssertEqual(mc.failureMarkdownFormatter((failureTitle, nonNilMessage)), expectedNonNilMessageOutput)
            
        }
        
        XCTContext.runActivity(named: "Check Todo Markdown") { _ in
            
            let emptyTodos: [String] = []
            let expectedEmptyOutput = ""
            XCTAssertEqual(MC.defaultTodosMarkdown(todos: emptyTodos), expectedEmptyOutput)
            XCTAssertEqual(mc.todosMarkdownFormatter(emptyTodos), expectedEmptyOutput)
            
            let singleElementTodos = ["Todo 1"]
            let expectedSingleElementOutput = """
                - [ ] Todo 1
                """
            XCTAssertEqual(MC.defaultTodosMarkdown(todos: singleElementTodos), expectedSingleElementOutput)
            XCTAssertEqual(mc.todosMarkdownFormatter(singleElementTodos), expectedSingleElementOutput)
            
            let multipleElementTodos = ["Todo 1", "Todo 2"]
            let expectedMultipleElementOutput = """
                - [ ] Todo 1
                - [ ] Todo 2
                """
            XCTAssertEqual(MC.defaultTodosMarkdown(todos: multipleElementTodos), expectedMultipleElementOutput)
            XCTAssertEqual(mc.todosMarkdownFormatter(multipleElementTodos), expectedMultipleElementOutput)
            
        }
        
        XCTContext.runActivity(named: "Check Congratulations Message") { _ in
            
            let expected = "Good Job :white_flower:"
            XCTAssertEqual(MC.defaultCongratulationsMessage, expected)
            XCTAssertEqual(mc.congratulationsMessage, expected)
            
        }
        
    }
    
}
