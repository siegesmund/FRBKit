import XCTest
import CombineExpectations
@testable import FRBKit

final class fredTests: XCTestCase {
    func testExample() throws {
        
        let publisher = Fred.series(seriesId: "DEXUSEU")
        
        let recorder = publisher.record()
        let elements = try wait(for: recorder.elements, timeout: 60, description: "SP500 Publisher")
        
        print(elements)
        
        // print(updates.count)
    }
    
    static var allTests = [
        ("testExample", testExample),
    ]
}
