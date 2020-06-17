//
//  PhraseLayer.swift
//  Book_Sources
//
//  Created by Daniel Leal on 25/03/20.
//

import Foundation
import SpriteKit

/**
    Class responsible for creating the phrases used in the test.
*/
class PhraseFirstScn: SKNode, PhraseLayer {
    
    var backgroundColor: UIColor!
    var fontSize: CGFloat!
    var fontName: String!
    
    var phrase: Phrase!
    var widthLetter : CGFloat!
    var spaceBetweenLetters:CGFloat!
    var heightLetter: CGFloat!
    var spaceBetweenLines: CGFloat!
    
    typealias HiddenWordConfiguration = (CGFloat, CGSize)
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
