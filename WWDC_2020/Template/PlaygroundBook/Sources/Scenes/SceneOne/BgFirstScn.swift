//
//  BgScnOne.swift
//  Book_Sources
//
//  Created by Daniel Leal on 25/03/20.
//

import Foundation
import SpriteKit

/**
      Class responsible for the front page background
*/
class BgFirstScn: SKNode, BackgroundLayer {
    
    var timerLabel: SKLabelNode?
    var wordsLabel: SKLabelNode?
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Set the background
    func setupBG() {
        
        let midPosition = CGPoint(x: Constants.viewSize.width * 0.52, y: Constants.viewSize.height * 0.5)
        
        //MARK: Terminar de setar os assets
        let pages = SKSpriteNode(texture: SKTexture(imageNamed: "Group_Pages"), color: .clear, size: Constants.viewSize)
        pages.position = midPosition
        pages.setScale(0.8)
        
        let timerIcon = SKSpriteNode(imageNamed: "Timer_Icon.png")
        timerIcon.anchorPoint = CGPoint(x: 0, y: 0)
        timerIcon.setScale(0.33)
        timerIcon.position = CGPoint(x: Constants.viewSize.width * 0.731, y: Constants.viewSize.height * 0.745)
        
        timerLabel = SKLabelNode(text: "40")
        timerLabel!.fontSize = 40
        timerLabel!.fontName = "Helvetica-Bold"
        timerLabel!.fontColor = Utils.UIColorFromRGB(rgbValue: 0xFDB900)
        timerLabel!.position = CGPoint(x: Constants.viewSize.width * 0.7, y: Constants.viewSize.height * 0.75)
        
        wordsLabel = SKLabelNode(text: "0")
        wordsLabel!.fontSize = 37
        wordsLabel!.fontName = "Helvetica-Bold"
        wordsLabel!.fontColor = Utils.UIColorFromRGB(rgbValue: 0x2E4D5F)
        wordsLabel!.position = CGPoint(x: Constants.viewSize.width * 0.5, y: Constants.viewSize.height * 0.75)
        
        let textlabel = SKLabelNode(text: "TEST")
        textlabel.fontSize = 45
        textlabel.fontName = "Helvetica-Bold"
        textlabel.fontColor = Utils.UIColorFromRGB(rgbValue: 0x2E4D5F)
        textlabel.position = CGPoint(x: Constants.viewSize.width * 0.5, y: Constants.viewSize.height * 0.65)
        
        self.addChild(pages)
        self.addChild(timerLabel!)
        self.addChild(wordsLabel!)
        self.addChild(timerIcon)
        self.addChild(textlabel)
    }
    
}
