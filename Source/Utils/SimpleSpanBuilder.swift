//
//  SimpleSpanBuilder.swift
//  MobiledocRenderer
//
//  Created by Sean Coker on 1/14/21.
//

import UIKit

public class SimpleSpanBuilder {
    private var spans = [Span]()
    private let stringBuilder = StringBuilder()
    
    private class StringBuilder {
        private var text = ""
        var count: Int {
            return text.count
        }
        
        func append(text: String) {
            self.text += text
        }
        
        func toString() -> String {
            return text
        }
    }
    
    fileprivate class SpannableStringBuilder {
        private let text: NSMutableAttributedString
        
        init(_ text: String) {
            self.text = NSMutableAttributedString(string: text)
        }
        
        func setSpan(styleKey: NSAttributedString.Key, styleValue: Any, startIndex: Int, endIndex: Int) {
            let range = NSRange(location: startIndex, length: endIndex - startIndex)
            
            self.text.addAttribute(styleKey, value: styleValue, range: range)
        }
        
        func toString() -> NSAttributedString {
            return self.text
        }
    }
    
    public class Span {
        private var startIndex: Int = 0
        private var styles: [NSAttributedString.Key: Any]
        var text: String
        
        private init(index: Int, text: String, styles: [NSAttributedString.Key: Any]) {
            self.startIndex = index
            self.text = text
            self.styles = styles
        }
        
        convenience init(text: String, styles: [NSAttributedString.Key: Any]) {
            self.init(index: 0, text: text, styles: styles)
        }
        
        fileprivate func setIndex(index: Int) -> Span {
            return Span(index: index, text: self.text, styles: styles)
        }
        
        fileprivate func apply(spanStringBuilder: SpannableStringBuilder?) {
            guard let builder = spanStringBuilder else {
                return
            }
            
            for (key, value) in self.styles {
                builder.setSpan(
                    styleKey: key,
                    styleValue: value,
                    startIndex: startIndex,
                    endIndex: startIndex + self.text.count
                )
            }
        }
    }
    
    init() {}
    
    init(span: Span) {
        append(span: span)
    }
    
    func append(span: Span) {
        spans.append(span.setIndex(index: stringBuilder.count))
        stringBuilder.append(text: span.text)
    }
    
    func build() -> NSAttributedString {
        let ssb = SpannableStringBuilder(stringBuilder.toString())
        
        for span in spans {
            span.apply(spanStringBuilder: ssb)
        }
        
        return ssb.toString()
    }
}
