//
//  Phraselayer.swift
//  Book_Sources
//
//  Created by Daniel Leal on 25/03/20.
//

import Foundation
import SpriteKit

/**
    Protocol responsible for the sentence layer.
*/
protocol PhraseLayer: class {
    var phrase: Phrase! {get set}
    
    //MARK: Spaces
    var widthLetter : CGFloat! {get set}
    var spaceBetweenLetters:CGFloat! {get set}
    var heightLetter: CGFloat! {get set}
    var spaceBetweenLines: CGFloat! {get set}
    
    //MARK: Configs Phrase
    var backgroundColor: UIColor! {get set}
    var fontSize: CGFloat! {get set}
    var fontName: String! {get set}
    
    typealias HiddenWordConfiguration = (CGFloat, CGSize)
    
    func setupPhrase(fontSize: CGFloat, backgroundColor: UIColor, fontName: String)
    
    func setupCompletePhrase(string: String, selectedWords: [String:Int])
    func setupPartialPhrase(string: String, selectedWords: [String:Int])
    func setupDislexicPhrase(string: String, selectedWords: [String:Int])
}

extension PhraseLayer {
    
    // Initially arrow the phrase
    func setupPhrase(fontSize: CGFloat, backgroundColor: UIColor, fontName: String){
        self.spaceBetweenLetters = Constants.viewSize.width * 0.002
        self.backgroundColor = backgroundColor
        self.fontSize = fontSize
        self.fontName = fontName
        
        let aux = Utils.makeLetter(value: "A", fontSize: fontSize, fontName: fontName)
        self.widthLetter = aux.frame.width
        self.heightLetter = aux.frame.height
        self.spaceBetweenLines = self.heightLetter*2
    }
    
    // Set the complete sentence (without hidden words)
    func setupCompletePhrase(string: String, selectedWords: [String:Int]) {
        
        guard let node = self as? SKNode else {return}
        
        for child in node.children {
            child.removeFromParent()
        }
        
        phrase = self.makePhrase(string: string)
        self.positioningPhrase(phrase: phrase)
        
        self.adjustPhrase(words: selectedWords)
        
    }
    
    // Set the partial phrase (only a few letters missing parts)
    func setupPartialPhrase(string: String, selectedWords: [String:Int]) {
        
        guard let node = self as? SKNode else {return}
        
        for child in node.children {
            child.removeFromParent()
        }
        
        phrase = self.makePhrase(string: string)
        self.positioningPhrase(phrase: phrase)
        self.addInvisibileNodes(percentage: 50)
        self.adjustPhrase(words: selectedWords)
    }
    
    //Set dyslexic phrase (all letters missing parts)
    func setupDislexicPhrase(string: String, selectedWords: [String:Int]) {
        
        guard let node = self as? SKNode else {return}
        
        for child in node.children {
            child.removeFromParent()
        }
        
        let words = Utils.makeWords(normalPhrase: string, fontSize: fontSize, fontName: fontName)
        let lines = Utils.makeLines(words: words, size: Constants.viewSize, fontSize: fontSize, fontName: fontName)
        phrase = Phrase(lines: lines)
        
        self.positioningPhrase(phrase: phrase)
        
        self.adjustPhrase(words: selectedWords)
        
        for line in phrase.lines {
            for word in line.words {
                for letter in word.letters {
                    Utils.addInvisibleNodeInCharacter(caracter: letter, bgColor: self.backgroundColor)
                }
            }
        }
    }
    
    //MARK: Positioning Phrase in Scene Functions
    
