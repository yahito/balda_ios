//
//  LetterKeyboardView.swift
//  balda-2
//
//  Created by Andrey on 23/09/2023.
//
import UIKit
import SpriteKit
import GameplayKit
import CoreGraphics

import Foundation


class LetterKeyboardView: UIView {
    var letterTapped: ((Character) -> Void)?
    
    private var didSetupKeys = false
    private var alphabet: String?;
    private var size: Int = 5;

        // Your initializers...

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupIfNeeded()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupIfNeeded()
    }

    private func setupIfNeeded() {
        guard !didSetupKeys else { return }
        
        if bounds.width > 0 && bounds.height > 0 {
            setupKeys()
            didSetupKeys = true
        }
    }
    
    init(frame: CGRect, alphabet: String) {
        super.init(frame: frame)
        self.alphabet = alphabet
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupKeys() {
        let letters = alphabet!
        
        let totalMargin = bounds.width * 0.05
        
        let buttonWidth: CGFloat = ((frame.width - totalMargin) / Double(size)) // assuming 5 letters per row
        
        let fontSize: CGFloat = 17.0
        let buttonFont = UIFont.systemFont(ofSize: fontSize)
        let buttonHeight = fontSize * 2
        
        for (index, letter) in letters.enumerated() {
            let row = index / size
            let column = index % size
            let x = (totalMargin/2) + (CGFloat(column) * buttonWidth)
            let y = CGFloat(row) * buttonHeight
            
            let button = UIButton(frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight))
            button.setTitle(String(letter), for: .normal)
            button.addTarget(self, action: #selector(keyTapped(_:)), for: .touchUpInside)
            button.backgroundColor = .green
            button.setTitleColor(.red, for: .normal)
            button.titleLabel?.font = buttonFont
            
            
            addSubview(button)
        }
    }
    
    @objc private func keyTapped(_ sender: UIButton) {
        if let letter = sender.titleLabel?.text?.first {
            letterTapped?(letter)
        }
    }
}
