//
//  Opponent.swift
//  balda-2
//
//  Created by Andrey on 30/09/2023.
//

import Foundation


class CompOpponent: Opponent {
    override func results(_ word: String) -> Bool {
        return true
    }
    
    
    private let game: Game
    private let level: Level
    
    
    init(game: Game, level: Level) {
        self.game = game
        self.level = level
    }
    
    private func search(_ min: Int, _ max: Int) -> SearchResult? {
        let isPalindrome2: (String) -> Bool = { word in
            return !self.game.state.containsWord(word) && word.count >= min && word.count <= max
        }
        
        let isPalindrome: (String) -> String? = { word in
            var w = String(word)
            let res =  Words.findWordByPattern(&w, isPalindrome2, self.level, self.game.state.lang)
            if (res) {
                return w
            }
            return nil
            
        }
            
        return Search.search(game.state.grid, max, isPalindrome)
    }
    
        
    override public func nextStep() {
            
        var ress: SearchResult?;
        if level != .EASY {
            ress = search(5, 8)
        }
        
        if ress == nil || ress!.getWord() == nil {
            ress = search(2, 4)
        }
    
        let grid = game.state.grid
        
        var possible: [(Int, Int)] = []
        
        for i in 0..<grid.count {
            for j in 0..<grid[i].count {
                if (grid[i][j] == Constants.question_char) {
                    possible.append((i,j))
                }
            }
        }
    
        DispatchQueue.main.async {
            let bomb: (Int, Int)? = nil; //possible.randomElement()
            
            if ress != nil && ress!.getWord() != nil {
                let last = ress!.getWord()!
                self.game.finishStep(self, ress!._getPoints(), ress!.getWord()!, bomb)
            } else {
                self.game.noIdea(self)
            }
            
        }
            
    }
    
}
