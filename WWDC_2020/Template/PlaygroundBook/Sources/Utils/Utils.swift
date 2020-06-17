//
//  Utils.swift
//  Book_Sources
//
//  Created by Daniel Leal on 29/03/20.
//

import Foundation
import SpriteKit

/**
    Class used to perform "useful" functions for various classes.
*/
class Utils {
    
    // Function that calculates the performance of each test mode
    // Receive the number of correct words and the time used
    static func calculateScore(words: Int, timer: Int) -> CGFloat {
        var newY = timer
        
        if (words == 0){
            return 0
        }

        if (newY == 0){
            newY = 1
        }
        
        let a = (3.0 * CGFloat(newY))
        let b = (40.0 * CGFloat(words))
        let c = a/b
        let z = 100.0/c
        return z
    }
    
    // Function responsible for detecting the touch of buttons that have a label like child.
    // Receives the first node touched and the array of nodes that can be touched in that position. In addition to the name of the button you want to check the ringtone.
    static func touchButtonWithLabels(firstTouchedNode: SKNode, touchedNodes: [SKNode], nodeName: String, completion: @escaping () -> Void) {
        
        guard let node = firstTouchedNode as? SKSpriteNode else {
            for auxTouch in touchedNodes {
                if let node = auxTouch as? SKSpriteNode, node.name == nodeName {
                    Utils.buttonTouched(button: node) {
                        completion()
                    }
                }
            }
            return
        }

        Utils.buttonTouched(button: node) {
            completion()
        }
        
    }
    
    // Function that gives play on the sound of when a button is clicked
    static func playSoundButtonClicked(button: SKNode) {
        let soundPath = "Click_Button.mp3"
        button.run(SKAction.playSoundFileNamed(soundPath, waitForCompletion: false))
    }
    
    //Function that prepares the audio (avoid the delay the first time an audio is played)
    static func prepareAudioButton(){
        let node = SKSpriteNode()
        node.run(SKAction.changeVolume(to: 0, duration: 0))
        let soundPath = "Click_Button.mp3"
        node.run(SKAction.playSoundFileNamed(soundPath, waitForCompletion: false))
    }
    
    //Returns a rgb color, starting from a hexadecimal value
    static func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    //MARK: Animations
    
    //Animation of when a button is touched
    static func buttonTouched(button: SKNode, completion: @escaping () -> Void) {
        let changeAlpha = SKAction.fadeAlpha(to: 0.8, duration: 0.1)
        let changeScale = SKAction.scale(to: 0.3, duration: 0.1)
        let revertScale = SKAction.scale(to: 0.33, duration: 0.1)
        let revertAlpha = SKAction.fadeAlpha(to: 1.0, duration: 0.1)

        let actions = SKAction.group([changeAlpha, changeScale])
        let reversedActions = SKAction.group([revertScale, revertAlpha])
        let sequence = SKAction.sequence([actions, reversedActions])
    
        button.run(sequence) {
            completion()
        }
    }
    
