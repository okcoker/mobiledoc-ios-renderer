//
//  Markup.swift
//  MobiledocRenderer
//
//  Created by Sean Coker on 1/14/21.
//

import UIKit

public typealias MarkupAttribute = (MarkupAttributeName, String)
public protocol MarkupInterface {
    var tagName: MarkupTagName { get }
    var attributes: [MarkupAttribute] { get }
    func render(config: MobiledocRendererConfig, value: String, parentMarkups: [MarkupInterface]) -> SimpleSpanBuilder.Span
}

class Markup: MarkupInterface {
    var tagName: MarkupTagName
    var attributes: [MarkupAttribute]
    
    init(tagName: MarkupTagName, attributes: [MarkupAttribute]) {
        self.tagName = tagName
        self.attributes = attributes
    }
    
    func render(config: MobiledocRendererConfig, value: String, parentMarkups: [MarkupInterface]) -> SimpleSpanBuilder.Span {
        var markups = [MarkupInterface]()
        markups.append(self)
        markups.append(contentsOf: parentMarkups)

        return Markup.buildStyledSpan(config: config, value: value, markups: markups)
    }

    static func fromJSON(jsonArray: [Any]) throws -> Markup {
        let tagName = MarkupTagName.forValue(value: jsonArray[0] as! String)!
        var attributes = [MarkupAttribute]()
        let attributesArray = jsonArray[safeIndex: 1] as? [String] ?? [String]()
        for (index, key) in (attributesArray).enumerated() {
            if (index % 2 == 0) {
                if let name = MarkupAttributeName.forValue(value: key) {
                    attributes.append(MarkupAttribute(name, attributesArray[index + 1]))
                }
            }
        }
        
        return Markup(tagName: tagName, attributes: attributes)
    }

    static func buildStyledSpan(config: MobiledocRendererConfig, value: String, markups: [MarkupInterface]) -> SimpleSpanBuilder.Span {
        var styles = [NSAttributedString.Key: Any]()
        var fontTraits = [UIFontDescriptor.SymbolicTraits]()
        var fontSize = UIFont.labelFontSize
        var font = UIFont.systemFont(ofSize: fontSize)
        
        markups.forEach { markup in
            switch (markup.tagName) {
                case .B, .STRONG:
                    fontTraits.append(.traitBold)
                    
                case .I, .EM:
                    fontTraits.append(.traitItalic)

                case .CODE:
                    fontTraits.append(.traitMonoSpace)

                case .S:
                    styles[NSAttributedString.Key.strikethroughStyle] = 2

                case .SUB:
                    fontSize = fontSize / 2
                    styles[.baselineOffset] = -fontSize

                case .SUP:
                    fontSize = fontSize / 2
                    styles[.baselineOffset] = fontSize

                case .U:
                    styles[.underlineStyle] = NSUnderlineStyle.single.rawValue

                case .A:
                    markup.attributes.forEach { attr in
                        if (attr.0 == MarkupAttributeName.HREF && !attr.1.isEmpty) {
                            styles[.link] = URL(string: attr.1)
                        }
                    }

                case .SPAN:
                    // Empty on purpose
                    break
            }
        }
        
        fontTraits.forEach { trait in
            font = font.addTrait(trait: trait)
        }
        
        styles[NSAttributedString.Key.font] = font
        
        return SimpleSpanBuilder.Span(text: value, styles: styles)
    }
}
