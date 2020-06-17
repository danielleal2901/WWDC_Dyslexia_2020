//
//  Letter.swift
//  Book_Sources
//
//  Created by Daniel Leal on 28/03/20.
//

import Foundation
import SpriteKit

/**
    Class that inherits from SKLabelNode to add some extra functions.
    It is used as a character in the words of the sentences
*/
class Letter: SKLabelNode {
    
    func setAlphaClear() {
        self.alpha = 0
    }
    
    func setAlphaEnabled(){
        self.alpha = 1
    }
}
