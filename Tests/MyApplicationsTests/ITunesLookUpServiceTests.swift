import XCTest
@testable import MyApplications

final class ITunesLookUpServiceTests: XCTestCase {

    func testITunesLookUpService() async throws {
        
        let service = ITunesLookUpService()
        
        let responseResult = await service.request(id: "976495345")
        responseResult?.results.forEach({ result in
            print(result)
        })
        
        XCTAssertNotNil(responseResult?.results, "responseResult is nil")
    }
}
