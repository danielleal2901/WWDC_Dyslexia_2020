//
//  OptionsWord.swift
//  Book_Sources
//
//  Created by Daniel Leal on 27/03/20.
//

import Foundation
import SpriteKit

/**
    Class that inherits from SKSpriteNode and is used as the word options in the hudlayer.
*/
class WordOption: SKSpriteNode {
    
    var label: SKLabelNode!
    var value: String = "" {
        didSet {
            self.label.text = self.value
        }
    }
    
    init () {
        let texture = SKTexture(imageNamed: "Option_Button")
        super.init(texture: texture, color: .clear, size: texture.size())
        self.setScale(0.34)
        self.name = "Option_Button"
        label = SKLabelNode(text: "Next")
        label.name = "Option_Button"
        label.fontColor = .white
        label.fontName = "Helvetica-Bold"
        label.fontSize = 21 * 2.9
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: 5)
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
