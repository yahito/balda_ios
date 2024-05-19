//
//  Game.swift
//  balda-2
//
//  Created by Andrey on 23/09/2023.
//

import Foundation
import AudioToolbox

enum Level: String, Decodable, Encodable, CaseIterable {
    case EASY = "Easy"
    case MEDIUM = "Medium"
    case HARD = "Hard"
    
    var tag: String {
     switch self {
     case .EASY:
         return "easy"
     case .MEDIUM:
         return "medium"
     
    case .HARD:
        return "hard"
    }
 }
}

enum Lang: String, Decodable, Encodable, CaseIterable {
    case RUS = "Русский"
    case NL = "Nederlands"
    
    var languageCode: String {
         switch self {
         case .RUS:
             return "ru"
         case .NL:
             return "nl"
         }
     }
}

enum Size: String, Decodable, Encodable, CaseIterable {
    case FIVE = "5x5"
    case SEVEN = "7x7"
    case NINE = "9x9"
    
    func getGridSize() -> Int {
        switch self {
        case .FIVE:
            return 5
        case .SEVEN:
            return 7
        case .NINE:
            return 9
        }
    }
}

class Game {
    
    
    var state: GameGridState
    var view: GridView
    var opponent1: Opponent? = nil
    var opponent2: Opponent? = nil
    
    var currentOpponent: Opponent? = nil
    
    var uncommited: [[Character]]? = nil
    
    var allowUncommited: Bool = false

    init(_ state: GameGridState, _ view: GridView) {
        self.view = view
        self.state = state
        self.opponent1 = LocalOpponent(game: self)
        self.opponent2 = CompOpponent(game: self, level: state.level)
        
        if state.turn == 0 {
            self.currentOpponent = self.opponent1
        } else {
            self.currentOpponent = self.opponent2
        }
        
        NotificationCenter.default.post(name: .opponentChanged, object: nil, userInfo: ["local": currentOpponent is LocalOpponent, "lang": state.lang.languageCode])
    }

    
    subscript(row: Int, column: Int) -> Character {
        get {
            return state.grid[row][column]
        }
        set {
            if allowUncommited && uncommited == nil {
                uncommited = state.grid
            }
            state.grid[row][column] = newValue
            self.view.game = self
        }
    }
    
    public func setLetter(_ row: Int, _ column: Int, _ newValue: Character) {
        if (!Constants.isLetterPlaceholder(state.grid[row][column])) {
            return
        }
        if allowUncommited && uncommited == nil {
            uncommited = state.grid
        }
        
        setLetterToCell((row, column), newValue, &state.grid)
        
        self.view.game = self
    }
    
