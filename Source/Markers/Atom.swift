//
//  Atom.swift
//  MobiledocRenderer
//
//  Created by Sean Coker on 1/14/21.
//

import UIKit

public typealias AtomRenderer = (AtomEnvironment, Any?, Dictionary<String, Any>, String) -> UIView?

typealias Save = ((String, Any?) -> Any)?

public struct AtomEnvironment {
    let name: String
    var isInEditor: Bool = false
    var onTearDown: ((RenderCallback) -> Any)? = nil
    let save: Save? = nil
}

// @todo I dont really like how custom atoms have to have an empty JSONObject() payload attached
// to them When they will be passed a payload from the Atom object created from the mobiledoc
// during render time via AtomRenderer
public protocol AtomInterface {
    var name: String { get }
    var type: String { get }
    var payload: Dictionary<String, Any> { get set }
    var render: AtomRenderer { get set }
}

class Atom: AtomInterface {
    let type = "Native"
    let name: String
    let text: String
    var payload: Dictionary<String, Any>
    var render: AtomRenderer
    
    init (name: String, text: String, payload: Dictionary<String, Any>, render: @escaping AtomRenderer) {
        self.name = name
        self.text = text
        self.payload = payload
        self.render = render
    }
    
    // https://github.com/bustle/mobiledoc-kit/blob/9ee86cecbcc2d8f451ba56aa2de61c38d7286f0e/MOBILEDOC.md#signatures
    static func fromJSON(jsonArray: [Any]) throws -> Atom {
        let name = jsonArray[0] as! String
        let text = jsonArray[1] as! String
        let payload = jsonArray[2] as! Dictionary<String, Any>
            
        return Atom(name: name, text: text, payload: payload, render: { _, _, _, _ in nil})
    }
}
