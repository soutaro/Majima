import Foundation
import XCTest
import Quick
@testable import Majima

public func assertMerged<T: Equatable>(result: Result<[T]>, expected: [T], file: String = __FILE__, line: UInt = __LINE__) {
    switch result {
    case .Conflicted(let conflicts):
        XCTAssertFalse(true, "at \(file):\(line)")
    case .Merged(let array):
        XCTAssertEqual(array, expected, file: file, line: line)
    }
}

class ArrayMergeTests: QuickSpec {
    override func spec() {
        describe("hogehoge") {
            it("aaa") {
                let merge = ThreeWayMerge(objectIdentifierKey: "string")
                let result = merge.merge(base: ["a", "b", "c"], mine: ["a", "x", "c"], theirs: ["a", "b", "y"], isEqual: ==)
                
                assertMerged(result, expected: ["a", "x", "y"])
            }
        }
        
        describe("merge diff") {
            
        }
    }
}
