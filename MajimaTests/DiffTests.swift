import Foundation
import Quick
@testable import Majima

struct DiffExample<T> {
    let original: [T]
    let new: [T]
    let diff: [ArrayDiff]
    let file: String
    let line: UInt
}

func diffExample<T: Equatable>(original original: [T], new: [T], diff: [ArrayDiff], file: String = __FILE__, line: UInt = __LINE__) -> DiffExample<T> {
    return DiffExample<T>(original: original, new: new, diff: diff, file: file, line: line)
}

class DiffTest: QuickSpec {
    override func spec() {
        describe("Graph") {
            let graph = Graph(original: [0,1,2], new: [0,2,5], comparator: ==)
            
            it("calculates cost") {
                XCTAssertEqual(0, graph.cost(from: (x: 0, y: 0), to: (x: 1, y: 1)))
                XCTAssertEqual(1, graph.cost(from: (x: 0, y: 0), to: (x: 0, y: 1)))
                XCTAssertEqual(0, graph.cost(from: (x: 2, y: 1), to: (x: 3, y: 2)))
                XCTAssertNil(graph.cost(from: (x: 1, y: 1), to: (x: 2, y: 2)))
            }
        }
        
        describe("Diff") {
            let examples = [
                diffExample(original: [1,2,3], new: [1,2,3], diff: []),
                diffExample(original: [1,2,3], new: [1,2], diff: [.Deletion(2)]),
                diffExample(original: [1,2,3], new: [1,2,3,4], diff: [.Insertion(3, 3)]),
                diffExample(original: [1,2], new: [0,2], diff: [.Deletion(0), .Insertion(1, 0)]),
                diffExample(original: [1,2,3], new: [2,1,3], diff: [.Deletion(0), .Insertion(2, 1)]),
                diffExample(original: [1,2,3], new: [2,3,4,5], diff: [.Deletion(0), .Insertion(3, 2), .Insertion(3, 3)])
            ]
            
            it("calculates diff") {
                let diff = Diff()
                
                examples.forEach { example in
                    let d = diff.diff(example.original, new: example.new)
                    XCTAssertEqual(d, example.diff, file: example.file, line: example.line)
                }
            }
        }
    }
}