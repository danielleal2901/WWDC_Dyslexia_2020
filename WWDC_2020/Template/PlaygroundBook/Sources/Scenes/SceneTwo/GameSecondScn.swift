//
//  GameFourthScn.swift
//  Book_Sources
//
//  Created by Daniel Leal on 26/03/20.
//

import Foundation
import SpriteKit

/**
    Class responsible for the logic of the second page scene.
*/
class GameSecondScn: GameLayer {
 
    // Timer and rigth words are not used
    var timer: Timer?
    var rigthWords: Int?
    
    //Delegate to call the scene functions
    weak var delegateLogicGame: ProtocolLogicScene?

    //Results
    var scoreOne: CGFloat = 0
    var scoreThree: CGFloat = 0
    var differenceOneAndThree: CGFloat!
    
    //Assistants
    var positionSubtitleOne : CGFloat = 0
    var canGoNextScene = false
     
    //Initially set the scene
    func setupScene() {
        setupResultsSceneOne()
        setupResultsSceneThree()
        setupDifferenceBetweenOneAndThree()
        
        setupTextOne()
        
    }
    
    //Receive and manage the scene's touches
    func touchesBegan(touchedNodes: [SKNode]) {
        if (canGoNextScene){
            self.sceneAnimateNewScene()
        }
    }
    
    //MARK: Game logic
    
    //Set the results of scene one.
    func setupResultsSceneOne() {
        guard let words = UserDefaults.standard.value(forKey: "PhraseOne_rightWords") as? Int else {return}
        guard var timer = UserDefaults.standard.value(forKey: "PhraseOne_timer") as? Int else {return}
        timer = 40 - timer
        scoreOne = Utils.calculateScore(words: words, timer: timer)
    }
    
    //Set the results of scene three.
    func setupResultsSceneThree() {
        guard let words = UserDefaults.standard.value(forKey: "PhraseThree_rightWords") as? Int else {return}
        guard var timer = UserDefaults.standard.value(forKey: "PhraseThree_timer") as? Int else {return}
        timer = 40 - timer
        scoreThree = Utils.calculateScore(words: words, timer: timer)
    }
    
    //Set the difference between the first and the third sentence
    func setupDifferenceBetweenOneAndThree ()  {
        if (scoreThree == 0){
            self.differenceOneAndThree = scoreOne/1
        }else {
            self.differenceOneAndThree = scoreOne/scoreThree
        }

    }
    
    //Set the first text of the scene.
    func setupTextOne () {
        
        let difference = String(format: "%.1f", Double(differenceOneAndThree))
        
        //First paragraph, aligned to the center
        let font = UIFont(name: "Helvetica-Bold", size: 30)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        //Second paragraph, with a greater distance from the first paragraph
        let paragraphStyle2 = NSMutableParagraphStyle()
        paragraphStyle2.alignment = .center
        paragraphStyle2.lineHeightMultiple = 1.5
        
        //Attributes of the first strings
        let firstAttributes: [NSAttributedString.Key: Any] = [
            .font: font!,
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle
        ]

        //Attributes of the last string
        let secondFont = UIFont(name: "Helvetica-Bold", size: 35)
        let secondAttributes: [NSAttributedString.Key: Any] = [
           .font: secondFont!,
           .foregroundColor: UIColor.white,
           .paragraphStyle: paragraphStyle2
        ]
        
        //Strings
        let firstString = NSMutableAttributedString(string: "Did you know that a person who has dyslexia ", attributes: firstAttributes)
        let secondString = NSAttributedString(string: "can have up to \(difference)x worse performance ", attributes: firstAttributes)
        let thirdString = NSAttributedString(string: "in reading and interpreting texts? Source: " , attributes: firstAttributes)
        let fourthString = NSAttributedString(string: "... According to your results, You.", attributes: secondAttributes)
        
        firstString.append(secondString)
        firstString.append(thirdString)
        firstString.append(fourthString)
        
        //Label of strings
        let labelOne = SKLabelNode()

        labelOne.numberOfLines = 4
        labelOne.preferredMaxLayoutWidth = 650
        labelOne.horizontalAlignmentMode = .center
        labelOne.verticalAlignmentMode = .center
        labelOne.attributedText = firstString

        //Informs the scene that can set the label.
        guard let delegate = self.delegateLogicGame as? ProtocolLogicSecondScene else {return}
        delegate.setupLabel(label: labelOne, paragraphOne: paragraphStyle, paragraphTwo: paragraphStyle2, completion: {
            self.setupEllipse(phrase: .First)
        })
        
    }
    
