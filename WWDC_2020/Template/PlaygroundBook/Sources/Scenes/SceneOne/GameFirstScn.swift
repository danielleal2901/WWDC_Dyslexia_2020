
//
//  GameScnOne.swift
//  Book_Sources
//
//  Created by Daniel Leal on 25/03/20.
//

import Foundation
import SpriteKit

/**
        Class responsible for the logic of the scene on the first page.
*/
class GameFirstScn: GameLayer {
    
    weak var timer: Timer?
    private var touchedWord: String!
    var currentPhrase = 1
    
    weak var delegateLogicGame: ProtocolLogicScene?
    
    //Words that were complete, to end the scene
    var complectedWords = 0
    
    //Correct words in sentence
    var rigthWords : Int? {
        didSet {
            guard let delegate = self.delegateLogicGame as? ProtocolLogicFirstScene else {return}
            delegate.setupScoreLabel(value: self.rigthWords!)
        }
    }
    
    //Variable to set the timer
    var countTimer = 40 {
        didSet {
            guard let delegate = self.delegateLogicGame as? ProtocolLogicFirstScene else {return}
            delegate.setupTimerLabel(value: self.countTimer)
        }
    }
    
    //Function to set the scene initially
    func setupScene() {
        guard let delegate = self.delegateLogicGame as? ProtocolLogicFirstScene else {return}

        rigthWords = 0
        
        let string = "“Simple can be harder than complex: You have to work hard to get your thinking clean to make it simple. But it’s worth it in the end because once you get there, you can move mountains.”"
        let words = ["WORK": 1, "SIMPLE.": 1, "MOVE": 1]
        let dicWords = ["WORK" : ["REST", "SLEEP", "SPEAK"], "SIMPLE." : ["LOVING.", "CRITICAL.", "HEAVY."], "MOVE": ["RUN", "STUDY", "MEASURE"]]
        
        delegate.setupPhrase(string: string, words: words, dicWords: dicWords, phrase: 1)
        
        self.setupTimer()
    }
    
    //Function that receives and manages the touches of the scene
    func touchesBegan(touchedNodes: [SKNode]) {
        if let touchedNode = touchedNodes.first{
            guard let name = touchedNode.name  else {return}
            switch name {
            case "HiddenWord":
                if (countTimer > 0){
                    Utils.playSoundButtonClicked(button: touchedNode)
                    guard let node = touchedNode as? HiddenWord else {return}
                    self.setupOptionInHud(wordSelected: node.value)
                    self.setupSelectedWord(node: node)
                }
            case "NextButton":
                Utils.playSoundButtonClicked(button: touchedNode)
                Utils.touchButtonWithLabels(firstTouchedNode: touchedNode, touchedNodes: touchedNodes, nodeName: name) {
                    self.setupEndPhrase()
                }
            case "Option_Button":
                Utils.playSoundButtonClicked(button: touchedNode)
                Utils.touchButtonWithLabels(firstTouchedNode: touchedNode, touchedNodes: touchedNodes, nodeName: name) {
                    guard let node = touchedNode as? WordOption else {
                        for auxTouch in touchedNodes {
                            if let node = auxTouch as? WordOption {
                                self.optionChoosed(option: node.value)
                            }
                        }
                        return
                    }
                    self.optionChoosed(option: node.value)
                }
            case "Ok_Button":
                Utils.playSoundButtonClicked(button: touchedNode)
                if (self.currentPhrase != 3){
                    Utils.touchButtonWithLabels(firstTouchedNode: touchedNode, touchedNodes: touchedNodes, nodeName: name) {
                        self.setupNextPhrase()
                    }
                }
            default:
                break
            }
        }
    }
    
