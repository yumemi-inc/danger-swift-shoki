import XCTest
@testable import DangerSwiftShoki

final class CheckResultTests: XCTestCase {
    
    func test_checkResultLife() {
        
        var checkResult = CheckResult(title: "Test Check")
        
        XCTContext.runActivity(named: "Initialize CheckResult") { _ in
            XCTAssertEqual(checkResult.title, "Test Check")
            XCTAssertEqual(checkResult.warningsCount, 0)
            XCTAssertEqual(checkResult.errorsCount, 0)
            XCTAssertEqual(checkResult.markdownTitle, "## Test Check")
            XCTAssertEqual(checkResult.markdownMessage, """
                                                        """)
            XCTAssertEqual(checkResult.markdownTodos, """
                                                      """)
        }
        
        XCTContext.runActivity(named: "Add Check Item with Good Result") { _ in
            checkResult.check("Good Check", execution: { .good })
            XCTAssertEqual(checkResult.title, "Test Check")
            XCTAssertEqual(checkResult.warningsCount, 0)
            XCTAssertEqual(checkResult.errorsCount, 0)
            XCTAssertEqual(checkResult.markdownTitle, "## Test Check")
            XCTAssertEqual(checkResult.markdownMessage, """
                                                        Checking Item | Result
                                                        | ---| --- |
                                                        Good Check | :tada:
                                                        """)
            XCTAssertEqual(checkResult.markdownTodos, """
                                                      """)
        }
        
        XCTContext.runActivity(named: "Add Check Item with Acceptable Result") { _ in
            checkResult.check("Acceptable Check", execution: { .acceptable })
            XCTAssertEqual(checkResult.title, "Test Check")
            XCTAssertEqual(checkResult.warningsCount, 1)
            XCTAssertEqual(checkResult.errorsCount, 0)
            XCTAssertEqual(checkResult.markdownTitle, "## Test Check")
            XCTAssertEqual(checkResult.markdownMessage, """
                                                        Checking Item | Result
                                                        | ---| --- |
                                                        Good Check | :tada:
                                                        Acceptable Check | :thinking:
                                                        """)
            XCTAssertEqual(checkResult.markdownTodos, """
                                                      """)
        }
        
        XCTContext.runActivity(named: "Add Check Item with Rejected Result") { _ in
            checkResult.check("Rejected Check", execution: { .rejected })
            XCTAssertEqual(checkResult.title, "Test Check")
            XCTAssertEqual(checkResult.warningsCount, 1)
            XCTAssertEqual(checkResult.errorsCount, 1)
            XCTAssertEqual(checkResult.markdownTitle, "## Test Check")
            XCTAssertEqual(checkResult.markdownMessage, """
                                                        Checking Item | Result
                                                        | ---| --- |
                                                        Good Check | :tada:
                                                        Acceptable Check | :thinking:
                                                        Rejected Check | :no_good:
                                                        """)
            XCTAssertEqual(checkResult.markdownTodos, """
                                                      """)
        }
        
        XCTContext.runActivity(named: "Add A Todo Item") { _ in
            checkResult.askReviewer(to: "Do Something")
            XCTAssertEqual(checkResult.title, "Test Check")
            XCTAssertEqual(checkResult.warningsCount, 1)
            XCTAssertEqual(checkResult.errorsCount, 1)
            XCTAssertEqual(checkResult.markdownTitle, "## Test Check")
            XCTAssertEqual(checkResult.markdownMessage, """
                                                        Checking Item | Result
                                                        | ---| --- |
                                                        Good Check | :tada:
                                                        Acceptable Check | :thinking:
                                                        Rejected Check | :no_good:
                                                        """)
            XCTAssertEqual(checkResult.markdownTodos, """
                                                      - [ ] Do Something
                                                      """)
        }
        
        XCTContext.runActivity(named: "Add Another Todo Item") { _ in
            checkResult.askReviewer(to: "Do Another Thing")
            XCTAssertEqual(checkResult.title, "Test Check")
            XCTAssertEqual(checkResult.warningsCount, 1)
            XCTAssertEqual(checkResult.errorsCount, 1)
            XCTAssertEqual(checkResult.markdownTitle, "## Test Check")
            XCTAssertEqual(checkResult.markdownMessage, """
                                                        Checking Item | Result
                                                        | ---| --- |
                                                        Good Check | :tada:
                                                        Acceptable Check | :thinking:
                                                        Rejected Check | :no_good:
                                                        """)
            XCTAssertEqual(checkResult.markdownTodos, """
                                                      - [ ] Do Something
                                                      - [ ] Do Another Thing
                                                      """)
        }
        
    }
    
}
