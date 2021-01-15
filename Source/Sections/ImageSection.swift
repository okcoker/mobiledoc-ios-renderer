//
//  ImageSection.swift
//  MobiledocRenderer
//
//  Created by Sean Coker on 1/14/21.
//

import UIKit

class ImageSection: SectionInterface {
    var type = MarkupSectionType.IMAGE
    let url: String
    
    init(url: String) {
        self.url = url
    }

    func render(config: MobiledocRendererConfig) -> UIView {
        return UIView()
    }

    static func fromJSON(jsonArray: [Any]) throws -> ImageSection {
        let url = jsonArray[1] as! String

        return ImageSection(url: url)
    }
}
