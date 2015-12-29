import Foundation

enum ArrayDiff<T: Equatable>: Equatable {
    case Insertion(Int, T)
    case Deletion(Int)
    
    var position: Double {
        switch self {
        case .Deletion(let i):
            return Double(i)
        case .Insertion(let j, _):
            return Double(j) - 0.5
        }
    }
}

func ==<T: Equatable>(d: ArrayDiff<T>, e: ArrayDiff<T>) -> Bool {
    switch (d, e) {
    case (.Insertion(let p1, let r1), .Insertion(let p2, let r2)):
        return p1 == p2 && r1 == r2
    case (.Deletion(let r1), .Deletion(let r2)):
        return r1 == r2
    default:
        return false
    }
}

class Graph<T: Equatable> {
    let original: [T]
    let new: [T]
    
    init(original: [T], new: [T]) {
        self.original = original
        self.new = new
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
            if self.original[to.x - 1] == self.new[to.y - 1] {
                return 0
            } else {
                return .None
            }
        } else {
            return 1
        }
    }
    
    func enumeratePath(path: [ArrayDiff<T>], start: (x: Int, y: Int), inout candidates: [[ArrayDiff<T>]]) {
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
                self.enumeratePath(path + [.Insertion(start.x, self.new[start.y])], start: (x: start.x, y: start.y + 1), candidates: &candidates)
            }
        }
    }
}

class Diff {
    func diff<T: Equatable>(original: [T], new: [T]) -> [ArrayDiff<T>] {
        var paths: [[ArrayDiff<T>]] = []
        
        let graph = Graph<T>(original: original, new: new)
        graph.enumeratePath([], start: (x: 0, y: 0), candidates: &paths)
        
        return paths.minElement { $0.count < $1.count }!
    }
}

extension ThreeWayMerge {
    static func apply<T: Equatable>(base base: [T], diff: ArrayDiff<T>) -> [T] {
        var array = base
        
        switch diff {
        case .Deletion(let i):
            array.removeAtIndex(i)
        case .Insertion(let i, let x):
            array.insert(x, atIndex: i)
        }
        
        return array
    }
    
    static public func merge<T: Equatable>(base base: [T], mine: [T], theirs: [T]) -> Result<[T]> {
        let diff = Diff()
        
        var myDiff: [ArrayDiff<T>] = diff.diff(base, new: mine).reverse()
        var theirDiff: [ArrayDiff<T>] = diff.diff(base, new: theirs).reverse()
        
        var result: [T] = base
        
        repeat {
            switch (myDiff.first, theirDiff.first) {
            case (.Some(let d), .Some(let e)) where d.position < e.position:
                result = self.apply(base: result, diff: e)
                theirDiff.removeFirst()
            case (.Some(let d), .Some(let e)) where d.position > e.position:
                result = self.apply(base: result, diff: d)
                myDiff.removeFirst()
            case (.Some(let d), .Some(let e)) where d == e:
                result = self.apply(base: result, diff: d)
                myDiff.removeFirst()
                theirDiff.removeFirst()
            case (.Some(let d), .None):
                result = self.apply(base: result, diff: d)
                myDiff.removeFirst()
            case (.None, .Some(let d)):
                result = self.apply(base: result, diff: d)
                theirDiff.removeFirst()
            default:
                return .Conflicted
            }
        } while myDiff.count > 0 || theirDiff.count > 0
        
        return .Merged(result)
    }
}