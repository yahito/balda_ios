//
//  Words.swift
//  balda-2
//
//  Created by Andrey on 27/09/2023.
//

import Foundation
import UIKit


class Dict {
    var alphabet: String
    var data: Data
    var charToIndex: [Character: Int] = [:]
    var indexToChar: [Int : Character] = [:]
    
    init(_ resourceName: String, _ rus: Bool) {
        guard let dataAsset = NSDataAsset(name: resourceName) else {
            fatalError("Failed to find data asset: trie")
        }
        
        data = dataAsset.data
        
        if (rus) {
            alphabet = "АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ"
        } else {
            alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        }
        
        for (index, char) in alphabet.enumerated() {
            charToIndex[char] = index
        }
        
        for (index, char) in alphabet.enumerated() {
            indexToChar[index] = char
        }
        
    }
    
    func findRandomWord(_ buffer: inout String, _ length: Int) -> Bool {
        var numGenerator = SystemRandomNumberGenerator()
        buffer.removeAll()
        var currPos = 0
        
        
        for i in 0..<length {
            let size: Int

            size = Int(data[currPos])
            currPos += 1

            let rndNode = Int(numGenerator.next(upperBound: UInt64(size)))

            currPos += (rndNode * 3)

            var trieCharCode: Int

            trieCharCode = Int(data[currPos])
            currPos += 1

            var skipBytes: Int

            skipBytes = Int((data[currPos + 1] & 0xFF))
            skipBytes |= (Int(data[currPos] & 0xFF) << 8)
            currPos += 2

            var isLeaf = trieCharCode > 31

            if isLeaf {
                trieCharCode = trieCharCode - 32
            }
            
            if trieCharCode >= alphabet.count {
                return false
            }
            
            var c = indexToChar[trieCharCode]!

            buffer.append(c)

            if i == length - 1 {
                return isLeaf
            }

            if skipBytes == 65535 {
                return false
            }

            currPos += skipBytes
        }

        return false
    }
    
    func dfs2(_ bytePos: inout Int, _ pattern: String, _ pos: Int, _ sb: inout String, _ test: (String) -> Bool) -> Bool {
        
        
          let c = pattern[pos].first!
          let lastIndex = pos == pattern.count - 1

          if c != "?" {
              let charIndex = charToIndex[c]
              
              sb.append(c)

              let size = Int(data[bytePos])
              bytePos += 1
              var result = false

              for _ in 0..<size {
                  let currentChar = Int(data[bytePos])
                  bytePos += 1

                  let isLeaf = currentChar >= 32
                  let ch = isLeaf ? currentChar - 32 : currentChar
                  let read1 = data[bytePos]
                  bytePos += 1
                  let read2 = data[bytePos]
                  bytePos += 1
                  let jumpTo = Int(read2) | (Int(read1) << 8)

                  if ch == charIndex {
                      if lastIndex {
                          result = isLeaf && test(sb)
                          break
                      }

                      let bisPos = bytePos
                      if jumpTo == 65535 {
                          break
                      }
                      bytePos += jumpTo
                      result = dfs2(&bytePos, pattern, pos + 1, &sb, test)
                      bytePos = bisPos
                      break
                  }
              }

              if !result {
                  sb.removeLast()
              }
              return result
          } else {
              let size = Int(data[bytePos])
              bytePos += 1

              for _ in 0..<size {
                  var currentChar = Int(data[bytePos])
                  bytePos += 1

                  let isLeaf = currentChar >= 32
                  if isLeaf {
                      currentChar -= 32
                  }

                  if isLeaf && lastIndex {
                      if currentChar >= alphabet.count {
                          return false
                      }
                      sb.append(alphabet[currentChar])
                      return test(sb)
                  }

                  let read1 = data[bytePos]
                  bytePos += 1
                  let read2 = data[bytePos]
                  bytePos += 1
                  let jumpTo = Int(read2) | (Int(read1) << 8)

                  if !lastIndex {
                      let bisPos = bytePos
                      if jumpTo == 65535 {
                          continue
                      }
                      bytePos += jumpTo
                      if currentChar >= alphabet.count {
                          continue
                      }
                      sb.append(alphabet[currentChar])
                      let candidate = dfs2(&bytePos, pattern, pos + 1, &sb, test)
                      bytePos = bisPos

                      if candidate {
                          return true
                      } else {
                          sb.removeLast()
                      }
                  }
              }
          }

          return false
      }
}


class Words {
    static var unusedFirstChars = "ABC"
    static var hardDict: Dict?
    static var easyDict: Dict?
    static var mediumDict: Dict?

    static var nlHardDict: Dict?
    static var nlEasyDict: Dict?
    static var nlMediumDict: Dict?
    
     /// Initialize the base
     static func initBase() {
         loadTrieData()
     }

     /// Loads the trie resource from the Assets into the 'dict' static variable
     private static func loadTrieData() {
         // Try to fetch the data asset named "trie"
         guard let dataAsset = NSDataAsset(name: "trie") else {
             fatalError("Failed to find data asset: trie")
         }

         // Load the data from the asset
         hardDict = Dict("trie", true)
         
         // Load the data from the asset
         mediumDict = Dict("trie_level_2", true)
         
         // Load the data from the asset
         easyDict = Dict("trie_level_1", true)
         
         
         nlHardDict = Dict("dutch_trie_level_3", false)
         
         // Load the data from the asset
         nlMediumDict = Dict("dutch_trie_level_2", false)
         
         // Load the data from the asset
         nlEasyDict = Dict("dutch_trie_level_2", false)
     }
    
    public static func getAlphabet(_ level: Level, _ lang: Lang) -> String {
        return getDict(level, lang).alphabet;
    }
    
    public static func isAlphabetCharacter(_ letterChar: Character, _ level: Level, _ lang: Lang) -> Bool {
        return getDict(level, lang).alphabet.contains(letterChar)
    }
    
    public static func findWordByPattern(_ foundWord: inout String, _ test: (String) -> Bool, _ level: Level, _ lang: Lang) -> Bool {
      
        if hardDict == nil {
            initBase();
        }
        var sb = String()
        var pos = 0
        var pattern = String(foundWord);
        var b = false;
        
        b = getDict(level, lang).dfs2(&pos, pattern, 0, &sb, test);

        if (b) {
            foundWord.removeAll()
            foundWord.append(sb)
        }
        return b;
    }



    
    
    public static func getRandomWord(_ length: Int, _ level: Level, _ lang: Lang) -> String? {
        var buffer = String()

       
        while !getNextRandomWord(buffer: &buffer, length: length, level: level, lang: lang) { }
       
        return buffer
    }
    
    public static func getNextRandomWord(buffer: inout String, length: Int, level: Level, lang: Lang) -> Bool {
        var numGenerator = SystemRandomNumberGenerator()
        buffer.removeAll()
    
        return getDict(level, lang).findRandomWord(&buffer, length)

    }
    
    public static func getDict(_ level: Level, _ lang: Lang) -> Dict {
        if hardDict == nil {
            initBase();
        }
        
        let data: Dict;
        
        switch lang {
        case .NL:
            switch level {
            case .EASY:
                data = nlEasyDict!
            case .MEDIUM:
                data = nlMediumDict!
            default:
                data = nlHardDict!
            }
        default:
            switch level {
            case .EASY:
                data = easyDict!
            case .MEDIUM:
                data = mediumDict!
            default:
                data = hardDict!
            }
        }
        
     
        
        return data
    }

  }

extension StringProtocol {
    subscript(offset: Int) -> String {
        return String(self[index(startIndex, offsetBy: offset)])
    }
}
