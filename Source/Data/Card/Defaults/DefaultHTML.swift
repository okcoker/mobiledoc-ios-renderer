//
//  DefaultHTML.swift
//  MobiledocRenderer
//
//  Created by Sean Coker on 1/14/21.
//

import UIKit
import WebKit

fileprivate let renderer: CardRenderer = { env, options, payload in
    print("Custom DefaultHTML render")
    let webview = WKWebView()
        
    if let html = payload["html"] as? String {
        let viewPortString = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head>"
        webview.loadHTMLString("\(viewPortString)\(html)", baseURL: nil)
        webview.scrollView.isScrollEnabled = false
        // @todo do we need hooks so that constraints can be added after
        // views are added to the view hierarchy?
        webview.heightAnchor.constraint(equalToConstant: 300).isActive = true
        webview.backgroundColor = .none
        webview.isOpaque = false
        return webview
    }
    
    return nil
}


public class DefaultHTML: CardInterface {
    public let type = "Native"
    public var name: String = "html"
    public var render = renderer
    public var payload = [String: Any]()
    
    public init() {}
    
    public init(payload: [String: Any]) {
        self.payload = payload
    }
}
