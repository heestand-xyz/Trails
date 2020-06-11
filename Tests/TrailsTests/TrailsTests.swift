import XCTest
@testable import Trails

final class TrailsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Trails().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
