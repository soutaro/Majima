//import Foundation
//import Quick
//@testable import Majima
//
//class ScalarMergeTests: QuickSpec {
//    override func spec() {
//        let merge = ThreeWayMerge(objectIdentifierKey: "id")
//        
//        it("merges if not changed") {
//            let result = merge.merge(base: true, mine: true, your: true)
//            XCTAssertEqual(result, MergeResult.Merged(true))
//        }
//        
//        it("merges to mine") {
//            let result = merge.merge(base: true, mine: false, your: true)
//            XCTAssertEqual(result, MergeResult.Merged(false))
//        }
//        
//        it("merges to your") {
//            let result = merge.merge(base: true, mine: true, your: false)
//            XCTAssertEqual(result, MergeResult.Merged(false))
//        }
//        
//        it("conflicts") {
//            let result = merge.merge(base: "Hello", mine: 33, your: true)
//            XCTAssertEqual(result, MergeResult.Conflicted([Conflict(path: [], base: "Hello", mine: 33, your: true)]))
//        }
//    }
//}
