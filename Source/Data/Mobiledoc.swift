//
//  Mobiledoc.swift
//  MobiledocRenderer
//
//  Created by Sean Coker on 1/14/21.
//

import Foundation

struct Mobiledoc {
    let version: String
    let atoms: [AtomInterface]
    let cards: [CardInterface]
    let markups: [MarkupInterface]
    let sections: [SectionInterface]
}
