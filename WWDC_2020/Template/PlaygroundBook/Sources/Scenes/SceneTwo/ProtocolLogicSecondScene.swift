//
//  ProtocolLogicSecondScene.swift
//  Book_Sources
//
//  Created by Daniel Leal on 03/04/20.
//

import Foundation
import SpriteKit

/**
    Protocol used for the communication between the game layer and the scene on the second page.
*/
protocol ProtocolLogicSecondScene: ProtocolLogicScene {
    
    // Scene receives a label (which must be added to it) and the paragraphs of that label, which will be modified according to the animation.
    func setupLabel(label: SKLabelNode, paragraphOne : NSMutableParagraphStyle, paragraphTwo: NSMutableParagraphStyle, completion: @escaping () -> Void)
    
    // Scene must add the first ellipse
    func setupEllipseOne(ellipseOne: SKSpriteNode, completion: @escaping () -> Void)
    
    // Scene must add the second ellipse
    func setupEllipseTwo(ellipseTwo: SKSpriteNode, completion: @escaping () -> Void)
    
    // Scene must add the "next scene" label
    func setupLabelNextScene(label: SKLabelNode)

    //Scene should do the animation moving on to the next scene.
    func setupNewScene(completion: @escaping () -> Void)
    
    //Scene should add the label "touch the screen to go to the next scene".
    func addNewSceneLabel(label: SKLabelNode)
}
