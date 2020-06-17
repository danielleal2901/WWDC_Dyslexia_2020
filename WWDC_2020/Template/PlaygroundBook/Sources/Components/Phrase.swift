//
//  Phrase.swift
//  Projeto_WWDC
//
//  Created by Daniel Leal on 20/03/20.
//  Copyright © 2020 Daniel Leal. All rights reserved.
//

import Foundation

/**
    Class that has an array of Lines, and is responsible for managing those lines.
*/

class Phrase {
    
    private var _lines = [Line]()
    public var lines : [Line] {
        get {
            return self._lines
        }
    }
    
    init(lines: [Line]) {
        self._lines = lines
    }
    
    func addLine(line: Line){
        if (!self.lines.contains(line)){
            self._lines.append(line)
        }else {
            print("Line has already been added")
        }
    }
    
    func removeLine(line: Line){
        self._lines.removeAll { ($0 == line)}
    }
    
}
