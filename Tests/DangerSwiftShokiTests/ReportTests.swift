import XCTest
@testable import DangerSwiftShoki

final class ReportTests: XCTestCase {
    
    private func dummyReport() -> Report {
        var report = Report(title: "")
        report.checkItems = [
            .init(title: "GOOD", result: .good),
            .init(title: "WARNING 1", result: .acceptable(warningMessage: "Warning Message")),
            .init(title: "WARNING 2", result: .acceptable(warningMessage: nil)),
            .init(title: "FAILURE 1", result: .rejected(failureMessage: "Failure Message")),
            .init(title: "FAILURE 2", result: .rejected(failureMessage: nil)),
        ]
        return report
    }
    
    func test_warnings() {
        
        let inputReport = dummyReport()
        XCTAssertEqual(inputReport.warnings, [("WARNING 1", "Warning Message"), ("WARNING 2", nil)])
        
    }
    
    func test_failures() {
        
        let inputReport = dummyReport()
        XCTAssertEqual(inputReport.failures, [("FAILURE 1", "Failure Message"), ("FAILURE 2", nil)])
        
    }
    
}

private func XCTAssertEqual(_ anyCollection: AnyCollection<Report.WarningMessage>, _ array: Array<Report.WarningMessage>, line: UInt = #line) {
    
    guard anyCollection.count == array.count else {
        return XCTFail(line: line)
    }
    
    for tuple in zip(anyCollection, array) {
        XCTAssertEqual(tuple.0.title, tuple.1.title, line: line)
        XCTAssertEqual(tuple.0.message, tuple.1.message, line: line)
    }
    
}
