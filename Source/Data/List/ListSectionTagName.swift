//
//  ListSectionTagName.swift
//  MobiledocRenderer
//
//  Created by Sean Coker on 1/14/21.
//

import Foundation

enum ListSectionTagName: String {
    case OL = "ol"
    case UL = "ul"
    
    static func forValue(value: String) -> ListSectionTagName? {
        switch value {
        case "ol":
            return .OL
        case "ul":
            return .UL
        default:
            return nil
        }
    }
}
