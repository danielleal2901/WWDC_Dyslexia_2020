//
//  BgFourtyScn.swift
//  Book_Sources
//
//  Created by Daniel Leal on 26/03/20.
//

import Foundation
import SpriteKit

/**
    Class responsible for the background of the second page.
*/
class BgSecondScn: SKNode, BackgroundLayer {
    var timerLabel: SKLabelNode?
    var wordsLabel: SKLabelNode?
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Set the background
    func setupBG() {
        
        let pages = SKSpriteNode(imageNamed: "Group_Pages.png")
        pages.setScale(0.8)
        pages.anchorPoint = CGPoint(x: 0, y: 0.5)
        
        self.addChild(pages)
        
        pages.zRotation = 0.25
        
        pages.position = CGPoint(x: Constants.viewSize.width * 0.85, y: -Constants.viewSize.height * 0.05)
        
    }
    
}
