//
//  HudLayer.swift
//  Book_Sources
//
//  Created by Daniel Leal on 25/03/20.
//

import Foundation
import SpriteKit

/**
    Protocol responsible for the hud layer of the scenes.
*/
protocol HudLayer: class {
    
    // Real value of hud buttons
    var realButtonsValue : [String]? {get set}
    
    // Array of options will be set in the hud
    var options : [WordOption]? {get set}
    
    // Dictionary of the words that will be used in the hud, will change according to the selected option
    var words: [String:[String]]? {get set}
    
    // Initial dictionary of the words of the hud.
    var initialOptions : [String:[String]]? {get set}

    // Set the hud initially
    func setupHud()
    
    // Set the hud initial option labels
    func setupInitialOptions(words: [String:[String]])
    
    //Removes all options (buttons) from the hud
    func removeOptions()
        
}

extension HudLayer {
    
    func setupInitialOptions(words: [String:[String]]) {
        self.words = words
    
        // Initialize the four buttons
        for _ in 0...3 {
            options!.append(WordOption())
        }
        
        initialOptions = words

        // Adding the correct word to the word array
        for (key, _) in words{
            initialOptions![key]!.append(key)
            initialOptions![key]!.shuffle()
        }
        
        var x = Constants.viewSize.width * Constants.startPhrase
        for option in options! {
            option.position = CGPoint(x: x, y: Constants.viewSize.height * 0.24)
            x = option.position.x + option.frame.width + Constants.viewSize.width * 0.01
        }
    }
    
    func removeOptions() {
        guard let options = self.options else {return}
        for option in options {
            option.removeFromParent()
        }
    }


}
