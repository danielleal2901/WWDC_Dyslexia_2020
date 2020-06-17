//
//  LoadingScene.swift
//  Book_Sources
//
//  Created by Daniel Leal on 26/03/20.
//

import Foundation
import SpriteKit
import AVFoundation

/**
    Scene used as loading scene of the first page
*/
class LoadingScene: SKScene {

    var playButton: SKSpriteNode!
    var player: AVAudioPlayer!
        
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.setupScene()
    }
    
    // Set the loading scene of the first page
    func setupScene() {
        self.backgroundColor = Utils.UIColorFromRGB(rgbValue: 0x4C97BF)

        self.playButton = SKSpriteNode(imageNamed: "Start_Button")
        self.playButton.setScale(0.33)
        self.playButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        self.playButton.name = "startButton"
        
        let labelStart = SKLabelNode(fontNamed: "Helvetica-Bold")
        labelStart.text = "Start"
        labelStart.name = "startButton"
        labelStart.fontSize = 50 * 3
        labelStart.verticalAlignmentMode = .center
        labelStart.horizontalAlignmentMode = .center
        labelStart.position = CGPoint(x: 0, y: 5)
        self.playButton.addChild(labelStart)
        
        self.addChild(self.playButton)
        Utils.prepareAudioButton()
        self.playSound()
    }
    
    // Receives and manages the loading scene touches from the first page
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let positionInScene = touch.location(in: self)
            if let touchedNode = self.nodes(at: positionInScene).first{
                if let name = touchedNode.name {
                    if name == "startButton" {
                        Utils.playSoundButtonClicked(button: touchedNode)
                        Utils.touchButtonWithLabels(firstTouchedNode: touchedNode, touchedNodes: self.nodes(at: positionInScene), nodeName: name) {
                                self.goSceneOne()
                        }
                    }
                }
            }
        }
    }
    
    //Function to play the background sound
    func playSound() {
        guard let url = Bundle.main.url(forResource: "Cylinder_Six", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            
            player.numberOfLoops = -1
            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //Go to the next scene on the page
    func goSceneOne() {
        let scene = SceneOne(hudLayer: HudFirstScn(), backgroundLayer: BgFirstScn(), gameLayer: GameFirstScn(), size: self.size, phraseLayer: PhraseFirstScn(), player: self.player)
        self.view?.presentScene(scene)
    }
    
}
