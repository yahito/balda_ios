//
//  Search.swift
//  balda-2
//
//  Created by Andrey on 27/09/2023.
//

import Foundation


import Foundation

public class Search {
    
    private static var random = Dict.randomGen()
    private static let DIRECTIONS = [
        (0, 1),   // Right
        (1, 0),   // Down
        (0, -1),  // Left
        (-1, 0),  // Up
    ]
    
    public static func search(_ matrix: [[Character]], _ max: Int, _ sink: (String) -> String?) -> SearchResult? {
        let xOrder = randomInts(limit: matrix.count, count: matrix.count)
        let yOrder = randomInts(limit: matrix.count, count: matrix.count)
         
        for k in 0..<matrix.count {
            for d in 0..<matrix[0].count {
                let i = xOrder[k]
                let j = yOrder[d]
                
                if matrix[i][j] != Constants.init_char {
                    var current = ""
                    var points: [Point] = []
                    points.append(Point(x: i, y: j))
                    
                    var xx = Array(repeating: Array(repeating: false, count: matrix[0].count), count: matrix.count)
                    let searchResult = dfs(matrix: matrix, i: i, j: j, current: &current, visited: &xx, sink: sink, has: false, points: &points, max: max)
                    if let result = searchResult {
                        return result
                    }
                }
            }
        }
        return nil
    }
    
    private static func dfs(matrix: [[Character]], i: Int, j: Int, current: inout String, visited: inout [[Bool]], sink: (String) -> String?, has: Bool, points: inout [Point], max: Int) -> SearchResult? {
        if !isValid(row: i, col: j, rows: matrix.count, cols: matrix[0].count, matrix: matrix) || visited[i][j] || current.count > matrix.count * matrix[0].count || points.count > max {
            return nil
        }

        var _has = has
        
        if Constants.isLetterPlaceholder(matrix[i][j]) {
            if has {
                return nil
            } else {
                _has = true
            }
        }
        current.append(matrix[i][j])

        visited[i][j] = true

        for dir in DIRECTIONS {
            // Check to avoid reverse paths
            let newRow = i + dir.0
            let newCol = j + dir.1
            if isValid(row: newRow, col: newCol, rows: matrix.count, cols: matrix[0].count, matrix: matrix) && !visited[newRow][newCol] {
                points.append(Point(x: newRow, y: newCol))
                if let searchResult = dfs(matrix: matrix, i: newRow, j: newCol, current: &current, visited: &visited, sink: sink, has: _has, points: &points, max: max) {
                    return searchResult
                }
                points.removeLast()
            }
        }

        if isValidSubstring(current) {
            let lastLetter = Constants.isLetterPlaceholder(current.last!)
            
            var w = sink(current)
            if w != nil {
                print("pattern: \(current)")
                return SearchResult(word: w!, points: points, lastLetter: lastLetter)
            }
        }

        visited[i][j] = false
        current.removeLast()
        return nil
    }
    
    private static func isValid(row: Int, col: Int, rows: Int, cols: Int, matrix: [[Character]]) -> Bool {
        return row >= 0 && row < rows && col >= 0 && col < cols && matrix[row][col] != Constants.init_char
    }
    
    private static func isValidSubstring(_ substring: String) -> Bool {
        return substring.count > 1 && substring.filter { Constants.isLetterPlaceholder($0) }.count == 1
    }

    private static func randomInts(limit: Int, count: Int) -> [Int] {
        var uniqueNumbers = Set<Int>()
        while uniqueNumbers.count < count {
            uniqueNumbers.insert(Int(random.next() % UInt64(limit)))
        }
        return Array(uniqueNumbers)
    }
}

public class SearchResult {
    private let word: String?
    private let points: [Point]  // Assuming you have a Point class in Swift
    private let lastLetter: Bool

    init(word: String, points: [Point], lastLetter: Bool) {
        self.word = word
        self.points = points
        self.lastLetter = lastLetter
    }

    func getWord() -> String? {
        return word
    }

    func getPoints() -> [Point] {
        return points
    }
    
    func _getPoints() -> [(Int, Int)] {
        return points.map { Point in
            (Point.x, Point.y)
        }
    }

    func isLastLetter() -> Bool {
        return lastLetter
    }
}


class Point {
    // Define this Point class. Probably something like:
    var x: Int = 0
    var y: Int = 0
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

class GameState {
    // Define this class. You mentioned `GameState.init_char`, so this class should contain that property.
}
