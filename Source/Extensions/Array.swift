//
//  Array.swift
//  MobiledocRenderer
//
//  Created by Sean Coker on 1/14/21.
//

import Foundation

extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}
