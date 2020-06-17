//
//  Scene.swift
//  Book_Sources
//
//  Created by Daniel Leal on 25/03/20.
//

import Foundation
import SpriteKit

/**
    This protocol is used to create scenes from the sprite kit that use the other standard layers.
*/
protocol Scene: SKScene {
    
    var bgLayer: BackgroundLayer {get set}
    var hudLayer: HudLayer? {get set}
    var gameLayer: GameLayer {get set}
    var phraseLayer: PhraseLayer? {get set}
            
    init(backgroundLayer: BackgroundLayer, gameLayer: GameLayer, size: CGSize)
    
}