    //MARK: Make Phrase
    //Function that creates the lines according to the past word array.
    static func makeLines(words: [Word], size: CGSize, fontSize: CGFloat, fontName: String) -> [Line]{
        
        //How many letters fit on the line
        let widthLimit = size.width * 0.49
        
        
        //MARK: Assemble the lines -> Check each word if the size will exceed the limit
        var lines = [Line]()
        var index = 0
        
        while (index < words.count) {
            var count = self.calculateWidthWord(word: words[index]);
            var last = index + 1;
            
            while(last < words.count) {
                let wordWidth = self.calculateWidthWord(word: words[last])
                //Security space for letters not to be tight
                let safeSpace:CGFloat = 60.0

                if(wordWidth + count + safeSpace > widthLimit) {
                    break
                }
                count += wordWidth
                last += 1;
                
            }
            
            let line = Line()
            let difference = last - index - 1;
            
            if (last == words.count || difference == 0) {
                
                for i in index ..< last {
                    line.addWord(word: words[i])
                    line.words.last?.addLetter(letter: Utils.makeLetter(value: " ", fontSize: fontSize, fontName: fontName))
                    line.words.last?.addLetter(letter: Utils.makeLetter(value: " ", fontSize: fontSize, fontName: fontName))
                    line.words.last?.addLetter(letter: Utils.makeLetter(value: " ", fontSize: fontSize, fontName: fontName))
                    line.words.last?.addLetter(letter: Utils.makeLetter(value: " ", fontSize: fontSize, fontName: fontName))
                }
                
                while (self.calculateWidthLine(line: line) < widthLimit){
                    line.words.last?.addLetter(letter: self.makeLetter(value: " ", fontSize: fontSize, fontName: fontName))
                }
                
            }else {
                // Space that must be placed between each word
                let spaces = (widthLimit - count) / CGFloat(difference)
                //Filling each line with the words
                for i in index ..< last {
                    let newWord = words[i]
                    line.addWord(word: newWord)
                    
                    //If it is not in the last word of the line
                    if (i < last - 1){
                        
                        let oldWidth = self.calculateWidthWord(word: line.words.last!)
                        let newWidthWord = oldWidth + spaces
                        var auxWidth = oldWidth
                        while (auxWidth < newWidthWord){
                            if (auxWidth + 2 > newWidthWord){
                                break
                            }else {
                                line.words.last?.addLetter(letter: self.makeLetter(value: " ", fontSize: fontSize, fontName: fontName))
                                auxWidth = (self.calculateWidthWord(word: line.words.last!))
                            }
                        }
                    }
                }
            }
            
            lines.append(line)
            index = last
            
        }
        
        return lines
    }
    
    //MARK: Create array of words
    //Function that creates words made up of SKLabelNode characters, from a string.
    static func makeWords(normalPhrase: String, fontSize: CGFloat, fontName: String) -> [Word]{
        
        let newPhrase = normalPhrase + " "
        
        //MARK: Montar as palavras
        var words = [Word]()
        var letters = [Letter]()
        
        for letter in newPhrase {
            let upperCase = letter.uppercased()
            letters.append(self.makeLetter(value: upperCase, fontSize: fontSize, fontName: fontName))
            if (letter.isWhitespace){
                let newWord = Word(letters: letters)
                words.append(newWord)
                letters = [Letter]()
            }
        }
        
        return words
        
    }
    
    //MARK: Create letters
    //Function that creates the letter, receives a standard string and returns an instance of the Letter class with that value
    static func makeLetter(value: String, fontSize: CGFloat, fontName: String) -> Letter {
        
        let upperCase = value.uppercased()
        let letter = Letter(text: upperCase)
        letter.fontSize = fontSize
        letter.horizontalAlignmentMode = .center
        letter.fontName = fontName
        
        return letter
    }
    
    //Function that calculates the width of an instance of the Word class
    static func calculateWidthWord(word: Word) -> CGFloat{
        var width:CGFloat = 0
        for letter in word.letters {
            width += letter.frame.width
        }
        return width
    }
    
    //Function that calculates the width of an instance of Line.
    static func calculateWidthLine(line: Line) -> CGFloat{
        var width:CGFloat = 0
        for word in line.words {
            width += self.calculateWidthWord(word: word)
        }
        return width
    }
    
    //Function that calculates the number of letters in an instance of Word
    static func calculateLettersInWord (word: Word) -> Int {
        var index = 0
        while (word.letters[index].text != " "){
            index += 1
        }
        return index
    }
    
    //Function that receives a sklabelnode (character) and adds the nodes to cover the piece of the letter.
    static func addInvisibleNodeInCharacter(caracter: SKLabelNode, bgColor: UIColor){
        
        guard let text = caracter.text else {return}
        switch text {
        case "A", "Ã":
            addInvisibleNodeA(node: caracter, bgColor: bgColor)
        case "B", "D", "E", "F", "K", "P", "R", "Ê":
            addInvisibleNodeRetangle(node: caracter, bgColor: bgColor)
        case "C", "O", "S":
            addInvisibleNodeC(node: caracter, bgColor: bgColor)
        case "J", "U", "V":
            addInvisibleNodeRetangleJ(node: caracter, bgColor: bgColor)
        case "G":
            addInvisibleNodeG(node: caracter, bgColor: bgColor)
        case "H", "W":
            addInvisibleNodeH(node: caracter, bgColor: bgColor)
        case "I":
            addInvisibleNodeI(node: caracter, bgColor: bgColor)
        case "L":
            addInvisibleNodeL(node: caracter, bgColor: bgColor)
        case "M":
            addInvisibleNodeM(node: caracter, bgColor: bgColor)
        case "N":
            addInvisibleNodeN(node: caracter, bgColor: bgColor)
        case "Q":
            addInvisibleNodeQ(node: caracter)
        case "T":
            addInvisibleNodeT(node: caracter, bgColor: bgColor)
        case "X":
            addInvisibleNodeX(node: caracter, bgColor: bgColor)
        case "Y":
            addInvisibleNodeY(node: caracter, bgColor: bgColor)
        case "Z":
            addInvisibleNodeZ(node: caracter, bgColor: bgColor)
        default:
            break
        }
    }
    
