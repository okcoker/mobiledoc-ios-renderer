//
//  DefaultImage.swift
//  MobiledocRenderer
//
//  Created by Sean Coker on 1/14/21.
//

import UIKit

func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}

fileprivate let renderer: CardRenderer = { env, options, payload in
    print("Custom DefaultImage render")
    if let imageUrl = payload["src"] as? String {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        getData(from: URL(string: imageUrl)!, completion: { data, _, _  in
            if let imageData = data {
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)
                    imageView.image = image
                }
            }
        })
        // @todo do we need hooks so that constraints can be added after
        // views are added to the view hierarchy?
        imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 400).isActive = true
        return imageView
    }
    
    return nil
}


public class DefaultImage: CardInterface {
    public let name = "image"
    public let type = "Native"
    public let render = renderer
    public var payload = [String: Any]()
    
    public init() {}
    
    init(payload: [String: Any]) {
        self.payload = payload
    }
}