    //Function that sets and manages the timer.
    func setupTimer() {
        guard let delegate = self.delegateLogicGame as? ProtocolLogicFirstScene else {return}
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.countTimer -= 1
            if (self.countTimer <= 0){
                self.timer!.invalidate()
                delegate.hudSetNextButtonAlpha(alpha: 1)
                delegate.removeOptionsTimeIsOver()
            }
        })
    }
    
    // Function that sends a value to the background, informing that the label timer must be changed
    func setupTimerBackground(value: Int) {
        guard let delegate = self.delegateLogicGame as? ProtocolLogicFirstScene else {return}
        delegate.setupTimerLabel(value: value)
    }
    
    //Function that sends a value to the background informing that the score of the label must change
    func setupScoreBackground(value: Int) {
        guard let delegate = self.delegateLogicGame as? ProtocolLogicFirstScene else {return}
        delegate.setupScoreLabel(value: value)
    }
    
    // Function that notifies the scene that must deselect the words that have been selected to complete
    func deselectWords() {
        guard let delegate = self.delegateLogicGame as? ProtocolLogicFirstScene else {return}
        delegate.deselectWords()
    }
    
    //Function that sets a node in the word that was clicked to be completed.
    func setupSelectedWord(node: SKNode) {
        guard let delegate = self.delegateLogicGame as? ProtocolLogicFirstScene else {return}

        let selectedNode = SKSpriteNode(texture: SKTexture(imageNamed: "SelectedWord"))
        selectedNode.setScale(0.15)
        selectedNode.size.width = node.frame.size.width
        deselectWords()
        node.alpha = 0
        selectedNode.name = "SelectedWord"
        selectedNode.position = node.position
        selectedNode.position.y += 10
        
        delegate.sceneAddSelectedWord(selectedNode: selectedNode)
    }
    
    //Function that sends a string to the hud layer, informing which word has been selected to be completed, then the hud sets the options (buttons) for that word.
    func setupOptionInHud(wordSelected: String){
        guard let delegate = self.delegateLogicGame as? ProtocolLogicFirstScene else {return}
        delegate.hudSetupOptions(wordSelected: wordSelected)
        self.touchedWord = wordSelected
    }
    
    //Function that receives the button chosen to complete the word, and manages, if it gets right it increases the number of correct words, and the number of words that have been completed, ends the game if it reaches the maximum points, in addition to decreasing the points if the user miss the word.
    func optionChoosed(option: String){
        guard let delegate = self.delegateLogicGame as? ProtocolLogicFirstScene else {return}

        if option == touchedWord {
            self.deselectWords()
            rigthWords! += 1
            complectedWords += 1
            delegate.phraseRemoveHiddenWord(word: option)
            delegate.hudLayerRemoveOptions()
            if (complectedWords >= 3){
                self.timer?.invalidate()
                delegate.hudSetNextButtonAlpha(alpha: 1)
            }
        }else {
            if (rigthWords! > 0){
                rigthWords! -= 1
            }
        }
    }
    
    //Resets the scene and removes the popover when clicked "OK"
    func setupNextPhrase() {
        guard let delegate = self.delegateLogicGame as? ProtocolLogicFirstScene else {return}
        delegate.removePopover()
    }
    
    //Scene call to start the next phase when the animation is over
    func playNextPhrase() {
        self.countTimer = 40
        self.rigthWords = 0
        self.complectedWords = 0
        self.touchedWord = ""
        switch self.currentPhrase {
        case 1:
            self.setupSecondPhrase()
        case 2:
            self.setupThirdPhrase()
        default:
            break
        }
        self.currentPhrase += 1
    }
    
    //Save the values and set the new sentence
    func setupEndPhrase() {
        guard let delegate = self.delegateLogicGame as? ProtocolLogicFirstScene else {return}
        
        delegate.hudSetNextButtonAlpha(alpha: 0)
        switch self.currentPhrase {
        case 1:
            UserDefaults.standard.set(rigthWords, forKey: "PhraseOne_rightWords")
            UserDefaults.standard.set(countTimer, forKey: "PhraseOne_timer")
        case 2:
            UserDefaults.standard.set(rigthWords, forKey: "PhraseTwo_rightWords")
            UserDefaults.standard.set(countTimer, forKey: "PhraseTwo_timer")
        case 3:
            UserDefaults.standard.set(rigthWords, forKey: "PhraseThree_rightWords")
            UserDefaults.standard.set(countTimer, forKey: "PhraseThree_timer")
        default:
            break
        }
        self.showPopoverResults()
    }
    
    //Popover showing results at the end of each sentence
    func showPopoverResults() {
        guard let delegate = self.delegateLogicGame as? ProtocolLogicFirstScene else {return}
        
        let words = rigthWords!
        let timeUsed = 40 - countTimer
        
        let score = Int(Utils.calculateScore(words: words, timer: timeUsed))
        let background = SKSpriteNode(imageNamed: "BgResults.png")
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.name = "Popover"
        
        let labelTitle = SKLabelNode(fontNamed: "Helvetica-Bold")
        labelTitle.position = CGPoint(x: Constants.viewSize.width * 0.5, y: background.size.height * 0.665)
        labelTitle.fontColor = Utils.UIColorFromRGB(rgbValue: 0xFDB900)
        labelTitle.fontSize = 48
        labelTitle.text = "Final Score"
        
        let labelScore = SKLabelNode(fontNamed: "Helvetica-Bold")
        labelScore.position = CGPoint(x: Constants.viewSize.width * 0.5, y: Constants.viewSize.height * 0.175)
        labelScore.horizontalAlignmentMode = .center
        labelScore.verticalAlignmentMode = .center
        labelScore.fontColor = .white
        labelScore.fontSize = 40
        labelScore.text = "Score: \(String(score))"
        
        let labelWords = SKLabelNode(fontNamed: "Helvetica-Bold")
        labelWords.position = CGPoint(x: Constants.viewSize.width * 0.15, y: Constants.viewSize.height * 0.3)
        labelWords.horizontalAlignmentMode = .left
        labelWords.verticalAlignmentMode = .center
        labelWords.fontColor = .white
        labelWords.fontSize = 30
        labelWords.text = "Correct Words: \(String(words))"
        
        let labelTimer = SKLabelNode(fontNamed: "Helvetica-Bold")
        labelTimer.position = CGPoint(x: Constants.viewSize.width * 0.15, y: Constants.viewSize.height * 0.23)
        labelTimer.horizontalAlignmentMode = .left
        labelTimer.verticalAlignmentMode = .center
        labelTimer.fontColor = .white
        labelTimer.fontSize = 30
        labelTimer.text = "Time: \(String(timeUsed))"
        
        let okButton = SKSpriteNode(imageNamed: "Option_Button")
        okButton.setScale(0.33)
        okButton.position = CGPoint(x: Constants.viewSize.width * 0.78, y: Constants.viewSize.height * 0.14)
        okButton.name = "Ok_Button"
        
        // If it is the last sentence, set a label at the bottom of the screen, stating that it is for the user to go to the next page.
        if (self.currentPhrase == 3){
            okButton.alpha = 0.5
            
            let labelGoNextPage = SKLabelNode(fontNamed: "Helvetica-Bold")
            labelGoNextPage.text = "End of the test, go to the next page."
            labelGoNextPage.fontColor = Utils.UIColorFromRGB(rgbValue: 0x2E4D5F)
            labelGoNextPage.position = CGPoint(x: background.size.width * 0.5, y: -background.size.height * 0.21)
            labelGoNextPage.verticalAlignmentMode = .center
            labelGoNextPage.horizontalAlignmentMode = .center
            background.addChild(labelGoNextPage)
            
        }
        
        let labelButton = SKLabelNode(text: "OK")
        labelButton.name = "Ok_Button"
        labelButton.fontColor = .white
        labelButton.fontName = "Helvetica-Bold"
        labelButton.fontSize = 70
        labelButton.horizontalAlignmentMode = .center
        labelButton.verticalAlignmentMode = .center
        labelButton.position = CGPoint(x: 0, y: 5)
        okButton.addChild(labelButton)
        
        background.addChild(okButton)
        background.addChild(labelTitle)
        background.addChild(labelScore)
        background.addChild(labelWords)
        background.addChild(labelTimer)
        
        delegate.setupPopover(bg: background)
        
    }
    
    // Function that sets the second sentence, sends a phrase layer notification that must set the second sentence.
    // In addition to passing an array of words and the response dictionary for those words.
    func setupSecondPhrase() {
        guard let delegate = self.delegateLogicGame as? ProtocolLogicFirstScene else {return}

        let words = ["WAY" :1, "TRAP" : 1, "FOLLOW": 1]
        let string = "“Remembering that you are going to die is the best way I know to avoid the trap of thinking you have something to lose. You are already naked. There is no reason not to follow your heart.”"
        let dicWords = ["WAY" : ["HOUSE", "BOOK", "GAME"], "TRAP" : ["GUN", "SCHOOL", "BAG"], "FOLLOW" : ["STOP", "READ", "CALL"]]
        
        delegate.setupPhrase(string: string, words: words, dicWords: dicWords, phrase: 2)
        
        self.setupTimer()
    }
    
    // Function that sets the third sentence, sends a phrase layer notification that must set the third sentence.
    // In addition to passing an array of words and the response dictionary for those words.
    func setupThirdPhrase() {
        guard let delegate = self.delegateLogicGame as? ProtocolLogicFirstScene else {return}

        let words = ["SETTLE." : 1, "LIKE":1 , "BETTER":2]
        let string = "“If you haven't found it yet, keep looking. Don't settle. As with all matters of the heart, you'll know when you find it. And, like any great relationship, it just gets better and better as the years roll on.”"
        let dicWords = ["SETTLE." : ["DESPAIR.", "SMILE.", "GET UP."], "LIKE" : ["WHEN", "WHERE", "MAYBE"], "BETTER": ["WORST", "COLD", "NATURAL"]]
        
        delegate.setupPhrase(string: string, words: words, dicWords: dicWords, phrase: 3)
        delegate.changeNameNextButtonHud()
        
        self.setupTimer()
    }
    

}
