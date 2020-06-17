//
//  BackgroundLayer.swift
//  Book_Sources
//
//  Created by Daniel Leal on 25/03/20.
//

import Foundation
import SpriteKit

/**
    Protocol used for the background of the scenes.
*/
protocol BackgroundLayer: AnyObject {
    
    // Optional timer label
    var timerLabel: SKLabelNode? {get set}
    
    // Optional correct keyword label
    var wordsLabel: SKLabelNode? {get set}
    
    // Set the background
    func setupBG()
}

