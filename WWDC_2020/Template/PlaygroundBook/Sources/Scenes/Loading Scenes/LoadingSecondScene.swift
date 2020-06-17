//
//  LoadingSecondScene.swift
//  Book_Sources
//
//  Created by Daniel Leal on 04/04/20.
//

import Foundation
import SpriteKit
import AVFoundation

/**
    Scene used as loading scene for the second page.
*/
class LoadingSecondScene: SKScene {
    
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
    
    // Set the loading scene on the second page
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
    
    // Receives and manages the touches of the scene
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let positionInScene = touch.location(in: self)
            if let touchedNode = self.nodes(at: positionInScene).first{
                if let name = touchedNode.name {
                    if name == "startButton" {
                        Utils.playSoundButtonClicked(button: touchedNode)
                        Utils.touchButtonWithLabels(firstTouchedNode: touchedNode, touchedNodes: self.nodes(at: positionInScene), nodeName: name) {
                                self.goSceneTwo()
                        }
                    }
                }
            }
        }
    }
    
    // Play the background sound of the page
    func playSound() {
        guard let url = Bundle.main.url(forResource: "Cylinder_Six", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            
            player.numberOfLoops = -1
            player.play()

            guard let timer = UserDefaults.standard.value(forKey: "CurrentTimeMusic") as? CGFloat else {return}
            player.currentTime = TimeInterval(timer)

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //Go to the second scene on the first page
    func goSceneTwo() {
        let scene = SceneTwo(backgroundLayer: BgSecondScn(), gameLayer: GameSecondScn(), size: self.size, player: self.player)
        self.view?.presentScene(scene)
    }
    
}
