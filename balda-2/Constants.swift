//
//  Constants.swift
//  balda-2
//
//  Created by Andrey on 27/09/2023.
//

import Foundation

public class Constants {
    public static let init_char = " ".first!
    public static let question_char = "?".first!
    
    public static func isLetterPlaceholder(_ c: Character) -> Bool {
        return c == "?"
    }
}
