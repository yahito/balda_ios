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
                    
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        
        ])
        
        for button in [skipButton, nextGameButton, finishStepButton, undoSelectionButton] {
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: 1/8),
                button.heightAnchor.constraint(equalTo: backgroundImageView.heightAnchor, multiplier: 1/2),
            ])
        }
        
        let hover = UIHoverGestureRecognizer(target: self, action: #selector(handleHover(_:)))
        skipButton.addGestureRecognizer(hover)
        nextGameButton.addGestureRecognizer(hover)
        finishStepButton.addGestureRecognizer(hover)
        undoSelectionButton.addGestureRecognizer(hover)
    
        
        skipButton.setImage(UIImage(named: "shrug"), for: .normal)
        skipButton.imageView?.contentMode = .scaleAspectFit
        
        nextGameButton.setImage(UIImage(named: "new_game"), for: .normal)
        nextGameButton.imageView?.contentMode = .scaleAspectFit
        
        finishStepButton.setImage(UIImage(named: "done"), for: .normal)
        finishStepButton.imageView?.contentMode = .scaleAspectFit
        
        undoSelectionButton.setImage(UIImage(named: "renew"), for: .normal)
        undoSelectionButton.imageView?.contentMode = .scaleAspectFit
    
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