    //Function that positions and adds the phrase to the layer
    func positioningPhrase(phrase: Phrase) {
        guard let node = self as? SKNode else {return}
        
        //Initial position of letters
        let xStartLetter:CGFloat = Constants.viewSize.width * Constants.startPhrase
        let yStartLetter: CGFloat = Constants.viewSize.height * 0.57
        
        //Helper to position the letters
        var auxLetter = 1
        var auxLines = 1
        var auxPositionXLetter:CGFloat = 0
        var auxPositionYLetter:CGFloat = yStartLetter
        
        
        for line in phrase.lines {
            auxPositionXLetter = xStartLetter
            
            for word in line.words {
                
                for letter in word.letters {
                    //MARK: Setting the color of the letters and positioning them
                    letter.fontColor = Utils.UIColorFromRGB(rgbValue: 0x2E6584)
                    var positionX: CGFloat
                    var positionY: CGFloat
                    
                    if (auxLetter == 1){
                        positionX = xStartLetter
                    }else {
                        positionX = auxPositionXLetter
                    }
                    
                    if (auxLines == 1){
                        positionY = yStartLetter
                    }else {
                        positionY = auxPositionYLetter
                    }
                    
                    if letter.text == "I"{
                        positionX -= 5
                    }
                    
                    
                    letter.position = CGPoint(x: positionX, y: positionY)
                    node.addChild(letter)
                    
                    if (letter.text == " "){
                        auxPositionXLetter += 2
                    }else {
                        auxPositionXLetter += letter.frame.width + spaceBetweenLetters
                    }
                    
                    auxLetter += 1
                }
                
            }

            auxPositionYLetter -= spaceBetweenLines
            auxLines += 1
            
        }
    }
    
    //MARK: Create Phrase Functions
    
    //Creates the sentence from a string
    func makePhrase(string: String) -> Phrase{
        
        let words = Utils.makeWords(normalPhrase: string, fontSize: fontSize, fontName: "Helvetica-Bold")
        let lines = Utils.makeLines(words: words, size: Constants.viewSize, fontSize: fontSize, fontName: fontName)
        let phrase = Phrase(lines: lines)
        
        return phrase
    }
    
    //MARK: Hidden node functions
    
    //Receive the dictionary of words that must be "hidden"
    func adjustPhrase (words: [String: Int]) {
        self.removeAlphaWords(selectedWords: words)
        self.addNodeToHiddenWords()
    }
    
    //You receive a string of the word that was correctly selected, and then you must remove the hidden word, showing the word that was hidden.
    func removeHiddenWord(word: String) {
        guard let node = self as? SKNode else {return}
        for child in node.children {
            if let hiddenWord = child as? HiddenWord {
                if hiddenWord.value == word{
                    hiddenWord.removeFromParent()
                }
            }
        }
        
        for line in self.phrase.lines {
            for auxWord in line.words {
                if self.takeWordString(word: auxWord) == word {
                    auxWord.addAlpha()
                }
            }
        }
    }
    
    // Receive a percentage and add invisible nodes to each character of the sentence from that percentage
    func addInvisibileNodes(percentage: CGFloat) {
        
        var randoms = [Int]()
        var letters = [Letter]()
        var maximo = 0
        
        let lines = phrase.lines
        for line in lines {
            for word in line.words {
                if Utils.calculateLettersInWord(word: word) > 2 {
                    for letter in word.letters {
                        if (letter.text != " "){
                            letters.append(letter)
                        }
                    }
                }
            }
        }
        
        for _ in 0..<letters.count{
            randoms.append(Int.random(in: 0...letters.count-1))
        }
        
        maximo = Int(CGFloat(letters.count-1) * (percentage/100))
        
        for i in 0...maximo {
            let letterSelected = letters[randoms[i]]
            Utils.addInvisibleNodeInCharacter(caracter: letterSelected, bgColor: self.backgroundColor)
        }
        
    }
    
    // Remove the alpha of the words from the past dictionary, so that it is possible to add the hidden word instead.
    func removeAlphaWords(selectedWords:[String:Int]){
        
        let lines = self.phrase.lines
        
        for (word, index) in selectedWords {
            var auxIndex = 1
            for line in lines {
                for auxWord in line.words {
                    if (self.takeWordString(word: auxWord) == word && auxIndex == index){
                        auxWord.removeAlpha()
                        auxIndex += 1
                    }else if (self.takeWordString(word: auxWord) == word) {
                        auxIndex += 1
                    }
                }
            }
        }
    }
    
