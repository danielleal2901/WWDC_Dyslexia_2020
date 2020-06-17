//
//  SceneOne.swift
//  Book_Sources
//
//  Created by Daniel Leal on 25/03/20.
//

import Foundation
import AVFoundation
import SpriteKit

/**
    Class responsible for the scene on the first page, where the test is performed.
*/
class SceneOne: SKScene, Scene {
    
    var bgLayer: BackgroundLayer
    var hudLayer: HudLayer?
    var gameLayer: GameLayer
    var phraseLayer: PhraseLayer?
    
    var player: AVAudioPlayer!

    required init(backgroundLayer: BackgroundLayer, gameLayer: GameLayer, size: CGSize) {
        self.bgLayer = backgroundLayer
        self.gameLayer = gameLayer
        super.init(size: size)
    }
    
    convenience init(hudLayer: HudLayer, backgroundLayer: BackgroundLayer, gameLayer: GameLayer, size: CGSize, phraseLayer: PhraseLayer, player: AVAudioPlayer) {
        self.init(backgroundLayer: backgroundLayer, gameLayer: gameLayer, size: size)
        self.phraseLayer = phraseLayer
        self.hudLayer = hudLayer
        self.player = player
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        guard let bg = self.bgLayer as? BgFirstScn else {return}
        guard let phrase = self.phraseLayer as? PhraseFirstScn else {return}
        guard let hud = self.hudLayer as? HudFirstScn else {return}
        
        self.addChild(bg)
        self.addChild(phrase)
        self.addChild(hud)
        
        //Setup Layers
        bg.setupBG()
        hud.setupHud()
        //Primeira frase
        phrase.setupPhrase(fontSize: 20, backgroundColor: .white, fontName: "Helvetica-Bold")
                
        gameLayer.setupGameLayer(delegate: self)
        gameLayer.setupScene()
        self.backgroundColor = Utils.UIColorFromRGB(rgbValue: 0x4C97BF)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let positionInScene = touch.location(in: self)
            let touchedNodes = self.nodes(at: positionInScene)
            gameLayer.touchesBegan(touchedNodes: touchedNodes)
        }
    }
    
}


extension SceneOne: ProtocolLogicFirstScene {

    func sceneAddSelectedWord(selectedNode: SKSpriteNode) {
        self.addChild(selectedNode)
    }
    
    func deselectWords() {
        guard let phrase = self.phraseLayer as? SKNode else {return}

        for node in self.children {
            if node.name == "SelectedWord"{
                node.removeFromParent()
            }
        }
        for node in phrase.children {
            if node.name == "HiddenWord"{
                node.alpha = 1
            }
        }
        
    }
    
    func hudLayerRemoveOptions() {
        guard let hud = self.hudLayer as? HudFirstScn else {return}
        hud.removeOptions()
    }
    
    func hudSetNextButtonAlpha(alpha: CGFloat) {
        guard let hud = self.hudLayer as? HudFirstScn else {return}
        hud.nextButton.alpha = alpha
        if (alpha == 1){
            hud.nextButton.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 0.30, duration: 0.5), SKAction.scale(to: 0.33, duration: 0.5)])))
        }
    }
    
    func setupPhrase(string: String, words: [String : Int], dicWords: [String : [String]], phrase: Int) {
        guard let phraseLayer = self.phraseLayer as? PhraseFirstScn else {return}
        guard let hud = self.hudLayer as? HudFirstScn else {return}
        
        hud.setupInitialOptions(words: dicWords)
        
        switch phrase {
        case 1:
            phraseLayer.setupCompletePhrase(string: string, selectedWords: words)
            //Colocar a animacao da vibracao apenas na primeira palavra
            var flag = false
            
            for child in phraseLayer.children {
                if let node = child as? HiddenWord, !flag {
                    flag = true
                    let actionScale = SKAction.scaleX(to: 0.8, duration: 0.5)
                    let reversedScale = SKAction.scaleX(to: 1.0, duration: 0.5)
                    let group = SKAction.sequence([actionScale, reversedScale])
                    node.run(SKAction.repeatForever(group))
                }
            }
            
        case 2:
            phraseLayer.setupPartialPhrase(string: string, selectedWords: words)
        case 3:
            phraseLayer.setupDislexicPhrase(string: string, selectedWords: words)
        default:
            break
        }
                
    }
    
    func hudSetupOptions(wordSelected: String) {
        guard let hud = self.hudLayer as? HudFirstScn else {return}
        hud.setupOptions(wordSelected: wordSelected)
    }
    
    func phraseRemoveHiddenWord(word: String) {
        guard let phrase = self.phraseLayer as? PhraseFirstScn else {return}
        phrase.removeHiddenWord(word: word)
    }
    
    func setupTimerLabel(value: Int) {
        guard let bg = self.bgLayer as? BgFirstScn else {return}
        bg.timerLabel?.text = String(value)
    }
    
    func setupScoreLabel(value: Int) {
        guard let bg = self.bgLayer as? BgFirstScn else {return}
        bg.wordsLabel?.text = String(value)
    }
    
    func setupPopover(bg: SKSpriteNode) {
        
        guard let gameLayer = self.gameLayer as? GameFirstScn else {return}

        for child in self.children {
            child.alpha = 0
        }
        bg.position = CGPoint(x: self.size.width * 0.0074, y: 0)
        bg.run(SKAction.move(to: CGPoint(x: self.size.width * 0.0074, y: self.size.height * 0.223), duration: 0.25))
        
        self.addChild(bg)
        
        if gameLayer.currentPhrase == 3 {
            let timer = CGFloat(self.player.currentTime)
            UserDefaults.standard.setValue(timer, forKey: "CurrentTimeMusic")
        }
        
    }
    
    // After you clicked OK on the popover
    func resetScene() {
        self.deselectWords()
        guard let phrase = self.phraseLayer as? SKNode else {return}
        guard let gameLayer = self.gameLayer as? GameFirstScn else {return}
        
        // If you haven't entered the completion yet
        var flag = false
        for child in self.children {
            if child.name != "Popover" && child != phrase {
                child.run(SKAction.fadeAlpha(to: 1.0, duration: 0.5), completion: {
                    if (!flag){
                        phrase.alpha = 1
                        gameLayer.playNextPhrase()
                        flag = true
                    }
                })
            }
        }
    }
    
    func removePopover() {
        for child in self.children {
            if (child.name == "Popover") {
                child.run(SKAction.move(to: CGPoint(x: self.size.width * 0.0074, y: 0), duration: 0.25)) {
                    child.removeFromParent()
                    self.resetScene()
                }
            }
        }
    }
    
    func changeNameNextButtonHud() {
        guard let hud = self.hudLayer as? HudFirstScn else {return}
        hud.labelButton.text = "Finish"
    }
    
    func setupEndScene(popover: SKSpriteNode) {
        
        for child in self.children {
            child.alpha = 0
        }
        popover.position = CGPoint(x: self.size.width * 0.5, y: 0)
        popover.run(SKAction.move(to: CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5), duration: 0.5))
        
        self.addChild(popover)
        
    }
    
    func removeOptionsTimeIsOver() {
        guard let hud = self.hudLayer as? HudFirstScn else {return}
        
        for child in hud.children {
            if child is WordOption {
                child.removeFromParent()
            }
        }
        self.deselectWords()
    }

}


