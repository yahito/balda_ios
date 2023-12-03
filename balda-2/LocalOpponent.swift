//
//  LocalOpponent.swift
//  balda-2
//
//  Created by Andrey on 01/10/2023.
//

import Foundation

class LocalOpponent: Opponent {
    let game: Game
    
    init(game: Game) {
        self.game = game
    }
    
    override func nextStep() {
        self.game.localInput(self)
    }
    
    override func results(_ word: String) -> Bool {
        let isPalindrome: (String) -> Bool = { __word in
            return __word == word
        }
        
        var _word = String(word)
        if (Words.findWordByPattern(&_word, isPalindrome, .HARD, game.state.lang)) {
            return true
        }
        return false
    }
}
