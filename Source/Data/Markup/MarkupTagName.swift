//
//  MarkupTagName.swift
//  MobiledocRenderer
//
//  Created by Sean Coker on 1/14/21.
//

import Foundation

public enum MarkupTagName {
    case A
    case B
    case CODE
    case EM
    case I
    case S
    case STRONG
    case SUB
    case SUP
    case U
    // Custom added item so we can account for html text nodes
    // (ie text not surrounded by any of the above)
    case SPAN
    
    var value: String {
        switch self {
        case .A:
            return "a"
        case .B:
            return "b"
        case .CODE:
            return "code"
        case .EM:
            return "em"
        case .I:
            return "i"
        case .S:
            return "s"
        case .STRONG:
            return "strong"
        case .SUB:
            return "sub"
        case .SUP:
            return "sup"
        case .U:
            return "u"
        case .SPAN:
            return "span"
        }
    }
    
    static func forValue(value: String) -> MarkupTagName? {
        switch value {
        case "a":
            return .A
        case "b":
            return .B
        case "code":
            return .CODE
        case "em":
            return .EM
        case "i":
            return .I
        case "s":
            return .S
        case "strong":
            return .STRONG
        case "sub":
            return .SUB
        case "sup":
            return .SUP
        case "u":
            return .U
        case "span":
            return .SPAN
        default:
            return nil
        }
    }
}
