//
//  GameViewController.swift
//  balda-2
//
//  Created by Andrey on 22/09/2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DismissalDelegate {
    
    var gridView: GridView?
    var titleView: UILabel = UILabel()
    var gridState: GameGridState?
    var wordView: OvalLabel?
    let bottomPanel = BottomPanelView()
    let scoreBoard = Score(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var game: Game? = nil
    var keyboardView: LetterKeyboardView?
    
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

    

    fileprivate func initGame() {
        titleView.isAccessibilityElement = true
        titleView.accessibilityIdentifier = "title"
        
        gridView = initGrid()
        
        if gridState != nil {
            game = Game(gridState!, gridView!)
            
            if (keyboardView == nil || keyboardView?.alphabet != game!.getAlphabet()) {
                keyboardView = LetterKeyboardView(frame: CGRect(x: 0, y: 400, width: view.frame.width, height: view.frame.height/3),
                                                  alphabet: game!.getAlphabet())
            }
            
            gridView!.setGame(game!)
            game!.move()
            let hh = view.bounds.height - gridView!.frame.minY - gridView!.frame.height - 10;
            let wordFrame = CGRect(x: 0, y: 500, width: view.bounds.width, height: view.bounds.height - 600 - 50)
            
            //if (scoreBoard == nil) {
              //  scoreBoard = Score(frame: wordFrame)
                view.addSubview(scoreBoard)
                scoreBoard.onUserPicChange = {
                    self.gridState?.userPic1 = self.gridState!.getOtherPic(self.gridState!.userPic1)
                    self.scoreBoard.setInfo(self.game!.getInfo())
                }
            //}
            //scoreBoard!.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            //scoreBoard!.backgroundColor = .black

            scoreBoard.setInfo(game!.getInfo())
            
        }
        view.addSubview(gridView!)
        view.addSubview(keyboardView!)
        
        
        bottomPanel.translatesAutoresizingMaskIntoConstraints = false
        gridView!.translatesAutoresizingMaskIntoConstraints = false
        scoreBoard.translatesAutoresizingMaskIntoConstraints = false
        keyboardView!.translatesAutoresizingMaskIntoConstraints = false
        wordView!.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        keyboardView!.isHidden = true
        scoreBoard.isHidden = !keyboardView!.isHidden
        
        //scoreBoard!.isUserInteractionEnabled = true

        
    
        let heightMultiplier: CGFloat = 0.5 // Start at 50% of the height
        
        NSLayoutConstraint.activate([
        
            
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            gridView!.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 5),
            gridView!.centerXAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.centerXAnchor),
            gridView!.widthAnchor.constraint(equalTo: gridView!.heightAnchor),
            gridView!.heightAnchor.constraint(equalToConstant: CGFloat(getGridBottom(gridState!.grid.count))),
        
            
            wordView!.topAnchor.constraint(equalTo: gridView!.bottomAnchor, constant: 1),
            wordView!.heightAnchor.constraint(equalToConstant: UIDevice.current.userInterfaceIdiom == .pad ? 55: 40),
            wordView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wordView!.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            
            keyboardView!.topAnchor.constraint(equalTo: gridView!.bottomAnchor, constant: 0),
            keyboardView!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            keyboardView!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                                        
            scoreBoard.topAnchor.constraint(equalTo: wordView!.bottomAnchor, constant: 10),
            scoreBoard.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scoreBoard.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            bottomPanel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomPanel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            bottomPanel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09),
            
            scoreBoard.bottomAnchor.constraint(equalTo: bottomPanel.topAnchor),
            keyboardView!.bottomAnchor.constraint(equalTo: bottomPanel.topAnchor),
            

                ])
        
        //view.bringSubviewToFront(bottomPanel)
    }
    
    // Calculate the width of the text view with an additional 10-point padding
     private func calculateTextViewWidth() -> CGFloat {
         let text = wordView!.text ?? ""
         let padding: CGFloat = 10
         
         // Calculate the text width using the given font
         let textWidth = (text as NSString).boundingRect(
             with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: wordView!.frame.height),
             options: .usesLineFragmentOrigin,
             attributes: [.font: wordView!.label.font ?? UIFont.systemFont(ofSize: 16)],
             context: nil
         ).width
         
         // Add 10 points to the calculated width
         return textWidth + padding
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImageView = UIImageView(frame: self.view.bounds)
        backgroundImageView.image = UIImage(named: "back")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        
     //   let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
       // view.addGestureRecognizer(panRecognizer)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(_:)), name: .opponentChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(_:)), name: .gameFinished, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateWord(_:)), name: .wordChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(_:)), name: .showKeyboard, object: nil)
        
        titleView.text = ""
        titleView.textColor = UIColor(hex: "#DF5386")
            
        if UIDevice.current.userInterfaceIdiom == .pad {
            titleView.font = UIFont.preferredFont(forTextStyle: .extraLargeTitle)
        } else {
            titleView.font = UIFont.preferredFont(forTextStyle: .title3)
        }
       
        bottomPanel.translatesAutoresizingMaskIntoConstraints = false
        // Add actions to buttons
                
        bottomPanel.accessibilityIdentifier = "xxx"
        
        bottomPanel.skipButton.addTarget(self, action: #selector(skipStepPressed), for: .touchUpInside)
        
        bottomPanel.skipButton.accessibilityIdentifier = "skipButton"
        bottomPanel.skipButton.isAccessibilityElement = true
        
        bottomPanel.nextGameButton.addTarget(self, action: #selector(nextGamePressed), for: .touchUpInside)
        bottomPanel.finishStepButton.addTarget(self, action: #selector(finishStepPressed), for: .touchUpInside)
        bottomPanel.undoSelectionButton.addTarget(self, action: #selector(undoSelectionPressed), for: .touchUpInside)
        
        
        bottomPanel.isUserInteractionEnabled = true
        
        if (gridView != nil) {
            return
        }
        
        initGame()
    
       NSLayoutConstraint.activate([
         
            
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .opponentChanged, object: nil)
    }
    
    @objc func showKeyboard(_ notification: Notification) {
        if !(game?.currentOpponent is LocalOpponent) {
            return
        }
        
        keyboardView!.backgroundColor = .clear
        keyboardView!.isHidden = false
        scoreBoard.isHidden = !keyboardView!.isHidden
        
        let x = notification.userInfo?["handler"] as? (Int, Int)
        
        let s: ((Character) -> Void) = { [weak self] letter in
            self!.gridView!.handleLetterSelection(letter, x!)
        }
        
        
        keyboardView!.letterTapped = s
        keyboardView!.onFinish = {
            self.hideKeyboard()
        }
    }
    
    @objc func updateWord(_ notification: Notification) {
        if let state = notification.userInfo?["word"] as? String {
            wordView?.text = state
        }
    }
    
    @objc func updateTextView(_ notification: Notification) {
        
        if (game != nil) {
            scoreBoard.setInfo(game!.getInfo())
        }        
        
       if let state = notification.userInfo?["local"] as? Bool {
                            
           if (state) {
               titleView.text = "your_turn".translate(to: notification.userInfo?["lang"] as? String ?? "en")
           } else {
               titleView.text = "wait".translate(to: notification.userInfo?["lang"] as? String ?? "en")
           }
           
           if (state) {
               scoreBoard.setCurrentOne()
           } else {
               scoreBoard.setCurrentTwo()
           }
       }
        
        let state = notification.userInfo?["winner"] as? Game.GAME_RESULT;
        
        if (state != nil){
            switch(state!) {
            case .TIE:
                titleView.text = "tie".translate(to: notification.userInfo?["lang"] as? String ?? "en")
            case .LOCAL_LOOSE:
                titleView.text = "def".translate(to: notification.userInfo?["lang"] as? String ?? "en")
            case .LOCAL_WIN:
                titleView.text = "win".translate(to: notification.userInfo?["lang"] as? String ?? "en")
            }
        }
   }
    
    
    public func getGridBottom(_ size: Int) -> Double {
        let _totalMargin = 10.0
        let avW = view.bounds.width*0.95
        let _cellWidth = avW / Double(size)
        
        
        let res = 4.0*_totalMargin + (Double(size) * _cellWidth);
        
        if res > view.bounds.height*0.55 {
            return view.bounds.height*0.55
        }
        return res;
    }
    
    
    func initGrid() -> GridView {
        let gridView = GridView()
        gridView.backgroundColor = .clear
        gridView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //gridView.frame = CGRect(x: 0, y: view.bounds.height*0.10, width: view.bounds.width, height: getGridBottom(gridState!.grid.count))
        titleView.frame = CGRect(x: 20, y: 10, width: view.bounds.width - 10, height: 100)
                
        isAccessibilityElement = true
        view.addSubview(titleView)
        
        //bottomPanel.removeFromSuperview()
        view.addSubview(bottomPanel)
        
        view.accessibilityIdentifier = "view"
        //bottomPanel.frame = CGRect(x: 0, y: view.bounds.height - 50, width: view.bounds.width, height: 50)
        
        var w = view.bounds.width*0.5
        var pos = (view.bounds.width - w)/2
        
        if (gridState == nil) {
            gridState = GameGridState(Words.getRandomWord(Size.FIVE.getGridSize(), Level.HARD, Lang.RUS)!,
                                            Size.FIVE, 0, Level.MEDIUM, Lang.RUS, "Игрок",
                                            UserPic.allCases[Int.random(in: 0..<UserPic.allCases.count)]);
        }
        
        
        let wordFrame = CGRect(x: pos, y: getGridBottom(gridState!.grid.count) + 10, width: w, height: 50)
        
        let wordView = OvalLabel(frame: wordFrame)
            
        view.addSubview(wordView)
        self.wordView = wordView
        

        
        return gridView
    }
    
    
    @objc func screenTapped() {
     
         
        
       /* let f = LetterKeyboardView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        f.backgroundColor = .clear
        f.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(f)*/
    }
    
    @objc func skipStepPressed() { 
        game?.view.allowLocalInput = false
        undoSelectionPressed()
        self.game!.resetAndSkipStep()
    }
    
    func viewControllerDidDismiss(_ level: Level, _ lang: Lang, _ size: Size, _ name: String, _ pic: UserPic) {
        self.gridView?.removeFromSuperview()
        self.gridState = GameGridState(Words.getRandomWord(size.getGridSize(), Level.HARD, lang)!, size, 0, level, lang, name, pic);
        self.wordView?.removeFromSuperview()
        self.initGame();
        
       /* GameCreator.shared.viewController = self
        GameCreator.shared.createGameAndGenerateLink(completion: { (k,v) in
            var i: Int = 0
            i += 1
        })*/
    }

    @objc func nextGamePressed() {
        let menuVC = StartMenuViewController(self, game!.state.level, game!.state.lang, game!.state.size, game!.state.name1, game!.state.userPic1)
        
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
        var word = gridView!.returnSelectedValues()
        
        let res = game?.__finishStep()
        if (res != nil) {
            hideKeyboard()
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
                
                if (word != nil) {
                    scoreBoard.highlightWord(word!.0)
                }
             
            }
        }
        
    }

    @objc func undoSelectionPressed() {
        hideKeyboard()
        game?.__cancelSelection()
    }
    
    private func hideKeyboard() {
        if (keyboardView != nil) {
            keyboardView!.isHidden = true
            scoreBoard.isHidden = !keyboardView!.isHidden
        }
    }

}
