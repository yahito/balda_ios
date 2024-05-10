//
//  UIColor.swift
//  balda-2
//
//  Created by Andrey on 09/05/2024.
//

import Foundation

import UIKit // Ensure this is at the top of the file


extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            print(hexColor.count)

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff)) / 255
    

                    self.init(red: r, green: g, blue: b, alpha: 256.0)
                    return
                }
            }
        }

        return nil
    }
}
