import XCTest
import Combine
@testable import Trails

final class TrailerLifetimeTests: XCTestCase {
    @MainActor
    func testDroppingTrailerReleasesItAndInvalidatesTimer() {
        var trailer: Trailer? = Trailer(duration: 1)
        weak var weakTrailer = trailer
        #if !(os(iOS) || os(visionOS) || os(tvOS))
        let timer = trailer!.timerLink!
        XCTAssertTrue(timer.isValid)
        #endif
        trailer = nil
        XCTAssertNil(weakTrailer)
        #if !(os(iOS) || os(visionOS) || os(tvOS))
        XCTAssertFalse(timer.isValid)
        #endif
    }

    @MainActor
    func testOwnedTrailerStillExpiresValues() async {
        let trailer = Trailer(duration: 0.01)
        trailer.addFirst(42)
        let expired = expectation(description: "Frame loop expires old values")
        let subscription = trailer.$allTimeValues.dropFirst().sink { values in
            if values.allSatisfy({ $0.isEmpty }) { expired.fulfill() }
        }
        await fulfillment(of: [expired], timeout: 2)
        withExtendedLifetime(subscription) {}
        XCTAssertEqual(trailer.totalValueCount, 0)
    }
}
