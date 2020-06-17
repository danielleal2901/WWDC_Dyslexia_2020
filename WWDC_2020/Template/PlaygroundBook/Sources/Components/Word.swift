//
//  Word.swift
//  Projeto_WWDC
//
//  Created by Daniel Leal on 20/03/20.
//  Copyright © 2020 Daniel Leal. All rights reserved.
//

import Foundation
import SpriteKit

enum WordState {
    case enabled
    case hidden
}

/**
    Class that has an array of letters and is used to manage the letters.
*/

class Word {
    
    private var _letters = [Letter]()
    public var letters : [Letter] {
        get {
            return self._letters
        }
        set {
            self._letters = newValue
        }
    }
    
    private var _state: WordState
    public var state: WordState {
        get {
            return self._state
        }
    }

    init(letters: [Letter]) {
        self._letters = letters
        self._state = .enabled
    }
    
    func addLetter(letter: Letter){
        if (!self.letters.contains(letter)){
            self._letters.append(letter)
        }else {
            print("Letter has already been added")
        }
    }
    
    func removeLetter(letter: Letter){
        self._letters.removeAll { ($0 == letter)}
    }
    
    func addAlpha() {
        for letter in self.letters {
            letter.setAlphaEnabled()
        }
        self._state = .enabled
    }
    
    func removeAlpha() {
        for letter in self.letters {
            letter.setAlphaClear()
        }
        self._state = .hidden
    }
    
}

extension Word : Equatable {
    static func == (lhs: Word, rhs: Word) -> Bool {
        return lhs.letters == rhs.letters
    }
}
