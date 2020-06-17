//
//  SceneFour.swift
//  Book_Sources
//
//  Created by Daniel Leal on 26/03/20.
//

import Foundation
import SpriteKit
import AVFoundation

/**
    Class responsible for the scene on the second page, where the test results are shown.
*/
class SceneTwo: SKScene, Scene {
    
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
    
    convenience init(backgroundLayer: BackgroundLayer, gameLayer: GameLayer, size: CGSize, player: AVAudioPlayer) {
        self.init(backgroundLayer: backgroundLayer, gameLayer: gameLayer, size: size)
        self.player = player
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        guard let bg = self.bgLayer as? BgSecondScn else {return}
        bg.setupBG()
        self.addChild(bg)
        
        self.backgroundColor = Utils.UIColorFromRGB(rgbValue: 0x4C97BF)
        self.gameLayer.setupGameLayer(delegate: self)
        self.gameLayer.setupScene()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let positionInScene = touch.location(in: self)
            let touchedNodes = self.nodes(at: positionInScene)
            gameLayer.touchesBegan(touchedNodes: touchedNodes)
        }
    }
    
}

extension SceneTwo: ProtocolLogicSecondScene {

    func setupLabel(label: SKLabelNode, paragraphOne: NSMutableParagraphStyle, paragraphTwo: NSMutableParagraphStyle, completion: @escaping () -> Void) {
        
        paragraphOne.alignment = .center
        paragraphTwo.alignment = .center
        self.addChild(label)
        
        label.position = CGPoint(x: Constants.viewSize.width * 0.5, y: Constants.viewSize.height * 0.5)
        
        // Read timeout
        let wait = SKAction.wait(forDuration: 10.0)
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)

        label.run(wait) {
            label.run(fadeOut) {
                paragraphOne.alignment = .left
                paragraphTwo.alignment = .left
                label.horizontalAlignmentMode = .left
                label.position = CGPoint(x: Constants.viewSize.width * 0.1, y: Constants.viewSize.height * 0.8)
                label.run(SKAction.fadeIn(withDuration: 1.0)) {
                    completion()
                }
            }
        }
    
    }
    
    func setupEllipseOne(ellipseOne: SKSpriteNode, completion: @escaping () -> Void) {
        ellipseOne.alpha = 0
        ellipseOne.position = CGPoint(x: Constants.viewSize.width * 0.1, y: Constants.viewSize.height * 0.3)
        self.addChild(ellipseOne)
        ellipseOne.run(SKAction.fadeAlpha(to: 1.0, duration: 1.0) , completion: {
            // Read timeout
            ellipseOne.run(SKAction.wait(forDuration: 4.0), completion: {
                completion()
            })
        })
    }
    
    func setupEllipseTwo(ellipseTwo: SKSpriteNode, completion: @escaping () -> Void) {
        ellipseTwo.alpha = 0
        ellipseTwo.position = CGPoint(x: Constants.viewSize.width * 0.66, y: Constants.viewSize.height * 0.3)
        self.addChild(ellipseTwo)
        ellipseTwo.run(SKAction.fadeAlpha(to: 1.0, duration: 1.0) , completion: {
            // Read timeout
            ellipseTwo.run(SKAction.wait(forDuration: 4.0), completion: {
                completion()
            })
        })
    }
    
    func setupLabelNextScene(label: SKLabelNode) {
        self.addChild(label)
    }
    
    func setupNewScene(completion: @escaping () -> Void) {
        // Check if you have already completed
        var flag = false
        for child in self.children {
            child.run(SKAction.moveTo(x: -1100, duration: 0.5)) {
                if (!flag) {
                    flag = true
                    completion()
                }
            }
        }
    }
    
    func addNewSceneLabel(label: SKLabelNode) {
        
        label.position = CGPoint(x: Constants.viewSize.width * 0.9, y: Constants.viewSize.height * 0.65)
        
        self.addChild(label)
        
    }
    
}
