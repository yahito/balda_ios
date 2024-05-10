//
//  BottomPanelView.swift
//  balda-2
//
//  Created by Andrey on 08/10/2023.
//

import Foundation


import UIKit

class BottomPanelView: UIView {

    let skipButton = UIButton()
    let nextGameButton = UIButton()
    let finishStepButton = UIButton()
    let undoSelectionButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        
        let backgroundImageView = UIImageView(image: UIImage(named: "menu_back"))
        backgroundImageView.contentMode = .scaleToFill
        addSubview(backgroundImageView)
        sendSubviewToBack(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add and layout buttons
        let stackView = UIStackView(arrangedSubviews: [skipButton, nextGameButton, finishStepButton, undoSelectionButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        
        ])
        
        let hover = UIHoverGestureRecognizer(target: self, action: #selector(handleHover(_:)))
        skipButton.addGestureRecognizer(hover)
        nextGameButton.addGestureRecognizer(hover)
        finishStepButton.addGestureRecognizer(hover)
        undoSelectionButton.addGestureRecognizer(hover)
    
        
        skipButton.setImage(UIImage(named: "skip"), for: .normal)
        nextGameButton.setImage(UIImage(named: "new"), for: .normal)
        finishStepButton.setImage(UIImage(named: "finish"), for: .normal)
        undoSelectionButton.setImage(UIImage(named: "undo"), for: .normal)
    
    }
    
    @objc func handleHover(_ recognizer: UIHoverGestureRecognizer) {
        guard let button = recognizer.view as? UIButton else { return }

            switch recognizer.state {
            case .began, .changed:
                UIView.animate(withDuration: 0.3) {
                    button.transform = CGAffineTransform(translationX: 0, y: -10)
                }
            case .ended:
                UIView.animate(withDuration: 0.3) {
                    button.transform = .identity
                }
            default:
                break
            }
    }
 




}
