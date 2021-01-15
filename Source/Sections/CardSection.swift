//
//  CardSection.swift
//  MobiledocRenderer
//
//  Created by Sean Coker on 1/14/21.
//

import UIKit

class CardSection: SectionInterface {
    let type = MarkupSectionType.CARD
    let index: Int
    
    init(index: Int = 0) {
        self.index = index
    }
    
    func render(config: MobiledocRendererConfig) -> UIView {
        return UIView()
    }

    static func fromJSON(jsonArray: [Any]) throws -> CardSection {
        return CardSection(index: jsonArray[1] as! Int)
    }
}
