//
//  HiddenWord.swift
//  Book_Sources
//
//  Created by Daniel Leal on 27/03/20.
//

import Foundation
import SpriteKit

/**
    Class that inherits from SKSpriteNode and is used to cover signaling that a word is missing from the sentence.
*/
class HiddenWord: SKSpriteNode {
    
    private var _value: String!
    public var value: String {
        get {
            return _value
        }
    }
    
    init(value: String, size: CGSize) {
        self._value = value
        let texture = SKTexture(imageNamed: "HiddenWord")
        super.init(texture: texture, color: .clear, size: size)
        self.name = "HiddenWord"
        self.anchorPoint = CGPoint(x: 0.5, y: 0.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
