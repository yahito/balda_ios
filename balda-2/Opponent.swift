//
//  Opponent.swift
//  balda-2
//
//  Created by Andrey on 01/10/2023.
//

import Foundation

class Opponent {
    var score: Int = 0
    var bomb: (Int, Int)?
    
    func nextStep(){}
    
    func results(_ word: String) -> Bool {
        return false
    }
    
    func incrementScore(increment: Int) {
        score += increment
    }
    
    func decrementScore(decrement: Int) {
        score -= decrement
    }
}
