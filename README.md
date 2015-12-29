# Majima

Three-way merge for array and dictionary, in Swift.

```swift
public enum Result<T> {
  case Merged(T)
  case Conflicted
}

public class ThreewayMerge {
  public static func merge<T: Equatable>(base base: [T], mine: [T], theirs: [T]) -> Result<[T]>
  public static func merge<K, V: Equatable>(base base: [K: V], mine: [K: V], theirs: [K: V]) -> result<[K:V]>
}
```

## Array

```swift
let m = Majima.ThreewayMerge()

let base = [1, 2, 3]
let mine = [0, 1, 2, 3]   // 0 is inserted
let theirs = [1, 2]       // 3 is deleted

let result = m.merge(base: base, mine: mine, theirs: theirs)
// .Merged([0, 1, 2])     // 0 is inserted, 3 is deleted
```

The diff calculation is naively implemented. You may find issues when you run on big array.

## Dictionary

```swift
let m = Majima.ThreewayMerge()

let base = ["name": "Soutaro", "email": "matsumoto@soutaro.com"]
let mine = ["name": "Soutaro", "email": "matsumoto@ubiregi.com"] // email is updated
let theirs = ["name": "Soutaro Matsumoto", "email": "matsumoto@soutaro.com"] // name is updated

let result = m.merge(base: base, mine: mine, theirs: theirs)
// .Merged(["name": "Soutaro Matsumoto", "email": "matsumoto@ubiregi.com"])
```

# Installation

You can install the library via Cocoapods.

```
pod 'majima'
```

# Copyright

Soutaro Matsumoto.
See LICENSE for detail.
