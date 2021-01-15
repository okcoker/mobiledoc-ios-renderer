//
//  MarkerType.swift
//  MobiledocRenderer
//
//  Created by Sean Coker on 1/14/21.
//

import Foundation

enum MarkerType {
    case TEXT
    case ATOM
    
    var value: Int {
        switch self {
        case .TEXT:
            return 0
        case .ATOM:
            return 1
        }
    }
    
    static func forInt(int: Int) -> MarkerType? {
        switch int {
        case 0:
            return .TEXT
        case 1:
            return .ATOM
        default:
            return nil
        }
    }
}
