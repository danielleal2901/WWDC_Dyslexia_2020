//
//  Line.swift
//  Projeto_WWDC
//
//  Created by Daniel Leal on 21/03/20.
//  Copyright © 2020 Daniel Leal. All rights reserved.
//

import Foundation
import SpriteKit

/**
    Class that has an array of Word, and is used to manage the Words.
*/
class Line {
    
    private var _words = [Word]()
    public var words : [Word] {
        get {
            return self._words
        }
    }

    init() {
        
    }
    
    init(words: [Word]) {
        self._words = words
    }
    
    func addWord(word: Word) {
        if (!self.words.contains(word)){
            self._words.append(word)
        }else {
            print("Word has already been added")
        }
    }
    
    func removeWord(word: Word){
        self._words.removeAll { ($0 == word)}
    }
    
}

extension Line: Equatable {
    static func == (lhs: Line, rhs: Line) -> Bool {
        return lhs.words == rhs.words
    }
}
