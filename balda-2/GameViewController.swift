//
//  GameViewController.swift
//  balda-2
//
//  Created by Andrey on 22/09/2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, DismissalDelegate {
    
    var gridView: GridView?
    var titleView: UILabel = UILabel()
    var gridState: GameGridState?
    var wordView: OvalLabel?
    let bottomPanel = BottomPanelView()
    var game: Game? = nil
    
    private var hintWindow: HintWindow?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func search(_ min: Int, _ max: Int) -> SearchResult? {
        let isPalindrome2: (String) -> Bool = { word in
            return !self.game!.state.containsWord(word) && word.count >= min && word.count <= max
        }
        
        let isPalindrome: (String) -> String? = { word in
            var w = String(word)
            let res =  Words.findWordByPattern(&w, isPalindrome2,self.game!.state.level,  self.game!.state.lang)
            if (res) {
                return w
            }
            return nil
            
        }
            
        return Search.search(game!.state.grid, max, isPalindrome)
    }

    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
         let translation = recognizer.translation(in: view)
         let percentage = translation.y / view.bounds.height


         switch recognizer.state {
         case .began:
             hintWindow = HintWindow(frame: CGRect(x: 0, y: -150, width: 200, height: 100))
             hintWindow!.show(in: self.view)
             hintWindow!.configure(with: "Nothing found")
             
             DispatchQueue.global(qos: .background).async {
                 var ress = self.search(5, 8)
                 if ress != nil && ress!.getWord() != nil {
                     let word = ress?.getWord()
                     self.hintWindow!.finalText = word!
                 } else {
                     ress = self.search(2, 4)
                     if ress != nil && ress!.getWord() != nil {
                         let word = ress?.getWord()
                         self.hintWindow!.finalText = word!
                     }
                 }
             }
             
         case .changed:
             let pos = min(0, -150 + translation.y);
             hintWindow!.frame = CGRect(x: 0, y: pos, width: gridView!.frame.width, height: 100)
             hintWindow!.updateVisibility(percentage: (pos + hintWindow!.frame.height)/100)
         case .ended, .cancelled:
             hintWindow!.hide()
         default:
             break
         }
     }

    fileprivate func initGame() {
        gridView = initGrid()
        if gridState != nil {
            game = Game(gridState!, gridView!)
            gridView!.game = game
            game!.move()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panRecognizer)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(_:)), name: .opponentChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(_:)), name: .gameFinished, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateWord(_:)), name: .wordChanged, object: nil)
        
        titleView.text = ""
        titleView.textColor = .black
     
       
        bottomPanel.translatesAutoresizingMaskIntoConstraints = false
        // Add actions to buttons
        bottomPanel.skipButton.addTarget(self, action: #selector(skipStepPressed), for: .touchUpInside)
        bottomPanel.nextGameButton.addTarget(self, action: #selector(nextGamePressed), for: .touchUpInside)
        bottomPanel.finishStepButton.addTarget(self, action: #selector(finishStepPressed), for: .touchUpInside)
        bottomPanel.undoSelectionButton.addTarget(self, action: #selector(undoSelectionPressed), for: .touchUpInside)
        
        
        bottomPanel.scoreButton.addTarget(self, action: #selector(scoreButtonPressed), for: .touchUpInside)
        
        bottomPanel.isUserInteractionEnabled = true
        
        if (gridView != nil) {
            return
        }
        
        initGame()
    
        NSLayoutConstraint.activate([
            bottomPanel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomPanel.heightAnchor.constraint(equalToConstant: 60) // or whatever height you want
        ])
    

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .opponentChanged, object: nil)
    }
    
    @objc func updateWord(_ notification: Notification) {
        if let state = notification.userInfo?["word"] as? String {
            wordView?.text = state
        }
    }
    
    @objc func updateTextView(_ notification: Notification) {
       if let state = notification.userInfo?["local"] as? Bool {
           titleView.text = state ? "Your turn" : "Wait"
       }
        
        let state = notification.userInfo?["winner"] as? Game.GAME_RESULT;
        
        if (state != nil){
            switch(state!) {
            case .TIE:
                titleView.text = "It's a tie"
            case .LOCAL_LOOSE:
                titleView.text = "You are defeated"
            case .LOCAL_WIN:
                titleView.text = "You win"
            }
        }
   }
    
    func initGrid() -> GridView {
        let gridView = GridView(frame: self.view.bounds)
        gridView.backgroundColor = .clear
        gridView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        gridView.frame = CGRect(x: 0, y: view.bounds.height*0.10, width: view.bounds.width, height: view.bounds.height - 50)
        titleView.frame = CGRect(x: 20, y: 10, width: view.bounds.width - 10, height: 100)
        
        view.addSubview(titleView)
        view.addSubview(gridView)
        
        //bottomPanel.removeFromSuperview()
        view.addSubview(bottomPanel)
        bottomPanel.frame = CGRect(x: 0, y: view.bounds.height - 50, width: view.bounds.width, height: 50)
        
        var w = view.bounds.width*0.5
        var pos = (view.bounds.width - w)/2
        let wordFrame = CGRect(x: pos, y: gridView.frame.minY + gridView.frame.maxX + 10, width: w, height: 50)
        
        let wordView = OvalLabel(frame: wordFrame)
        view.addSubview(wordView)
        self.wordView = wordView
        
        return gridView
    }
    
    func randomCGFloat() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }

    func randomColor() -> UIColor {
        return UIColor(red: randomCGFloat(), green: randomCGFloat(), blue: randomCGFloat(), alpha: 1.0)
    }
    
    
    @objc func screenTapped() {
     
         
        
       /* let f = LetterKeyboardView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        f.backgroundColor = .clear
        f.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(f)*/
    }
    
    @objc func skipStepPressed() {
        self.game!.resetAndSkipStep()
    }
    
    func viewControllerDidDismiss(_ level: Level, _ lang: Lang, _ size: Size) {
        self.gridView?.removeFromSuperview()
        self.gridState = GameGridState(Words.getRandomWord(size.getGridSize(), Level.HARD, lang)!, size, 0, level, lang);
        self.wordView?.removeFromSuperview()
        self.initGame();
    }

    @objc func nextGamePressed() {
        let menuVC = StartMenuViewController(self, game!.state.level, game!.state.lang, game!.state.size)
        
        menuVC.modalPresentationStyle = .overCurrentContext
        menuVC.modalTransitionStyle = .coverVertical
        present(menuVC, animated: true)
    }
    
    let difficultyTextField = UITextField()
    let pickerView = UIPickerView()
    let difficulties = ["Easy", "Medium", "Hard"] // Your difficulty levels
    
    @objc func dismissPicker() {
       view.endEditing(true) // This will dismiss the picker view
   }
    
     
     // UIPickerView DataSource and Delegate methods
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1 // We only need one column
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return difficulties.count // The number of difficulties
     }
     
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         return difficulties[row] // The title for each row
     }
     
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         difficultyTextField.text = difficulties[row] // Set the text field to the selected difficulty
     }

    @objc func finishStepPressed() {
        let res = game?.__finishStep()
        if (res != nil) {
            if res == Result.NOT_FOUND {
                let alertController = UIAlertController(title: "Confirmation",
                                                        message: "Word not found",
                                                        preferredStyle: .alert)
                
                let yesAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                    
                }
                
                alertController.addAction(yesAction)
                
                self.present(alertController, animated: true, completion: nil)
            } else if res == Result.BOMB {
                let alertController = UIAlertController(title: "Confirmation",
                                                        message: "Boom",
                                                        preferredStyle: .alert)
                
                let yesAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                    
                }
                
                alertController.addAction(yesAction)
                
                self.present(alertController, animated: true, completion: nil)
            } else if res == Result.DUPLICATE {
                let alertController = UIAlertController(title: "Confirmation",
                                                        message: "Duplicate",
                                                        preferredStyle: .alert)
                
                let yesAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                    
                }
                
                alertController.addAction(yesAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    @objc func undoSelectionPressed() {
        game?.cancelSelection()
    }
    
    @objc func scoreButtonPressed() {
        let scoreBoardView = ScoreBoardView(frame: .zero, info: game!.getInfo())

       view.addSubview(scoreBoardView)
        
        NSLayoutConstraint.activate([
            scoreBoardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scoreBoardView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scoreBoardView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5),
            scoreBoardView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor) // Center vertically or set to the top
        ])
        scoreBoardView.translatesAutoresizingMaskIntoConstraints = false
    }
}
