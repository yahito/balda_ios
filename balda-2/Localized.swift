//
//  Localized.swift
//  balda-2
//
//  Created by Andrey on 18/05/2024.
//

import Foundation

extension String {
    func translate(to language: String, in bundle: Bundle = .main) -> String {
                                
        guard let path = bundle.path(forResource: language, ofType: "lproj"),
             let localizedBundle = Bundle(path: path) else {
            if language == "en" {
                return self
            }
            return self.translate(to: "en")
       }
        
        return NSLocalizedString(self, tableName: "balda", bundle: localizedBundle, value: "", comment: "")
        
    
    }
}
