//
//  StartMenuViewConvtroller.swift
//  balda-2
//
//  Created by Andrey on 04/11/2023.
//

import Foundation
import UIKit

protocol DismissalDelegate {
    func viewControllerDidDismiss(_ level: Level, _ lang: Lang, _ size: Size, _ name: String, _ pic: UserPic)
}

class StartMenuViewController: UIViewController {
    var dismissDelegete: DismissalDelegate? = nil;
    var langButtons: [UIButton] = []
    var levelButtons: [UIButton] = []
    var sizeButtons: [UIButton] = []
    var level: Level
    var lang: Lang
    var size: Size
    let name: String
    let userPic: UserPic
    
    init(_ dismissDelegete: DismissalDelegate, _ level: Level, _ lang: Lang, _ size: Size, _ name: String, _ userPic: UserPic) {
        self.dismissDelegete = dismissDelegete
        self.level = level
        self.lang = lang
        self.size = size
        self.name = name
        self.userPic = userPic
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.level = .EASY
        self.lang = .RUS
        self.size = .FIVE
        self.name = ""
        self.userPic = UserPic.CAT
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white.withAlphaComponent(0.9)
        
        let backgroundImageView = UIImageView(image: UIImage(named: "back"))
        backgroundImageView.contentMode = .scaleToFill
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        setupDifficultyButtons()
    }
    
    fileprivate func style(_ selected: Bool, _ button: UIButton) {
        if selected {
            button.setBackgroundImage(UIImage(named: "start_menu_button_back"), for: .normal)
        } else {
            button.setBackgroundImage(UIImage(named: "start_menu_button_back_sel"), for: .normal)
        }
    }
    
    fileprivate func createbutton(_ title: String, _ index: Int, _ tag: Int, _ selected: Bool, _ big: Bool, _ bigShift: Int) -> UIButton {
        let button = UIButton()
        
        button.setBackgroundImage(UIImage(named: "start_menu_button_back_sel"), for: .normal)
        
        button.setBackgroundImage(UIImage(named: "start_menu_button_back"), for: .highlighted)
        
        button.setTitle(title, for: .normal)
                
        var buttonHeight: CGFloat = UIScreen.main.bounds.height*0.045
        var buttonSpacing: CGFloat = 10
                
        if UIDevice.current.userInterfaceIdiom == .pad {
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .extraLargeTitle)
            buttonHeight = 60
        } else {
            button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        }
        style(selected, button)
        button.tag = tag
        button.addTarget(self, action: #selector(difficultySelected(_:)), for: .touchUpInside)
        
        // Set the frame or use Auto Layout
        
        let yOffset = view.bounds.height*0.15 + CGFloat(index) * (buttonHeight + buttonSpacing) + CGFloat(bigShift)*buttonSpacing
        button.frame = CGRect(x: 20, y: yOffset, width: view.bounds.width - 40, height:  big ? buttonHeight*1.2 : buttonHeight)
        
        view.addSubview(button)
        return button
    }
    
    func setupDifficultyButtons() {
        for (index, size) in Size.allCases.enumerated() {
            sizeButtons.append(createbutton(size.rawValue, index, index, size == self.size, false, 0))
        }
        
        var shift = sizeButtons.count + 1
    
        
        for (index, level) in Level.allCases.enumerated() {
            levelButtons.append(createbutton(level.tag.translate(to: lang.languageCode), index + shift, index, level == self.level, false, 0))
        }
        
        shift += Level.allCases.count + 1
        
        /*for (index, lang) in Lang.allCases.enumerated() {
            langButtons.append(createbutton(lang.rawValue, index + shift, index, lang == self.lang, false, 0))
        }
        
        
        */
        
        
        shift += Lang.allCases.count + 1
        let controlTitles = ["start".translate(to: lang.languageCode), "cancel".translate(to: lang.languageCode)]
        
        
        for (index, title) in controlTitles.enumerated() {
            let b = createbutton(title, index + shift, index, false, true, index)
            
            let buttonSpacing: CGFloat = 10
            
            let yOffset = view.bounds.height - CGFloat(((controlTitles.count - index + 1))) * (buttonSpacing + b.frame.height)
            
            b.frame = CGRect(x: b.frame.minX, y: yOffset, width: b.frame.width, height: b.frame.height)
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
            self.dismissDelegete!.viewControllerDidDismiss(level, lang, size, name, userPic)
            dismiss(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}
