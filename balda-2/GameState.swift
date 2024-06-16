//
//  GameState.swift
//  balda-2
//
//  Created by Andrey on 06/10/2023.
//

import Foundation


class GameGridState: Codable {
    var grid: [[Character]]
    var turn: Int
    private var words: [String] = []
    var words1: [String] = []
    var fail1: [Int] = []
    var score1: Int = 0
    var words2: [String] = []
    var fail2: [Int] = []
    var score2: Int = 0
    var level: Level
    var lang: Lang
    var noIdea1: Bool = false
    var noIdea2: Bool = false
    var size: Size
    var name1: String
    var name2: String
    var block: Bool = false
    
    var userPic1 = UserPic.allCases[Int.random(in: 0..<UserPic.allCases.count)]
    var userPic2 = UserPic.allCases[Int.random(in: 0..<UserPic.allCases.count)]

    init(_ str: String, _ size: Size, _ turn: Int, _ level: Level, _ lang: Lang, _ name: String, _ pic: UserPic) {
        words.append(str)
        
        let gridSize = size.getGridSize()
        
        grid = Array(repeating: Array(repeating: Constants.init_char, count: gridSize), count: gridSize)
        let length = str.count
        let half = gridSize >> 1;
        
        for i in 0..<length {
            grid[half][i] = str[i].first!
            grid[half - 1][i] = Constants.question_char;
            grid[half + 1][i] = Constants.question_char;
        }
        
        self.turn = turn
        self.level = level
        self.lang = lang
        self.size = size
        self.name2 = GameGridState.getRandomName()
        self.name1 = name
        self.userPic1 = pic
        self.userPic2 = getOtherPic(userPic1)
    }
    
    func getOtherPic(_ pic: UserPic) -> UserPic {
        var newUserPic: UserPic?
        
        while (newUserPic == nil || newUserPic == pic) {
            newUserPic = UserPic.allCases[Int.random(in: 0..<UserPic.allCases.count)]
        }
        
        return newUserPic!
    }
    
    private static func getRandomName() -> String {
        let names = ["Молния", "Искра", "Тень", "Робот", "Стрела"]
        let randomIndex = Int.random(in: 0..<names.count)
        return names[randomIndex]
    }
    
    func addWord(_ word: String, _ opponentId: Int, _ fail: Bool) {
        if opponentId == 1 {
            self.words1.append(word)
            if fail {
                fail1.append(words1.count - 1)
            } else {
                score1 += word.count
            }
        } else {
            self.words2.append(word)
            
            if fail {
                fail2.append(words2.count - 1)
            } else {
                score2 += word.count
            }
        }
        self.words.append(word)
    }
    
    func getTotalWords() -> Int {
        return words1.count + words2.count - fail1.count - fail2.count
    }
    
    func containsWord(_ word: String) -> Bool {
        return words.contains(word)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode the words array
        words = try container.decode([String].self, forKey: .words)
        words1 = try container.decode([String].self, forKey: .words1)
        words2 = try container.decode([String].self, forKey: .words2)
        
        // Decode the grid as a 2D array of strings and then convert to [[Character]]
        let stringGrid = try container.decode([[String]].self, forKey: .grid)
        grid = stringGrid.map { $0.map { $0.first! } }
        
        turn = try container.decode(Int.self, forKey: .turn)
        
        level = try container.decode(Level.self, forKey: .level)
        
        noIdea1 = try container.decode(Bool.self, forKey: .noIdea1)
        
        noIdea2 = try container.decode(Bool.self, forKey: .noIdea2)
        
        score1 = try container.decode(Int.self, forKey: .score1)
        
        score2 = try container.decode(Int.self, forKey: .score2)
        
        lang = try container.decode(Lang.self, forKey: .lang)
        
        fail1 = try container.decode([Int].self, forKey: .fail1)
        
        fail2 = try container.decode([Int].self, forKey: .fail2)
        
        fail2 = try container.decode([Int].self, forKey: .fail2)
        
        size = try container.decode(Size.self, forKey: .size)
        
        name2 = try container.decode(String.self, forKey: .name2)
        
        name1 = try container.decode(String.self, forKey: .name1)
        
        userPic1 = try container.decode(UserPic.self, forKey: .userPic1)
        
        userPic2 = try container.decode(UserPic.self, forKey: .userPic2)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode the words array
        try container.encode(words, forKey: .words)
        try container.encode(words1, forKey: .words1)
        try container.encode(words2, forKey: .words2)
        
        // Convert the grid to a 2D array of strings and then encode
        let stringGrid = grid.map { $0.map { String($0) } }
        try container.encode(stringGrid, forKey: .grid)
        
        try container.encode(turn, forKey: .turn)
        
        try container.encode(level, forKey: .level)
        
        try container.encode(noIdea1, forKey: .noIdea1)
        
        try container.encode(noIdea2, forKey: .noIdea2)
        
        try container.encode(score1, forKey: .score1)
        
        try container.encode(score2, forKey: .score2)
        
        try container.encode(lang, forKey: .lang)
        
        try container.encode(fail1, forKey: .fail1)
        try container.encode(fail2, forKey: .fail2)
        
        try container.encode(size, forKey: .size)
        
        try container.encode(name2, forKey: .name2)
        
        try container.encode(name1, forKey: .name1)
        
        try container.encode(userPic1, forKey: .userPic1)
        try container.encode(userPic2, forKey: .userPic2)

    }
    
    func winner() -> Int {
        if score1 > score2 {
            return 1
        } else if score2 > score1 {
            return 2
        }
        
        return 0
    }
     
     enum CodingKeys: String, CodingKey {
         case grid
         case words
         case turn
         case words1
         case words2
         case level
         case noIdea1
         case noIdea2
         case score1
         case score2
         case lang
         case fail1
         case fail2
         case size
         case name1
         case name2
         case userPic1
         case userPic2
     }
}