    // Add the word node "hidden" in the words that were removed from the alpha.
    func addNodeToHiddenWords() {
        guard let node = self as? SKNode else {return}
        for line in self.phrase.lines {
            for word in line.words{
                if (word.state == .hidden){
                    let wordString = self.takeWordString(word: word)
                    guard let configuration = self.calculateSizeHiddenWord(word: word) else {return}
                    let hiddenWord = HiddenWord(value: wordString, size: configuration.1)
                    hiddenWord.position.y = (word.letters.last?.position.y)! - 2
                    hiddenWord.position.x = configuration.0
                    node.addChild(hiddenWord)
                    
                    for letter in word.letters {
                        letter.fontColor = Utils.UIColorFromRGB(rgbValue: 0x8B0E0E)
                    }
                }
            }
        }
    }
    
    // Function that calculates the size and position in which the hidden word will be added
    private func calculateSizeHiddenWord(word: Word) -> HiddenWordConfiguration? {
        let heigth = self.heightLetter!
        var width: CGFloat!
        var center: CGFloat!
        var index = 0
        
        let proportion: CGFloat = 0.7
        
        for line in self.phrase.lines {
            if line.words.contains(word) {
                let words = line.words
                
                // If it is the first
                if (words[index] == word){
                    let startPhrase = Constants.viewSize.width * Constants.startPhrase
                    //If you only have her on the line
                    if (index == words.count - 1) {
                        width =  proportion * (self.takeLastLetterInWord(word: words[index]).position.x - startPhrase)
                        center = (self.takeLastLetterInWord(word: words[index]).position.x + startPhrase)/2
                        return HiddenWordConfiguration(center, CGSize(width: width, height: heigth))
                    } else{
                        let nextLetter = words[index + 1].letters.first!
                        width = proportion * (nextLetter.position.x - startPhrase)
                        center = ((nextLetter.position.x - 20 ) + (startPhrase))/2
                    }
                }else{
                    while (words[index+1] != word){
                        index += 1
                    }
                    // If there is a next word of the word we want
                    if (index+2 <= words.count-1 ) {
                        // First letter of the next word of the word we want to place the hidden word node
                        guard let firstLetter = words[index+2].letters.first else {return nil}
                        // Last letter of the word before the word we want to place the hidden word node
                        let lastLetter = self.takeLastLetterInWord(word: words[index])
                        width = proportion * ((firstLetter.position.x) - (lastLetter.position.x))
                        center = ((firstLetter.position.x) + (lastLetter.position.x))/2
                    }else {
                        let lastLetterCurrentWord = self.takeLastLetterInWord(word: words[index+1])
                        let lastLetterPreviousWord = self.takeLastLetterInWord(word: words[index])
                        
                        width = proportion * ((lastLetterCurrentWord.position.x) - (lastLetterPreviousWord.position.x))
                        center = ((lastLetterCurrentWord.position.x) + (lastLetterPreviousWord.position.x))/2 + 8
                    }
                }
                
            }
        }
        
        return HiddenWordConfiguration(center, CGSize(width: width, height: heigth))
    }
    
    //Take just the word string, removing all "" that have been added to justify the text
    private func takeWordString(word: Word) -> String{
        var wordString = ""
        for letter in word.letters{
            wordString += letter.text!
        }
        wordString.removeAll { $0 == " " }
        return wordString
    }
    
    //It receives a word and returns only its last letter, not counting "".
    private func takeLastLetterInWord(word: Word) -> Letter {
        var index = 0
        while (word.letters[index+1].text != " "){
            index+=1
        }
        return word.letters[index]
    }
    
    
    
}