    //MARK: Specific functions that add the node to each font.
    static func addInvisibleNodeA(node: SKLabelNode, bgColor: UIColor) {
        
        let triangle = SKShapeNode()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -(node.frame.width/3.6), y: 0.0))
        path.addLine(to: CGPoint(x: (node.frame.width/3.6), y: 0.0))
        path.addLine(to: CGPoint(x: 0.0, y: node.frame.height * 0.825))
        triangle.path = path.cgPath
        triangle.lineWidth = 0.0
        triangle.strokeColor = .clear
        triangle.fillColor = bgColor
        node.addChild(triangle)
    }
    
    static func addInvisibleNodeC(node: SKLabelNode, bgColor: UIColor) {
        let x = -(node.frame.width*0.485)
        let y = -(node.frame.height*0.02)
        let width = node.frame.width * 0.98
        let heigth = node.frame.height * 0.5
        let shape = SKShapeNode(rect: CGRect(x: x, y: y, width: width, height: heigth))
        shape.fillColor = bgColor
        shape.strokeColor = .clear
        node.addChild(shape)
    }
    
    static func addInvisibleNodeRetangle(node: SKLabelNode, bgColor: UIColor) {
        
        let x = -(node.frame.width*0.44)
        let y = -(node.frame.height * 0.1)
        let width = node.frame.width * 0.35
        let shape = SKShapeNode(rect: CGRect(x: x, y: y, width: width, height: node.frame.height * 1.1))
        shape.fillColor = bgColor
        shape.strokeColor = .clear
        node.addChild(shape)
    }
    
    static func addInvisibleNodeRetangleJ(node: SKLabelNode, bgColor: UIColor) {
        
        let x = -(node.frame.width*0.5)
        let y = -(node.frame.height*0.1)
        let width = node.frame.width * 0.6
        let shape = SKShapeNode(rect: CGRect(x: x, y: y, width: width, height: node.frame.height * 1.1))
        shape.fillColor = bgColor
        shape.strokeColor = .clear
        node.addChild(shape)
    }
    
    static func addInvisibleNodeG(node: SKLabelNode, bgColor: UIColor) {
        
        let x = node.frame.width * 0.03
        let y = -(node.frame.height * 0.04)
        let width = node.frame.width * 0.5
        let shape = SKShapeNode(rect: CGRect(x: x, y: y, width: width, height: node.frame.height*0.55))
        shape.fillColor = bgColor
        shape.strokeColor = .clear
        node.addChild(shape)
    }
    
    static func addInvisibleNodeH(node: SKLabelNode, bgColor: UIColor) {
        
        let x = -(node.frame.width * 0.225)
        let y = -(node.frame.height*0.1)
        let width = node.frame.width * 0.45
        let shape = SKShapeNode(rect: CGRect(x: x, y: y, width: width, height: node.frame.height * 1.1))
        shape.fillColor = bgColor
        shape.strokeColor = .clear
        node.addChild(shape)
    }
    
    static func addInvisibleNodeI(node: SKLabelNode, bgColor: UIColor) {
        
        let x = -(node.frame.width*0.35)
        let y = node.frame.height*0.5
        let width = node.frame.width
        let shape = SKShapeNode(rect: CGRect(x: x, y: y, width: width * 1.3, height: node.frame.height*0.5))
        shape.fillColor = bgColor
        shape.strokeColor = .clear
        node.addChild(shape)
    }
    
    static func addInvisibleNodeL(node: SKLabelNode, bgColor: UIColor) {
        
        let x = -(node.frame.width * 0.5)
        let y = node.frame.height*0.19
        let width = node.frame.width * 1
        let shape = SKShapeNode(rect: CGRect(x: x, y: y, width: width, height: node.frame.height*0.82))
        shape.fillColor = bgColor
        shape.strokeColor = .clear
        node.addChild(shape)
        
    }
    
    static func addInvisibleNodeM(node: SKLabelNode, bgColor: UIColor) {
        
        let xOne = -(node.frame.width * 0.45)
        let xTwo = (node.frame.width * 0.20)
        let y = -(node.frame.height * 0.1)
        let width = node.frame.width * 0.255
        let shapeOne = SKShapeNode(rect: CGRect(x: xOne, y: y, width: width, height: node.frame.height*1.1))
        let shapeTwo = SKShapeNode(rect: CGRect(x: xTwo, y: y, width: width, height: node.frame.height*1.1))
        
        shapeOne.fillColor = bgColor
        shapeOne.strokeColor = .clear
        shapeTwo.fillColor = bgColor
        shapeTwo.strokeColor = .clear
        node.addChild(shapeOne)
        node.addChild(shapeTwo)
        
    }
    
    static func addInvisibleNodeN(node: SKLabelNode, bgColor: UIColor) {
        
        let xOne = -(node.frame.width * 0.4)
        let xTwo = (node.frame.width * 0.15)
        let y = -(node.frame.height * 0.1)
        let width = node.frame.width * 0.29
        let shapeOne = SKShapeNode(rect: CGRect(x: xOne, y: y, width: width, height: node.frame.height*1.1))
        let shapeTwo = SKShapeNode(rect: CGRect(x: xTwo, y: y, width: width, height: node.frame.height*1.1))
        
        shapeOne.fillColor = bgColor
        shapeOne.strokeColor = .clear
        shapeTwo.fillColor = bgColor
        shapeTwo.strokeColor = .clear
        node.addChild(shapeOne)
        node.addChild(shapeTwo)
        
    }
    
    static func addInvisibleNodeQ(node: SKLabelNode) {
        node.text = "O"
    }
    
    static func addInvisibleNodeT(node: SKLabelNode, bgColor: UIColor) {
        
        let x = -(node.frame.width * 0.5)
        let y = -(node.frame.height*0.1)
        let width = node.frame.width * 1
        let shape = SKShapeNode(rect: CGRect(x: x, y: y, width: width, height: node.frame.height*0.9))
        shape.fillColor = bgColor
        shape.strokeColor = .clear
        node.addChild(shape)
        
    }
    
    static func addInvisibleNodeX(node: SKLabelNode, bgColor: UIColor) {
        
        let x = -(node.frame.width*0.485)
        let y = (node.frame.height*0.5)
        let width = node.frame.width * 0.98
        let heigth = node.frame.height * 0.5
        let shape = SKShapeNode(rect: CGRect(x: x, y: y, width: width, height: heigth))
        shape.fillColor = bgColor
        shape.strokeColor = .clear
        node.addChild(shape)
        
    }
    
    static func addInvisibleNodeY(node: SKLabelNode, bgColor: UIColor) {
        
        let triangle = SKShapeNode()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: node.frame.width * 0.13, y: node.frame.height * 0.35))
        path.addLine(to: CGPoint(x: -(node.frame.width*0.225), y: node.frame.height))
        path.addLine(to: CGPoint(x: node.frame.width*0.5, y: node.frame.height))
        triangle.path = path.cgPath
        triangle.strokeColor = .clear
        triangle.fillColor = bgColor
        node.addChild(triangle)
        
    }
    
    static func addInvisibleNodeZ(node: SKLabelNode, bgColor: UIColor) {
        
        let x = -(node.frame.width * 0.5)
        let y = (node.frame.height*0.18)
        let heigth = node.frame.height * 0.64
        let shape = SKShapeNode(rect: CGRect(x: x, y: y, width: node.frame.width, height: heigth))
        shape.fillColor = bgColor
        shape.strokeColor = .clear
        node.addChild(shape)
        
    }
    
}
