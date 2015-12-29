import Foundation
import XCTest
@testable import Majima

func assertMerged<T: Equatable>(result: Result<T>, expected: T, file: String = __FILE__, line: UInt = __LINE__) {
    switch result {
    case .Conflicted:
        XCTAssertFalse(true, "\(result)", file: file, line: line)
    case .Merged(let obj):
        XCTAssertEqual(obj, expected, file: file, line: line)
    }
}

func assertMerged<T: Equatable>(result: Result<[T]>, expected: [T], file: String = __FILE__, line: UInt = __LINE__) {
    switch result {
    case .Conflicted:
        XCTAssertFalse(true, "\(result)", file: file, line: line)
    case .Merged(let obj):
        XCTAssertEqual(obj, expected, file: file, line: line)
    }
}

func assertConflicted<T>(result: Result<T>, file: String = __FILE__, line: UInt = __LINE__) {
    switch result {
    case .Conflicted:
        XCTAssert(true, file: file, line: line)
    case .Merged(let obj):
        XCTAssert(false, "\(obj)", file: file, line: line)
    }
}

func applyPatch<T: Equatable>(base base: [T], patch: [ArrayDiff<T>]) -> [T] {
    var array = base
    
    for diff in patch.reverse() {
        array = ThreeWayMerge.apply(base: array, diff: diff)
    }
    
    return array
}

func assertMerged<T>(result: Result<T>, file: String = __FILE__, line: UInt = __LINE__,  test: (T) -> ()) {
    switch result {
    case .Merged(let x):
        test(x)
    case .Conflicted:
        XCTAssert(false, "Unexpected .Conflicted", file: file, line: line)
    }
}
