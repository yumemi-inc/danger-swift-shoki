import XCTest
@testable import DangerSwiftShoki

final class CheckResultTests: XCTestCase {
    
    func test_checkResultLife() {
        
        var checkResult = CheckResult(title: "Test Check")
        
        XCTContext.runActivity(named: "Initialize CheckResult") { _ in
            XCTAssertEqual(checkResult.title, "Test Check")
            XCTAssertEqual(checkResult.checkItems, [])
            XCTAssertEqual(checkResult.todos, [])
            XCTAssertEqual(checkResult.warnings, [])
            XCTAssertEqual(checkResult.failures, [])
        }
        
        XCTContext.runActivity(named: "Add Check Item with Good Result") { _ in
            checkResult.checkItems.append(("Good Check", .good))
            XCTAssertEqual(checkResult.title, "Test Check")
            XCTAssertEqual(checkResult.checkItems, [("Good Check", .good)])
            XCTAssertEqual(checkResult.todos, [])
            XCTAssertEqual(checkResult.warnings, [])
            XCTAssertEqual(checkResult.failures, [])
        }
        
        XCTContext.runActivity(named: "Add Check Item with Acceptable Result") { _ in
            checkResult.checkItems.append(("Acceptable Check", .acceptable(warningMessage: "Warning")))
            XCTAssertEqual(checkResult.title, "Test Check")
            XCTAssertEqual(checkResult.checkItems, [("Good Check", .good),
                                                    ("Acceptable Check", .acceptable(warningMessage: "Warning"))])
            XCTAssertEqual(checkResult.todos, [])
            XCTAssertEqual(checkResult.warnings, [("Acceptable Check", "Warning")])
            XCTAssertEqual(checkResult.failures, [])
        }
        
        XCTContext.runActivity(named: "Add Check Item with Rejected Result") { _ in
            checkResult.checkItems.append(("Rejected Check", .rejected(failureMessage: "Failure")))
            XCTAssertEqual(checkResult.title, "Test Check")
            XCTAssertEqual(checkResult.checkItems, [("Good Check", .good),
                                                    ("Acceptable Check", .acceptable(warningMessage: "Warning")),
                                                    ("Rejected Check", .rejected(failureMessage: "Failure"))])
            XCTAssertEqual(checkResult.todos, [])
            XCTAssertEqual(checkResult.warnings, [("Acceptable Check", "Warning")])
            XCTAssertEqual(checkResult.failures, [("Rejected Check", "Failure")])
        }
        
        XCTContext.runActivity(named: "Add A Todo Item") { _ in
            checkResult.todos.append("Do Something")
            XCTAssertEqual(checkResult.title, "Test Check")
            XCTAssertEqual(checkResult.checkItems, [("Good Check", .good),
                                                    ("Acceptable Check", .acceptable(warningMessage: "Warning")),
                                                    ("Rejected Check", .rejected(failureMessage: "Failure"))])
            XCTAssertEqual(checkResult.todos, ["Do Something"])
            XCTAssertEqual(checkResult.warnings, [("Acceptable Check", "Warning")])
            XCTAssertEqual(checkResult.failures, [("Rejected Check", "Failure")])
        }
        
        XCTContext.runActivity(named: "Add Another Todo Item") { _ in
            checkResult.todos.append("Do Another Thing")
            XCTAssertEqual(checkResult.title, "Test Check")
            XCTAssertEqual(checkResult.checkItems, [("Good Check", .good),
                                                    ("Acceptable Check", .acceptable(warningMessage: "Warning")),
                                                    ("Rejected Check", .rejected(failureMessage: "Failure"))])
            XCTAssertEqual(checkResult.todos, ["Do Something",
                                               "Do Another Thing"])
            XCTAssertEqual(checkResult.warnings, [("Acceptable Check", "Warning")])
            XCTAssertEqual(checkResult.failures, [("Rejected Check", "Failure")])
        }
        
    }
    
}

private func XCTAssertEqual(_ itemA: [CheckResult.CheckItem], _ itemB: [CheckResult.CheckItem], line: UInt = #line) {
    
    XCTAssertEqual(itemA.count, itemB.count, line: line)
    
    for itemTuple in zip(itemA, itemB) {
        XCTAssertEqual(itemTuple.0.title, itemTuple.1.title, line: line)
        XCTAssertEqual(itemTuple.0.result, itemTuple.1.result, line: line)
    }
    
}

private func XCTAssertEqual(_ itemA: AnyCollection<CheckResult.WarningMessage>, _ itemB: [CheckResult.WarningMessage], line: UInt = #line) {
    
    XCTAssertEqual(itemA.count, itemB.count, line: line)
    
    for itemTuple in zip(itemA, itemB) {
        XCTAssertEqual(itemTuple.0.title, itemTuple.1.title, line: line)
        XCTAssertEqual(itemTuple.0.message, itemTuple.1.message, line: line)
    }
    
}
