import Foundation

public enum ArrayDiff: Equatable {
    case Insertion(Int, Int)
    case Deletion(Int)
}

public func ==(d: ArrayDiff, e: ArrayDiff) -> Bool {
    switch (d, e) {
    case (.Insertion(let p1, let r1), .Insertion(let p2, let r2)):
        return p1 == p2 && r1 == r2
    case (.Deletion(let r1), .Deletion(let r2)):
        return r1 == r2
    default:
        return false
    }
}

class Graph<T> {
    let original: [T]
    let new: [T]
    let comparator: (T, T) -> Bool
    
    init(original: [T], new: [T], comparator: (T, T) -> Bool) {
        self.original = original
        self.new = new
        self.comparator = comparator
    }
    
    /**
     Returns None if there is no edge from from to to.
     
     - (x:0, y:0) means origin
     - 0 <= x <= original.count should hold
     - 0 <= y <= new.count should hold
     */
    func cost(from from: (x: Int, y: Int), to: (x: Int, y: Int)) -> UInt? {
        guard 0 <= from.x && to.x <= self.original.count && 0 <= from.y && to.y <= self.new.count else {
            return .None
        }
        
        guard to.x == from.x + 1 || to.y == from.y + 1 else {
            return .None
        }
        
        if to.x == from.x + 1 && to.y == from.y + 1 {
            if self.comparator(self.original[to.x - 1], self.new[to.y - 1]) {
                return 0
            } else {
                return .None
            }
        } else {
            return 1
        }
    }
    
    func enumeratePath(path: [ArrayDiff], start: (x: Int, y: Int), inout candidates: [[ArrayDiff]]) {
        if start.x == self.original.count && start.y == self.new.count {
            candidates.append(path)
        } else {
            if let _ = self.cost(from: start, to: (x: start.x + 1, y: start.y)) {
                self.enumeratePath(path + [.Deletion(start.x)], start: (x: start.x + 1, y: start.y), candidates: &candidates)
            }
            if let _ = self.cost(from: start, to: (x: start.x + 1, y: start.y + 1)) {
                self.enumeratePath(path, start: (x: start.x + 1, y: start.y + 1), candidates: &candidates)
            }
            if let _ = self.cost(from: start, to: (x: start.x, y: start.y + 1)) {
                self.enumeratePath(path + [.Insertion(start.x, start.y)], start: (x: start.x, y: start.y + 1), candidates: &candidates)
            }
        }
    }
}

public class Diff {
    public func diff<T: Equatable>(original: [T], new: [T]) -> [ArrayDiff] {
        return self.diff(original, new: new, comparator: ==)
    }
    
    public func diff<T>(original: [T], new: [T], comparator: (T, T) -> Bool) -> [ArrayDiff] {
        var paths: [[ArrayDiff]] = []
        
        let graph = Graph<T>(original: original, new: new, comparator: comparator)
        graph.enumeratePath([], start: (x: 0, y: 0), candidates: &paths)
        
        return paths.minElement { $0.count < $1.count }!
    }
}