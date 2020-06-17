//
//  HudScnOne.swift
//  Book_Sources
//
//  Created by Daniel Leal on 25/03/20.
//

import Foundation
import SpriteKit

/**
    // Class responsible for the hud (controls) of the first page.
*/class HudFirstScn: SKNode, HudLayer {
    
    var nextButton: SKSpriteNode!
    var labelButton: SKLabelNode!
    
    var realButtonsValue: [String]? = []
    var options: [WordOption]? = []
    var words: [String : [String]]? = [:]
    
    //Array that holds the word array for each option
    var initialOptions : [String:[String]]? = [:]
        
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Arrow to hud, pre arrow the buttons to be used later
    func setupHud() {
        nextButton = SKSpriteNode(imageNamed: "Next_Button")
        nextButton.setScale(0.33)
        nextButton.position = CGPoint(x: Constants.viewSize.width * 0.72, y: Constants.viewSize.height * 0.2)
        nextButton.name = "NextButton"
        
        labelButton = SKLabelNode(text: "Next")
        labelButton.name = "NextButton"
        labelButton.fontColor = .white
        labelButton.fontName = "Helvetica-Bold"
        labelButton.fontSize = 70
        labelButton.horizontalAlignmentMode = .center
        labelButton.verticalAlignmentMode = .center
        labelButton.position = CGPoint(x: 0, y: 5)
        
        self.addChild(nextButton)
        nextButton.addChild(labelButton)
        
        nextButton.alpha = 0
        
        //Initialize the four buttons
        for _ in 0...3 {
           options!.append(WordOption())
        }
        
        var x = Constants.viewSize.width * 0.23 + (options?.first!.size.width)!/2
        
        for option in options! {
            option.position = CGPoint(x: x, y: Constants.viewSize.height * 0.3)
            x = option.position.x + option.frame.width + Constants.viewSize.width * 0.015
        }
    }
    
    //Set the initial hud options
    func setupInitialOptions(words: [String:[String]]) {
        self.words = words

        initialOptions = words

        //Adding the correct word to the word array
        for (key, _) in words{
            initialOptions![key]?.append(key)
            initialOptions![key]?.shuffle()
        }
    
    }
    
    //Set hud options, based on the word that was chosen
    func setupOptions(wordSelected: String) {
        
        var wordsToBeSettedIInOptions = [String]()
        for (key, value) in initialOptions! {
            if key == wordSelected {
                wordsToBeSettedIInOptions = value
            }
        }
        
        var indexOption = 0
        for word in wordsToBeSettedIInOptions {
            let option = options![indexOption]
            option.removeFromParent()
            option.value = word
            self.addChild(option)
            indexOption += 1
        }
        
    }
    

}
