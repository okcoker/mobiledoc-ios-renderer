//
//  SectionInterface.swift
//  MobiledocRenderer
//
//  Created by Sean Coker on 1/14/21.
//

import UIKit

public protocol SectionInterface {
    var type: MarkupSectionType { get }
    func render(config: MobiledocRendererConfig) -> UIView
}
