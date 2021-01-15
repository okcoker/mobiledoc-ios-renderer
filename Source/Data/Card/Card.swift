//
//  Card.swift
//  MobiledocRenderer
//
//  Created by Sean Coker on 1/14/21.
//

import UIKit

public struct CardEnvironment {
    let name: String
    let isInEditor: Bool
    var onTearDown: (RenderCallback) -> Void
    let didRender: (RenderCallback) -> Void
}

public typealias CardRenderer = (CardEnvironment, Any?, [String: Any]) -> UIView?

// @todo I dont really like how custom cards have to have an empty JSONObject() payload attached
// to them When they will be passed a payload from the Card object created from the mobiledoc
// during render time via CardRenderer
public protocol CardInterface {
    var name: String { get }
    var type: String { get }
    var payload: [String: Any] { get set }
    var render: CardRenderer { get }
}

let nullRender: CardRenderer = { _, _, _ in nil }

class Card: CardInterface {
    let type = "Native"
    let name: String
    let render: CardRenderer
    var payload: [String: Any]
    
    init(name: String, payload: [String: Any], render: @escaping CardRenderer) {
        self.name = name
        self.render = render
        self.payload = payload
    }
    
    // https://github.com/bustle/mobiledoc-kit/blob/9ee86cecbcc2d8f451ba56aa2de61c38d7286f0e/MOBILEDOC.md#signatures
    static func fromJSON(jsonArray: [Any]) throws -> Card {
        let name = jsonArray[0] as! String
        let payload = jsonArray[1] as! Dictionary<String, Any>

        return Card(name: name, payload: payload, render: nullRender)
    }
}
