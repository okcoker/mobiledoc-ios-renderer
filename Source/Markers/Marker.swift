//
//  Marker.swift
//  MobiledocRenderer
//
//  Created by Sean Coker on 1/14/21.
//

class Marker {
    var type: MarkerType
    var markupMarkerIds: [Int]
    var closeCount: Int = 0
    var value: String

    init(type: MarkerType, markupMarkerIds: [Int], closeCount: Int = 0, value: String) {
        self.type = type
        self.markupMarkerIds = markupMarkerIds
        self.closeCount = closeCount
        self.value = value
    }
    
    static func fromJSON(jsonArray: [Any]) throws -> Marker {
        let type = MarkerType.forInt(int: jsonArray[0] as! Int)!
        let markerIds: [Int] = (jsonArray[1] as! [Int])
        let closeCount = jsonArray[2] as! Int
        let value = jsonArray[3] as? String ?? ""
        
        return Marker(type: type, markupMarkerIds: markerIds, closeCount: closeCount, value: value)
    }
}
