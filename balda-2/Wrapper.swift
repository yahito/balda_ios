//
//  Wrapper.swift
//  balda-2
//
//  Created by Andrey on 05/05/2024.
//

import Foundation


class ClosureWrapper {
    let closure: (Character) -> Void
    
    init(_ closure: @escaping (Character) -> Void) {
        self.closure = closure
    }
}
