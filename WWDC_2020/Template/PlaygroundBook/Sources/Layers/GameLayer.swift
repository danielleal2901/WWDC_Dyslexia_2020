//
//  GameLayer.swift
//  Book_Sources
//
//  Created by Daniel Leal on 25/03/20.
//

import Foundation
import SpriteKit

/**
    Protocol responsible for the logic layer of the scenes.
*/
protocol GameLayer: class {
    
    // Optional scene timer
    var timer: Timer? {get set}
    
    // Number of optional scene correct keywords
    var rigthWords: Int? {get set}
    
    // Delegate to communicate with the scene
    var delegateLogicGame: ProtocolLogicScene? {get set}
    
    // Set the scene initially
    func setupScene()
    
    //Receive and manage the scene's touches
    func touchesBegan(touchedNodes: [SKNode])
    
    //Set the game layer
    func setupGameLayer(delegate: ProtocolLogicScene)
            
}

extension GameLayer {
    
    func touchesBegan(touchedNodes: [SKNode]){
        
    }
    
    func setupGameLayer(delegate: ProtocolLogicScene) {
        self.delegateLogicGame = delegate
    }
    
}
