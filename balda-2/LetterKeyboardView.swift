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
    var onFinish: (() -> Void)?
    
    private var didSetupKeys = false
    var alphabet: String?;
    private var size: Int = 6;
    var buttons: [UIButton] = []
    var tappedLetter: Character?
    
    override var isHidden: Bool {
        didSet {
            if !isHidden {
                onShow()
            }
        }
    }
    
    func onShow() {
        buttons.forEach{ k in k.setTitleColor(.white, for: .normal) }
        tappedLetter = nil
    }
    
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)

        for button in buttons {
            if button.frame.contains(touchLocation) {
                button.becomeFirstResponder()
            } else {
                button.resignFirstResponder()
            }
        }
    }
    
    private func setupKeys() {
        let letters = alphabet!
        
        let totalMargin = 0.0
        
        let buttonWidth: CGFloat = ((frame.width - totalMargin) / Double(size)) // assuming 5 letters per row
        
        let fontSize: CGFloat = bounds.height*0.13
        
        let buttonFont = UIFont(name: "Nunito-ExtraBold", size: fontSize)
        let buttonHeight = fontSize * 1.05
        
        for (index, letter) in letters.enumerated() {
            let row = index / size
            let column = index % size
            let x = (totalMargin/2) + (CGFloat(column) * buttonWidth)
            let y = CGFloat(row) * buttonHeight
            
            let button = UIButton(frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight))
            
            button.setTitle(String(letter), for: .normal)
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
            button.addGestureRecognizer(panGesture)
            
            button.addTarget(self, action: #selector(keyTapped(_:)), for: .touchUpInside)
            button.addTarget(self, action: #selector(handleHover(_:)), for: .touchDown)
            button.addTarget(self, action: #selector(handleUp(_:)), for: .touchUpOutside)
            button.addTarget(self, action: #selector(handleUp(_:)), for: .touchUpInside)
            button.addTarget(self, action: #selector(handleHover2(_:)), for: .touchDragOutside)
            button.backgroundColor = .none
            button.titleLabel?.font = buttonFont
                    
            
            buttons.append(button)
            
            addSubview(button)
        }
    }
    @objc func pan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
            case .ended:
            let location = recognizer.location(in: self)
            
            
            handleUp(nil)
            
            default:
                break
        }
        
        self.buttons.forEach {w in
                let location = recognizer.location(in: w)
            if w.bounds.contains(location) {
                handleHover(w)
            }
        }
        
    }
    
    var i: Int = 1
    
    @objc func handleUp(_ sender: UIButton?) {
        if self.tappedLetter != nil {
            onFinish!()
        }
    }
    
    @objc func handleHover(_ sender: UIButton) {
        buttons.filter{ $0 != sender }.forEach{ k in k.setTitleColor(.white, for: .normal) }
        
        sender.setTitleColor(UIColor(hex: "#DF5386"), for: .normal)
        
        if let letter = sender.titleLabel?.text?.first {
            tappedLetter = letter
            letterTapped?(letter)
        }
        setNeedsDisplay()
    }
    
    @objc func handleHover2(_ sender: UIButton) {
        sender.titleLabel?.textColor =  .white
    }
    
    @objc private func keyTapped(_ sender: UIButton) {
        sender.titleLabel?.textColor =  UIColor(hex: "#DF5386")
        if let letter = sender.titleLabel?.text?.first {
            self.tappedLetter = letter
            letterTapped?(letter)
        }
    }
}