    public func setBomb(_ row: Int, _ column: Int) {
        if (!Constants.isLetterPlaceholder(state.grid[row][column])) {
            return
        }
        
        if allowUncommited && currentOpponent?.bomb == nil {
            currentOpponent?.bomb = (row, column)
        }
    
    }
    
    
    public func move() {
        let gridSize = state.size.getGridSize()
        if state.getTotalWords() == ((gridSize * (gridSize - 1))) {
            finishGame()
            return
        }
        
        NotificationCenter.default.post(name: .opponentChanged, object: nil, userInfo: ["local": currentOpponent is LocalOpponent, "lang": state.lang.languageCode])
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.currentOpponent!.nextStep()
        }
    }
    
    public func skipStep() {
        if state.turn == 0 {
            state.turn = 1
        } else {
            state.turn = 0
        }
        
        currentOpponent = getOther(currentOpponent!)
        move()
    }

    public enum GAME_RESULT {
        case LOCAL_WIN
        case LOCAL_LOOSE
        case TIE
    }
    
    public func noIdea(_ opponent: Opponent) {
        if (getOpponentIndex(opponent) == 1) {
            state.noIdea1 = true
        } else if (getOpponentIndex(opponent) == 2) {
            state.noIdea2 = true
        }
        
        if (state.noIdea1 && state.noIdea2) {
            finishGame()
            return
        }
        
        
        skipStep()
    }
    
    func finishGame() {
        let winner = state.winner();
        var result = GAME_RESULT.TIE
        if winner != 0 {
            if (getOpponent(winner) is LocalOpponent) {
                result = .LOCAL_WIN
            } else {
                result = .LOCAL_LOOSE
            }
        }
        NotificationCenter.default.post(name: .gameFinished, object: nil, userInfo: ["winner": result, "lang": state.lang.languageCode]);
    }
    
    fileprivate func getOpponentIndex(_ opponent: Opponent) -> Int {
        return opponent === self.opponent1 ? 1:2
    }
    
    fileprivate func getOpponent(_ opponentId: Int) -> Opponent {
        return opponentId == 1 ? opponent1! : opponent2!
    }
    
    public func finishStep(_ opponent: Opponent, _ points: [(Int, Int)], _ word: String, _ bombc: (Int, Int)?) {
        allowUncommited = true
        for i in 0..<word.count {
            let p = points[i]
            if state.grid[p.0][p.1] == Constants.question_char {
                setLetter(p.0, p.1, word[i].last!)
                break
            }
        }
        
        
        if checkBomb(opponent, points) == Result.BOMB {
            view.setBomb(getOther(opponent).bomb!)
        } else {
            NotificationCenter.default.post(name: .wordChanged, object: nil, userInfo: ["word": word]);
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.view.setCellsToHighlight(points, { bomb in
                if bomb {
                    self.state.addWord(word, self.getOpponentIndex(opponent), true)
                    self.resetStep()
                    self.view.endLocalInput()
                    self.skipStep()
                } else {
                    self.finishStep(opponent, word, points, bombc)
                }
            }, true);
        }
    }
    
    public func resetAndSkipStep() {
        if !(currentOpponent is LocalOpponent) {
            return;
        }
        
        view.cancelSelection()
        resetStep()
        noIdea(currentOpponent!)
    }
    
    public func resetStep() {
        if (uncommited != nil) {
            state.grid = uncommited!
            
            uncommited = nil
            
            currentOpponent?.bomb = nil
            getOther(currentOpponent!).bomb = nil
            view.game = self
        }
    }
    
    public func checkBomb(_ opponent: Opponent, _ cells: [(Int, Int)]) -> Result {
        let b = self.getOther(opponent).bomb
        
        if b != nil {
            if !cells.filter { $0 == b! }.isEmpty {
                return Result.BOMB
            }
        }
        
        return Result.OK
    }
    
    func setLetterToCell(_ cell: (Int, Int), _ char: Character, _ table: inout [[Character]]) {
    
        
        var x = cell.0
        var y = cell.1
        
        var matrixSize = table.count
        
        if (y > 0 && table[x][y - 1] == Constants.init_char) {
            table[x][y - 1] = Constants.question_char;
        }
        
        if (x > 0 && table[x - 1][y] == Constants.init_char) {
            table[x - 1][y] = Constants.question_char;
        }
        
        if (x < matrixSize - 1 && table[x + 1][y] == Constants.init_char) {
            table[x + 1][y] = Constants.question_char;
        }
        
        if (y < matrixSize - 1 && table[x][y + 1] == Constants.init_char) {
            table[x][y + 1] = Constants.question_char;
        }
        table[x][y] = char
        
        
    }
    
    public func finishStep(_ opponent: Opponent, _ word: String, _ cells: [(Int, Int)], _ bomb: (Int, Int)?) {
        
        if (getOpponentIndex(opponent) == 1) {
            state.noIdea1 = false
        } else if (getOpponentIndex(opponent) == 2) {
            state.noIdea2 = false
        }
        
        self.view.endLocalInput()
        
        state.addWord(word, opponent === opponent1 ?1:2, false)
        
        var table: [[Character]] = state.grid
        for i in 0..<word.count {
            setLetterToCell(cells[i], word[i].last!, &table)
        }
        self.state.grid = table
        self.view.game = self
        
        opponent.bomb = bomb
        opponent.incrementScore(increment: word.count)
        
        allowUncommited = false
        uncommited = nil
        
        skipStep()
    }
    
    public func __finishStep() -> Result {
        if !(currentOpponent is LocalOpponent) {
            return Result.NONE
        }
        guard let result = view.returnSelectedValues() else {
            return Result.NOTHING_SELECTED
        }
        
        let word = result.0
        let cells = result.1
        let bomb = result.2
        
        
        if (self.uncommited != nil && word != "") {
            if (!self.state.containsWord(word)) {
                if (currentOpponent!.results(word)) {
                    if checkBomb(currentOpponent!, cells) == Result.BOMB {
                        view.fireBomb(getOther(currentOpponent!).bomb!, { 
                            self.resetStep()
                            self.skipStep()
                        })
                       
                        return Result.BOMB
                    }
                    finishStep(currentOpponent!, word, cells, bomb)
                } else {
                    

                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    
                    view.setCellsToHighlight(view.getHiglightedCells().reversed(),
                                             { bomb in
                        self.cancelSelection()
                        
                    }, false)
                 
                    return Result.NONE
                }
            } else {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                
                view.setCellsToHighlight(view.getHiglightedCells().reversed(),
                                         { bomb in
                    self.cancelSelection()
                    
                }, false)
                
                return Result.DUPLICATE
            }
        }
        
        return Result.OK;
    }
    
    public func localInput(_ opponent: Opponent) {
        allowUncommited = true
        self.view.localInput(opponent.score >= 0)
    }
    
    public func save(_ encoder: JSONEncoder) -> Data? {
        do {
            let data = try encoder.encode(state)
            return data
        } catch {
            print("Error encoding person: \(error)")
        }
        return nil
    }
    
    private func getOther(_ opponent: Opponent) -> Opponent {
        if opponent === self.opponent1 {
            return self.opponent2!;
        }
        
        return self.opponent1!;
    }
    
    func getInfo() -> Info {
        return Info(
            OpponentInfo(state.name1, state.words1, state.score1, state.fail1),
            OpponentInfo(state.name2, state.words2, state.score2, state.fail2)
        )
    }
    
    func getRandomName() -> String {
        let names = ["Молния", "Искра", "Тень", "Робот", "Стрела"]
        let randomIndex = Int.random(in: 0..<names.count)
        return names[randomIndex]
    }
    
    func cancelSelection() {
        if !(currentOpponent is LocalOpponent) {
            return
        }
        
        view.cancelSelection()
    }
    
    func isAlphabetCharacter(_ letterChar: Character) -> Bool {
        return Words.isAlphabetCharacter(letterChar, state.level, state.lang)
    }
    
    func getAlphabet() -> String {
        return Words.getAlphabet(state.level, state.lang);
    }

}


@objc public enum Result: Int {
    case OK
    case NOT_FOUND
    case BOMB
    case ERROR
    case DUPLICATE
    case NONE
    case NOTHING_SELECTED
}


public class Info {
    let opponentInfo1: OpponentInfo;
    let opponentInfo2: OpponentInfo;
    
    init(_ opponentInfo1: OpponentInfo, _ opponentInfo2: OpponentInfo) {
        self.opponentInfo1 = opponentInfo1
        self.opponentInfo2 = opponentInfo2
    }
}

public class OpponentInfo {
    let name: String
    let words: [String]
    let score: Int
    let fails: [Int]
    
    init(_ name: String, _ words: [String], _ score: Int, _ fails: [Int]) {
        self.name = name
        self.words = words
        self.score = score
        self.fails = fails
    }
}

extension Notification.Name {
    static let opponentChanged = Notification.Name("opponentChanged")
    static let gameFinished = Notification.Name("gameFinished")
    static let wordChanged = Notification.Name("wordChanged")
    static let showKeyboard = Notification.Name("showKeyboard")
}
