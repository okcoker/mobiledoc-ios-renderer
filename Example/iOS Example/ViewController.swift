//
//  ViewController.swift
//  iOS Example
//
//  Created by Sean Coker on 1/14/21.
//

import UIKit
import MobiledocRenderer

class ViewController: UIViewController {
    @IBOutlet weak var content: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let json = readJSON()!
        var bottomAnchor: NSLayoutYAxisAnchor? = nil
        let cards: [CardInterface] = [
            DefaultHTML(),
            DefaultImage()
        ]
        let sectionViews = MobiledocRenderer(mobiledoc: json, cards: cards).render().result
        sectionViews.forEach { v in
            v.translatesAutoresizingMaskIntoConstraints = false
            
            content.addSubview(v)
            
            if let v = v as? UITextView {
                if #available(iOS 13.0, *) {
                    v.textColor = .label
                }
                v.isEditable = false
                v.isScrollEnabled = false
            }
            
            v.leadingAnchor.constraint(equalTo: content.leadingAnchor).isActive = true
            v.trailingAnchor.constraint(equalTo: content.trailingAnchor).isActive = true
            v.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
            
            if let bottom = bottomAnchor {
                v.topAnchor.constraint(equalTo: bottom).isActive = true
            }
            else {
                v.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
            }
            
            bottomAnchor = v.bottomAnchor
            
            if (v == sectionViews.last) {
                let bottomlayoutConstraint = scrollView.constraints.first(where: { constraint in
                    return constraint.identifier == "bottomLayout"
                })
                
                bottomlayoutConstraint?.isActive = false
                v.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
            }
        }
    }
    
    func readJSON() -> String? {
        if let path = Bundle.main.path(forResource: "audiomack", ofType: "json") {
            do {
                let jsonString = try String(contentsOf: URL(fileURLWithPath: path))
                return jsonString
            } catch {
                print(error)
            }
        }
        
        return nil
    }
}

