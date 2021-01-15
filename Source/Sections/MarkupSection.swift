//
//  MarkupSection.swift
//  MobiledocRenderer
//
//  Created by Sean Coker on 1/14/21.
//

import UIKit

class MarkupSection: SectionInterface {
    var type = MarkupSectionType.MARKUP
    let markers: [Marker]
    let tagName: MarkupSectionTagName
    
    init(markers: [Marker], tagName: MarkupSectionTagName?) {
        self.markers = markers
        self.tagName = tagName ?? MarkupSectionTagName.P
    }
    
    func render(config: MobiledocRendererConfig) -> UIView {
//        return when (tagName) {
//            MarkupSectionTagName.H3 -> {
        let textView = UITextView()
//        textView.text = markers[0].value
//
//        let params = LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT)
////        params.bottomMargin = config.sectionSpacing
//        textView.layoutParams = params
//        textView.setPadding(0, 0, 0, config.sectionSpacing)

        return textView
//            }
//            else -> View(context)
//        }
    }

    static func fromJSON(jsonArray: [Any]) throws -> MarkupSection {
        let tagName = MarkupSectionTagName.forValue(value: jsonArray[1] as! String)
        let markers = (jsonArray[2] as! [[Any]]).map { marker in
            return try! Marker.fromJSON(jsonArray: marker)
        }

        return MarkupSection(markers: markers, tagName: tagName)
    }
}
