//import Foundation
//import Quick
//@testable import Majima
//
//class ObjectMergeTests: QuickSpec {
//    override func spec() {
//        let merge = ThreeWayMerge(objectIdentifierKey: "id")
//        
//        describe("object merge") {
//            it("merges from nil key to mine/your") {
//                let result = merge.merge(
//                    base: ["id": 3] as JSONObject,
//                    mine: ["id": 3, "name": "John", "phone": "123-456-789"] as JSONObject,
//                    your: ["id": 3, "email": "john@example.com", "phone": "123-456-789"] as JSONObject)
//                
//                XCTAssertEqual(result, MergeResult.Merged(["id": 3, "name": "John", "email": "john@example.com", "phone": "123-456-789"] as JSONObject))
//            }
//            
//            it("merges from some key to mine/your") {
//                let result = merge.merge(
//                    base: ["id": 3, "phone": "123-456-789"] as JSONObject,
//                    mine: ["id": 3, "phone": "123-456-789"] as JSONObject,
//                    your: ["id": 3, "phone": "000-000-000"] as JSONObject
//                )
//                
//                XCTAssertEqual(result, MergeResult.Merged(["id": 3, "phone": "000-000-000"] as JSONObject))
//            }
//            
//            it("merges from some key to nil") {
//                let result = merge.merge(
//                    base: ["id": 3, "phone": "123-456-789"] as JSONObject,
//                    mine: ["id": 3, "email": "test@example.com", "phone": "123-456-789"] as JSONObject,
//                    your: ["id": 3] as JSONObject
//                )
//                
//                XCTAssertEqual(result, MergeResult.Merged(["id": 3, "email": "test@example.com"] as JSONObject))
//            }
//            
//            it("finds conflicts if id is different") {
//                let result = merge.merge(
//                    base: ["id": 3] as JSONObject,
//                    mine: ["id": 4] as JSONObject,
//                    your: ["id": 5] as JSONObject
//                )
//                
//                XCTAssertEqual(result, MergeResult.Conflicted([Conflict(path: [], base: ["id": 3] as JSONObject, mine: ["id": 4] as JSONObject, your: ["id": 5] as JSONObject)]))
//            }
//        }
//    }
//}
