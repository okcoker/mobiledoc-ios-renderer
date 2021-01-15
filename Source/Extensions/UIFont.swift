//
//  UIFont.swift
//  MobiledocRenderer
//
//  Created by Sean Coker on 1/15/21.
//

import UIKit

extension UIFont {
    func addTrait(trait: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = self.fontDescriptor
        guard let newDescriptor = descriptor.withSymbolicTraits(trait) else { return self
        }

        return UIFont(descriptor: newDescriptor, size: 0)
    }
    
    func removeTrait(trait: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = self.fontDescriptor
        var symTraits = descriptor.symbolicTraits
        symTraits.remove(trait)
        
        guard let newDescriptor = descriptor.withSymbolicTraits(symTraits) else {
            return self
        }
        
        return UIFont(descriptor: newDescriptor, size: 0)
    }
}
