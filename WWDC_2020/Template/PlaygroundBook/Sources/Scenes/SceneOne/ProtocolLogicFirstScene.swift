//
//  ProtocolLogicGame.swift
//  Book_Sources
//
//  Created by Daniel Leal on 03/04/20.
//

import Foundation
import SpriteKit

/**
    Protocol used for the communication between the game layer and the scene on the first page.
*/
protocol ProtocolLogicFirstScene: ProtocolLogicScene {
    
    //MARK: Scene Functions
    
    // Scene add the node that the word was selected
    func sceneAddSelectedWord(selectedNode: SKSpriteNode)
    
    // Scene must remove all of the selected word
    func deselectWords()
    
    //Scene must reset the scene completely
    func resetScene()
    
    //MARK: Hud Functions
    
    //Hud must remove all options (buttons) from completing the words.
    func hudLayerRemoveOptions()
    
    //Hud must change the alpha of the "next" button.
    func hudSetNextButtonAlpha(alpha: CGFloat)
    
    //Hud must set the options available for the string that was passed.
    func hudSetupOptions(wordSelected: String)
    
    //Hud should change the name of the button "next" to "finish"
    func changeNameNextButtonHud()
    
    //Hud should remove the options (buttons) when the phrase time runs out.
    func removeOptionsTimeIsOver()
    
    //MARK: Phrase Functions
    
    //Phrase receives a string, a dictionary for these strings, which strings should be "hidden" and an integer, stating the number of the sentence to be set.
    func setupPhrase(string: String, words: [String: Int], dicWords: [String: [String]], phrase: Int)
    
    //Phrase receives a string informing which word it should remove "Hidden Word"
    func phraseRemoveHiddenWord(word: String)
    
    //MARK: Background Functions
    
    //Background must set the label timer with the received value
    func setupTimerLabel(value: Int)
    
    //Background must set the score label with the received value.
    func setupScoreLabel(value: Int)
    
    //MARK: Popover Result Functions
    
    //Scene must set the mode end popover.
    func setupPopover(bg: SKSpriteNode)
    //Scene must remove the popover.
    func removePopover()
    
    //Scene must set the end of scene popover.
    func setupEndScene(popover: SKSpriteNode)
    
    
}
