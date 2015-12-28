import Foundation

public typealias Conflict = (mine: ArrayDiff, theirs: ArrayDiff)

public enum Result<T> {
    case Merged(T)
    case Conflicted([Conflict])
}

public class ThreeWayMerge {
    let objectIdentifierKey: String
    
    public init(objectIdentifierKey: String) {
        self.objectIdentifierKey = objectIdentifierKey
    }
    
    public func merge<T>(base base: [T], mine: [T], theirs: [T], isEqual: (T, T) -> Bool) -> Result<[T]> {
        let diff = Diff()
        
        let myDiff = diff.diff(base, new: mine, comparator: isEqual)
        let theirDiff = diff.diff(base, new: theirs, comparator: isEqual)
        
        print(myDiff)
        print(theirDiff)
        
        var conflicts: [Conflict] = []
        
        for diff1 in myDiff {
            for diff2 in theirDiff {
                if self.doesConflict(mine: mine, theirs: theirs, myDiff: diff1, theirDiff: diff2, isEqual: isEqual) {
                    conflicts.append((mine: diff1, theirs: diff2))
                }
            }
        }
        
        if conflicts.isEmpty {
            return .Merged([])
        } else {
            return .Conflicted(conflicts)
        }
    }
    
    func merge<T>(mine mine: [T], theirs: [T], myDiff: [ArrayDiff], theirDiff: ArrayDiff, isEqual: (T, T) -> Bool) -> Result<[ArrayDiff]> {
        return .Merged([])
    }
    
    func doesConflict<T>(mine mine: [T], theirs: [T], myDiff: ArrayDiff, theirDiff: ArrayDiff, isEqual: (T, T) -> Bool) -> Bool {
        return false
    }
    
//    public func merge(base base: AnyObject, mine: AnyObject, your: AnyObject) -> MergeResult {
//        return merge([], base: base, mine: mine, your: your)
//    }
//    
//    func merge(path: Path, base: AnyObject?, mine: AnyObject, your: AnyObject) -> MergeResult {
//        if (mine.isEqual(your)) {
//            return .Merged(mine)
//        }
//        
//        if (base == mine && !(base == your)) {
//            return .Merged(your)
//        }
//        
//        if (!(base == mine) && base == your) {
//            return .Merged(mine)
//        }
//        
//        if (base is JSONObject && mine is JSONObject && your is JSONObject) {
//            return mergeObject(path, base: base as! JSONObject, mine: mine as! JSONObject, your: your as! JSONObject)
//        }
//        
//        return .Conflicted([Conflict(path: path, base: base, mine: mine, your: your)])
//    }
//    
//    func mergeObject(path: Path, base: JSONObject, mine: JSONObject, your: JSONObject) -> MergeResult {
//        guard base[self.objectIdentifierKey]! == mine[self.objectIdentifierKey]! && base[self.objectIdentifierKey]! == your[self.objectIdentifierKey]! else {
//            return .Conflicted([Conflict(path: path, base: base, mine: mine, your: your)])
//        }
//        
//        var all_keys: Set<String> = Set()
//        all_keys = all_keys.union(base.keys)
//        all_keys = all_keys.union(mine.keys)
//        all_keys = all_keys.union(your.keys)
//        all_keys.remove("id")
//        
//        var conflicts: [Conflict] = []
//        var object: JSONObject = ["id": base["id"]!]
//        
//        for key in all_keys {
//            let path = path + [.ObjectProperty(key)]
//            let b = base[key]
//            let m = mine[key]
//            let y = your[key]
//            
//            if b == m {
//                object[key] = y
//            } else if b == y {
//                object[key] = m
//            } else {
//                switch (b, m, y) {
//                case (_, .Some(let m), .Some(let y)):
//                    let result = self.merge(path, base: b, mine: m, your: y)
//                    switch result {
//                    case .Merged(let r):
//                        object[key] = r
//                    case .Conflicted(let cs):
//                        conflicts += cs
//                    }
//                default:
//                    conflicts.append(Conflict(path: path, base: b, mine: m!, your: y!))
//                }
//            }
//        }
//        
//        if conflicts.isEmpty {
//            return .Merged(object)
//        } else {
//            return .Conflicted(conflicts)
//        }
//    }
}