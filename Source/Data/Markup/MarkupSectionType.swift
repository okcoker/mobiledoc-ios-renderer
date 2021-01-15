//
//  MarkupSectionType.swift
//  MobiledocRenderer
//
//  Created by Sean Coker on 1/14/21.
//

import Foundation

public enum MarkupSectionType {
    case MARKUP
    case IMAGE
    case LIST
    case CARD
    
    var value: Int {
        switch self {
        case .MARKUP:
            return 1
        case .IMAGE:
            return 2
        case .LIST:
            return 3
        case .CARD:
            return 10
        }
    }
    
    static func forInt(int: Int) -> MarkupSectionType? {
        switch int {
        case 1:
            return .MARKUP
        case 2:
            return .IMAGE
        case 3:
            return .LIST
        case 10:
            return .CARD
        default:
            return nil
        }
    }
}
