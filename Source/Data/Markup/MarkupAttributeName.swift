//
//  MarkupAttributeName.swift
//  MobiledocRenderer
//
//  Created by Sean Coker on 1/14/21.
//

import Foundation

public enum MarkupAttributeName {
    case HREF
    case REL
    
    var value: String {
        switch self {
        case .HREF:
            return "href"
        case .REL:
            return "rel"
        }
    }
    
    static func forValue(value: String) -> MarkupAttributeName? {
        switch value {
        case "href":
            return .HREF
        case "rel":
            return .REL
        default:
            return nil
        }
    }
}