    //It receives an ellipse, the phrase it will represent and creates a label for it, in addition to notifying the scene that must add the label.
    func setupLabelEllipse(ellipse: SKSpriteNode, phrase: EnumPhrase)  {
        
        var value = 0
        var font = UIFont()
        var maxWidth:CGFloat = 0
        var string = String()
        switch phrase {
        case .First:
            value = Int(scoreOne)
            string = "No Dislexic "
            font = UIFont(name: "Helvetica-Bold", size: 198)!
            maxWidth = 2.5 * ellipse.size.width
        case .Third:
            value = Int(scoreThree)
            string = "Dislexic "
            font = UIFont(name: "Helvetica-Bold", size: 126)!
            maxWidth = 2.0 * ellipse.size.width
        default:
            break
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.firstLineHeadIndent = 5.0
        paragraphStyle.headIndent = 10
        
        let labelEllipse = SKLabelNode(fontNamed: "Helvetica-Bold")
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle
        ]
        
        labelEllipse.attributedText = NSAttributedString(string: string + String(value), attributes: attributes)
        labelEllipse.numberOfLines = 2
        labelEllipse.preferredMaxLayoutWidth = maxWidth
        labelEllipse.horizontalAlignmentMode = .center
        labelEllipse.verticalAlignmentMode = .center
        
        ellipse.addChild(labelEllipse)
        
        labelEllipse.position = CGPoint(x: 3 * (ellipse.size.width * 0.5), y: 3 * (ellipse.size.height * 0.5))

        
        guard let delegate = self.delegateLogicGame as? ProtocolLogicSecondScene else {return}
        
        switch phrase {
        case .First:
            delegate.setupEllipseOne(ellipseOne: ellipse) {
                self.setupEllipse(phrase: .Third)
            }
        case .Third:
           delegate.setupEllipseTwo(ellipseTwo: ellipse) {
                self.setupLabelNextScene()
           }
       default:
           break
       }

    }
    
    //Sets the ellipses according to the phrase they represent
    func setupEllipse(phrase: EnumPhrase){
        
        var ellipseNode = SKSpriteNode()
        var subtitleText = String()

        switch phrase {
        case .First:
            ellipseNode = SKSpriteNode(imageNamed: "Ellipse_NoDislexic.png")
            subtitleText = "First Phrase"
            positionSubtitleOne = 3 * (-ellipseNode.size.height * 0.025)
        case .Third:
            ellipseNode = SKSpriteNode(imageNamed: "Ellipse_Dislexic.png")
            subtitleText = "Third Phrase"
        default:
            break
        }
        
        ellipseNode.setScale(0.33)
        ellipseNode.anchorPoint = CGPoint(x: 0, y: 0)
        
        //Caption label
        let subtitleLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        subtitleLabel.text = subtitleText
        subtitleLabel.fontSize = 24 * 3.3
        subtitleLabel.verticalAlignmentMode = .center
        subtitleLabel.horizontalAlignmentMode = .center
        subtitleLabel.position = CGPoint(x: 3 * (ellipseNode.size.width * 0.5), y: positionSubtitleOne)
        subtitleLabel.alpha = 0.7
        
        ellipseNode.addChild(subtitleLabel)
        //Center label
        self.setupLabelEllipse(ellipse: ellipseNode, phrase: phrase)
    }
    
    //Set the label to "touch the screen to go to the next scene"
    func setupLabelNextScene() {
        let labelGoNextPage = SKLabelNode(fontNamed: "Helvetica-Bold")
        labelGoNextPage.text = "Tap to go to the next scene."
        labelGoNextPage.fontColor = Utils.UIColorFromRGB(rgbValue: 0x2E4D5F)
        labelGoNextPage.position = CGPoint(x: Constants.viewSize.width * 0.5, y: Constants.viewSize.height * 0.1)
        self.canGoNextScene = true
        
        guard let delegate = self.delegateLogicGame as? ProtocolLogicSecondScene else {return}
        delegate.setupLabelNextScene(label: labelGoNextPage)
    }
    
    // Calls the scene to make the animation moving on to the next scene
    func sceneAnimateNewScene(){
        self.canGoNextScene = false
        guard let delegate = self.delegateLogicGame as? ProtocolLogicSecondScene else {return}
        delegate.setupNewScene {
            self.setupNewScene()
        }
    }
    
    //Adds the new label for the new scene
    func setupNewScene() {
        let difference = String(format: "%.1f", Double(differenceOneAndThree))

        let font = UIFont(name: "Helvetica-Bold", size: 30)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        
        let firstAttributes: [NSAttributedString.Key: Any] = [
            .font: font!,
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle
        ]
        
        let firstString = NSMutableAttributedString(string: "Perhaps this difference may not even matter to you now, But have you ever imagined trying to take a bus / subway, taking \(difference) times longer to read the number or the destination? Or have you ever imagined yourself on the road, driving fast, and then you need to read a sign such as: “go back you are going the wrong way”, would you be able to read, for example at 74 mph, needing \(difference) more time ?. There are several situations in which these people will have difficulties, so it is up to us to understand their point of view, so that we are aware and always willing to help.", attributes: firstAttributes)
        
        let label = SKLabelNode()
        label.numberOfLines = 15
        label.preferredMaxLayoutWidth = Constants.viewSize.width * 0.5
        label.horizontalAlignmentMode = .right
        label.verticalAlignmentMode = .center
        label.attributedText = firstString
        
        let thanksLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        thanksLabel.text = "Thank you!"
        thanksLabel.fontSize = 66
        thanksLabel.position = CGPoint(x: -label.frame.width * 0.5, y: -label.frame.height * 0.9)
        thanksLabel.fontColor = Utils.UIColorFromRGB(rgbValue: 0x2E4D5F)
        thanksLabel.horizontalAlignmentMode = .center
        thanksLabel.verticalAlignmentMode = .center
        thanksLabel.alpha = 0
        
        thanksLabel.run(SKAction.wait(forDuration: 20.0)) {
            thanksLabel.alpha = 1
        }
        
        label.addChild(thanksLabel)
        
        guard let delegate = self.delegateLogicGame as? ProtocolLogicSecondScene else {return}
        delegate.addNewSceneLabel(label: label)

    }
    
    
}
