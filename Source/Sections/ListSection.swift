//
//  ListSection.swift
//  MobiledocRenderer
//
//  Created by Sean Coker on 1/14/21.
//

import UIKit

class ListSection: SectionInterface {
    var type = MarkupSectionType.LIST
    let markers: [[Marker]]
    let tagName: ListSectionTagName
    
    init(markers: [[Marker]], tagName: ListSectionTagName = ListSectionTagName.OL) {
        self.markers = markers
        self.tagName = tagName
    }

    func render(config: MobiledocRendererConfig) -> UIView {
        return UIView()
    }
    
    static func fromJSON(jsonArray: [Any]) throws -> ListSection {
        let tagName = ListSectionTagName.forValue(value: jsonArray[1] as! String)!
        let markers: [[Marker]] = (jsonArray[2] as! [[[Any]]]).map { listItemMarkers in
            return listItemMarkers.map { marker in
                return try! Marker.fromJSON(jsonArray: marker)
            }
        }
        
        return ListSection(markers: markers, tagName: tagName)
    }
}
