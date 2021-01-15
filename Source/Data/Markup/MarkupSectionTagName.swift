//
//  MarkupSectionTagName.swift
//  MobiledocRenderer
//
//  Created by Sean Coker on 1/14/21.
//

import Foundation

enum MarkupSectionTagName {
    case ASIDE
    case BLOCKQUOTE
    case H1
    case H2
    case H3
    case H4
    case H5
    case H6
    case P
    
    var value: String {
        switch self {
        case .ASIDE:
            return "aside"
        case .BLOCKQUOTE:
            return "blockquote"
        case .H1:
            return "h1"
        case .H2:
            return "h2"
        case .H3:
            return "h3"
        case .H4:
            return "h4"
        case .H5:
            return "h5"
        case .H6:
            return "h6"
        case .P:
            return "p"
        }
    }
    
    static func forValue(value: String) -> MarkupSectionTagName? {
        switch value {
        case "aside":
            return .ASIDE
        case "blockquote":
            return .BLOCKQUOTE
        case "h1":
            return .H1
        case "h2":
            return .H2
        case "h3":
            return .H3
        case "h4":
            return .H4
        case "h5":
            return .H5
        case "h6":
            return .H6
        case "p":
            return .P
        default:
            return nil
        }
    }
}
