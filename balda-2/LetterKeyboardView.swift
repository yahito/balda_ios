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
    private var size: Int = 6;
    var buttons: [UIButton] = []

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
        
        let totalMargin = 0.0
        
        let buttonWidth: CGFloat = ((frame.width - totalMargin) / Double(size)) // assuming 5 letters per row
        
        let fontSize: CGFloat = 40
        let buttonFont = UIFont.boldSystemFont(ofSize: 40)
        let buttonHeight = fontSize * 1.05
        
        
        
        for (index, letter) in letters.enumerated() {
            let row = index / size
            let column = index % size
            let x = (totalMargin/2) + (CGFloat(column) * buttonWidth)
            let y = CGFloat(row) * buttonHeight
            
            let button = UIButton(frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight))
            button.setTitle(String(letter), for: .normal)
            button.addTarget(self, action: #selector(keyTapped(_:)), for: .touchUpInside)
            button.addTarget(self, action: #selector(handleHover(_:)), for: .touchDragInside)
            button.addTarget(self, action: #selector(handleHover(_:)), for: .touchDown)
            button.addTarget(self, action: #selector(handleHover2(_:)), for: .touchDragOutside)
            button.backgroundColor = .none
            button.titleLabel?.font = buttonFont
                    
            
            buttons.append(button)
            
            addSubview(button)
            
            
        }

        
        
   
    }
    
    @objc func handleHover(_ sender: UIButton) {
        sender.titleLabel?.textColor =  UIColor(hex: "#DF5386")
    }
    
    @objc func handleHover2(_ sender: UIButton) {
        sender.titleLabel?.textColor =  .white
    }
    
    @objc private func keyTapped(_ sender: UIButton) {
        sender.titleLabel?.textColor =  UIColor(hex: "#DF5386")
        if let letter = sender.titleLabel?.text?.first {
            letterTapped?(letter)
        }
    }
}
