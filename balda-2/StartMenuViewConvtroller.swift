//
//  StartMenuViewConvtroller.swift
//  balda-2
//
//  Created by Andrey on 04/11/2023.
//

import Foundation
import UIKit

protocol DismissalDelegate {
    func viewControllerDidDismiss(_ level: Level, _ lang: Lang, _ size: Size)
}

class StartMenuViewController: UIViewController {
    var dismissDelegete: DismissalDelegate? = nil;
    var langButtons: [UIButton] = []
    var levelButtons: [UIButton] = []
    var sizeButtons: [UIButton] = []
    var level: Level
    var lang: Lang
    var size: Size
    
    init(_ dismissDelegete: DismissalDelegate, _ level: Level, _ lang: Lang, _ size: Size) {
        self.dismissDelegete = dismissDelegete
        self.level = level
        self.lang = lang
        self.size = size
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.level = .EASY
        self.lang = .RUS
        self.size = .FIVE
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white.withAlphaComponent(0.9)
        setupDifficultyButtons()
    }
    
    fileprivate func style(_ selected: Bool, _ button: UIButton) {
        if selected {
            button.backgroundColor = .blue
        } else {
            button.backgroundColor = .lightGray
        }
    }
    
    fileprivate func createbutton(_ title: String, _ index: Int, _ tag: Int, _ selected: Bool) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        style(selected, button)
        button.tag = tag
        button.addTarget(self, action: #selector(difficultySelected(_:)), for: .touchUpInside)
        
        // Set the frame or use Auto Layout
        let buttonHeight: CGFloat = 40
        let buttonSpacing: CGFloat = 10
        let yOffset = view.bounds.height*0.15 + CGFloat(index) * (buttonHeight + buttonSpacing)
        button.frame = CGRect(x: 20, y: yOffset, width: view.bounds.width - 40, height: buttonHeight)
        
        view.addSubview(button)
        return button
    }
    
    func setupDifficultyButtons() {
        for (index, size) in Size.allCases.enumerated() {
            sizeButtons.append(createbutton(size.rawValue, index, index, size == self.size))
        }
        
        var shift = sizeButtons.count + 1
        
        let buttonTitles = ["Easy", "Medium", "Hard"]
        
        
        for (index, level) in Level.allCases.enumerated() {
            levelButtons.append(createbutton(level.rawValue, index + shift, index, level == self.level))
        }
        
        shift += buttonTitles.count + 1
        
        for (index, lang) in Lang.allCases.enumerated() {
            langButtons.append(createbutton(lang.rawValue, index + shift, index, lang == self.lang))
        }
        
        shift += langButtons.count + 1
        let controlTitles = ["Start", "Cancel"]
        
        for (index, title) in controlTitles.enumerated() {
            createbutton(title, index + shift, index, false)
        }
    }
    
    @objc func difficultySelected(_ sender: UIButton) {
        
        if levelButtons.contains(sender) {
            for x in levelButtons {
                style(x == sender, x)
                if (x == sender) {
                    level = Level.allCases[sender.tag]
                }
            }
        } else if langButtons.contains(sender) {
            for x in langButtons {
                style(x == sender, x)
                if (x == sender) {
                    lang = Lang.allCases[sender.tag]
                }
            }
        } else if sizeButtons.contains(sender) {
            for x in sizeButtons {
                style(x == sender, x)
                if (x == sender) {
                    size = Size.allCases[sender.tag]
                }
            }
        }  else if sender.tag == 0 {
            self.dismissDelegete!.viewControllerDidDismiss(level, lang, size)
            dismiss(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}
