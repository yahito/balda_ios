import UIKit
import SpriteKit
import GameplayKit
import CoreGraphics

class GridView: UIView, CAAnimationDelegate {
    
    private let cellImage = UIImage(named: "cellImage")
    //private var selectedCell: (row: Int, column: Int)?
    private var isUpdatingCells = false
    private var currentSelectedCells: [(Int, Int)] = []
    private var cellCallback: (Bool) -> Void = {w in}
    private var userSelection = false
    private var allowBombs = false
    private var glowingCells: [UIView] = []
    private var lettersCells: [[CustomUITextField]] = []
    
    
    private var allowLocalInput = false
    
    private let selectedTextLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    fileprivate func refreshCell(_ k: GridView.CustomUITextField) {
        if (k.layer.shadowOpacity > 0) {
            k.layer.shadowColor = UIColor.clear.cgColor
            k.layer.shadowOpacity = 0
            k.layer.removeAllAnimations()
            k.setBackgroundImage(UIImage(named: "grid_cell"), for: .normal)
        }
    }
    
    fileprivate func refreshAllCells() {
        self.lettersCells.forEach {w in
            w.forEach{ k in
                refreshCell(k)
            }
        }
    }
    
    func refreshAllCellsRed() {
        self.lettersCells.forEach {w in
            w.forEach{ k in
                if (k.layer.shadowOpacity > 0) {
                    highLightCell(k, UIColor.red.cgColor)
                }
            }
        }
    }
    
    @objc public func cancelSelection() {
        game!.resetStep()
        userSelection = false
        currentSelectedCells.removeAll()
        refreshAllCells()
        updateSelectedText2()
    }
    
    private func updateSelectedText() {
        
        let selectedText = cellsToHighlight!.map { point -> String in
            return String(game!.state.grid[point.0][point.1])
        }.joined()
        
        if (!selectedText.isEmpty) {
          //  cancelButton.isHidden = false
        }
        
        selectedTextLabel.text = selectedText
      
    }
    
    private func updateSelectedText2() {
        
        let selectedText = currentSelectedCells.map { point -> String in
            return String(game!.state.grid[point.0][point.1])
        }.joined()
        
        selectedTextLabel.text = selectedText
        NotificationCenter.default.post(name: .wordChanged, object: nil, userInfo: ["word": selectedText]);
        setNeedsDisplay()
    }

    private var forward: Bool = true
    private var cellsToHighlight: [(Int, Int)]? {
        didSet {
            if !isUpdatingCells {
                //updateL()
                updateSelectedText()
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.highlightNextCell(self.forward)
                }
            }
        }
    }
    
    func getHiglightedCells() -> [(Int, Int)] {
        return currentSelectedCells
    }
    
    func setCellsToHighlight(_ cells: [(Int, Int)], _ cellCallback: @escaping (Bool) -> Void, _ forward: Bool) {
        if (!forward) {
            //refreshAllCellsRed()
        }
        self.forward = forward
        isUpdatingCells = false
        self.cellCallback = cellCallback
        self.cellsToHighlight = cells
    }
    
    private func highlightNextCell(_ highlight: Bool) {
        isUpdatingCells = true
        guard let cell = self.cellsToHighlight?.first else {
            // All cells have been highlighted, wait for an additional 2 seconds
            // then clear the highlights.
            DispatchQueue.main.asyncAfter(deadline: .now() + (highlight ? 0.5 : 0.05)) {
                self.refreshAllCells()
                self.setNeedsDisplay()
                self.isUpdatingCells = false
                self.cellCallback(false)
            }
            return
        }
        
        print(cell)
        print(lettersCells[cell.0][cell.1].titleLabel?.text)
        
        if lettersCells[cell.0][cell.1].explode {
            addBurst(lettersCells[cell.0][cell.1], {})
            return
        }
        
        if (highlight) {
            highLightCell(lettersCells[cell.0][cell.1], UIColor.blue.cgColor)
        } else {
            var d = UIColor(red: 10000.0, green: 0, blue: 0, alpha: 100)
            highLightCell(lettersCells[cell.0][cell.1], d.cgColor)
        }
        
        self.cellsToHighlight?.removeFirst()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (highlight ? 0.5 : 0.05)) {
            self.highlightNextCell(highlight)
        }
        isUpdatingCells = false
    }
    
    var game: Game? {
        didSet {
            let gridSize = game!.state.size.getGridSize()
            
            cellWidth = min(availableWidth / Double(gridSize), availableHeight / Double(gridSize)) // Ensure square cells and fit within the view
            
            updateL()
            setNeedsDisplay()
        }
    }
    
    override func layoutSubviews() {
         super.layoutSubviews()
        selectedTextLabel.frame = CGRect(x: 10, y: bounds.height - 40, width: bounds.width - 80, height: 30)
      /*  cancelButton.frame = CGRect(x: bounds.width - 70, y: bounds.height - 40, width: 60, height: 30)
        nextButton.frame = CGRect(x: bounds.width - 140, y: bounds.height - 40, width: 60, height: 30)
        okButton.frame = CGRect(x: bounds.width - 210, y: bounds.height - 40, width: 60, height: 30)
        skipButton.frame = CGRect(x: bounds.width - 280, y: bounds.height - 40, width: 60, height: 30)
     */
       }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        //self.addGestureRecognizer(tap)
        
        totalMargin = bounds.width * 0.05
        availableWidth = bounds.width - 2 * totalMargin
        availableHeight = bounds.height - 2 * totalMargin
       
      /*
        addSubview(selectedTextLabel)
        addSubview(cancelButton)
        addSubview(nextButton)
        addSubview(okButton)
        addSubview(skipButton)*/
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func handleLetterSelection(_ letter: Character, _ cell: (Int, Int)) {
      
            // Update the game state for the selected cell with the chosen letter.
        game?.setLetter(cell.0, cell.1, letter)
        setNeedsDisplay() // to redraw the grid
        
        
        setVisibleValue(lettersCells[cell.0][cell.1], letter)
        userSelection = true;
        
    }
   
   @objc func handleTap(recognizer: UITapGestureRecognizer) {
       
       
   }
    
    
    class CustomUITextField: UIButton {
        var customId: (Int, Int) = (0,0)
        var candidate: Bool = false
        var ocupied: Bool = false
        var explode = false
    }

    
    
    fileprivate func setVisibleValue(_ uiField: CustomUITextField, _ letterChar: Character) {
        if (game!.isAlphabetCharacter(letterChar)) {
            uiField.setTitle(String(letterChar), for: .normal)
            uiField.ocupied = true
            uiField.candidate = false
        } else {
            if (Constants.isLetterPlaceholder(letterChar)) {
                uiField.candidate = true
            } else {
                uiField.candidate = false
            }
            uiField.setTitle("", for: .normal)
            uiField.ocupied = false
        }
        
        uiField.explode = false
        
    }
    
    public func getGridBottom(_ size: Int) -> Double {
        let _totalMargin = bounds.minY + bounds.width * 0.05
        let _cellWidth = min(availableWidth / Double(size), availableHeight / Double(size))
        return 4*_totalMargin + (Double(size) * _cellWidth);
    }
    
    private func updateL() {
        let b = getBomb()
        
        if b != nil {
            self.lettersCells[b!.0][b!.1].setTitle(String(""), for: .normal)
        }
        
        if let game {
            for i in 0..<game.state.size.getGridSize() {
                for j in 0..<game.state.size.getGridSize() {
                    let letterChar: Character! = game.state.grid[i][j]
                                          
                    if lettersCells.count > i && lettersCells[i].count > j {
                        setVisibleValue(lettersCells[i][j], letterChar)
                        continue
                    }
                    
                    let cellRect = CGRect(x: totalMargin + CGFloat(j) * cellWidth, y: totalMargin + CGFloat(i) * cellWidth, width: cellWidth, height: cellWidth)
                    
                                
                    let textField = CustomUITextField(frame: cellRect) // Adjust width and height as necessary.
                  
                    
                    setVisibleValue(textField, letterChar)
                    
                    textField.backgroundColor = .clear
                    textField.customId = (i, j)
                    textField.layer.borderWidth = 1
                    
                    textField.addTarget(self, action: #selector(showKeyboard(_:)), for: .touchUpInside)
                    
                    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
                    textField.addGestureRecognizer(panGesture)
                    
                    // Position textField in the center of glowView.
                    textField.titleLabel?.textAlignment = .center
                    textField.setBackgroundImage(UIImage(named: "grid_cell"), for: .normal)
                    textField.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40);
                    addSubview(textField)
                    
                    if (lettersCells.count <= i) {
                        lettersCells.append([])
                    }
                    lettersCells[i].append(textField)
                }
            }
        }
        
    }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        
        self.lettersCells.forEach {w in
            w.forEach{ k in

                let location = recognizer.location(in: k)
                       
                k.isUserInteractionEnabled = true
                
                if k.bounds.contains(location) {
                    showKeyboard(k)
                }
            }
        }
        
     
    }
    
    fileprivate func highLightCell(_ sender: GridView.CustomUITextField, _ color: CGColor) {
        
        sender.setBackgroundImage(UIImage(named: "selected_cell"), for: .normal)
        // Apply glow effect
        sender.layer.shadowColor = color;
        
        sender.layer.shadowOffset = CGSize(width: 1.0, height: 5.0)
        sender.layer.masksToBounds = false
        sender.layer.shadowRadius = 2.0
        sender.layer.shadowOpacity = 1
        sender.layer.cornerRadius = 4
        
        sender.layer.borderWidth = 1.0
        
        sender.layer.masksToBounds = true
        
        let shadowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        shadowAnimation.fromValue = 6.0
        shadowAnimation.toValue = 10.0
        shadowAnimation.duration = 0.5
        
        shadowAnimation.autoreverses = true
        shadowAnimation.repeatCount = .infinity
        
        
        sender.layer.add(shadowAnimation, forKey: "shadowPulse")
    }
    
    fileprivate func initBomb(_ p: (Int, Int)) {
        lettersCells[p.0][p.1].explode = true
        if !lettersCells[p.0][p.1].ocupied {
            lettersCells[p.0][p.1].setTitle("💣", for: .normal)
        }
    }
    
    @objc private func showKeyboard(_ sender: CustomUITextField) {
        
        if !allowLocalInput {
            return
        }
        
        if (!sender.candidate && !sender.ocupied) {
            return
        }
        
       // if !keyboardView!.isDescendant(of: self) {
            if (userSelection) {
                
               
                if (!(sender.title(for: .normal)?.isEmpty ?? true)) {
                    
                    if ((getBomb() ?? nil) != nil && (getBomb() ?? (1,1) == sender.customId)) {
                        return
                    }
                    
                    let last = currentSelectedCells.last
                    
                    let new = sender.customId
                    
                    if let last {
                        let oneSame = new.0 == last.0 || new.1 == last.1
                        if (!oneSame) {
                        
                            return
                        }
                        if (new.0 == last.0 + 1
                            || new.1 == last.1 + 1
                            || new.0 == last.0 - 1
                            || new.1 == last.1 - 1 ){
                          
                            
                        } else {
                            return
                        }
                    } else {
                        
                    }
                    
                    let toAdd = (sender.customId.0, sender.customId.1)
                
                    if !currentSelectedCells.contains(where: { $0 == toAdd }) {
                        currentSelectedCells.append(toAdd)
                        updateSelectedText2()
                        
                        highLightCell(sender, UIColor.blue.cgColor)
                    }
                    
                
                } else {
                    if sender.candidate && allowBombs && getBomb() == nil && (selectedTextLabel.text?.count ?? 0) > 0 {
                        initBomb(sender.customId)
                        return
                    }
                }
                
                return;
            }
        
            
            if (sender.candidate && sender.title(for: .normal)?.isEmpty ?? true) {
                //keyboardView = LetterKeyboardView(frame: CGRect(x: 0, y: 400, width: frame.width, height: frame.height/3))
              
                
                updateSelectedText2()
             //   selectedCell = (sender.customId.0, sender.customId.1)
    
                NotificationCenter.default.post(name: .showKeyboard, object: nil, userInfo: ["handler": sender.customId]);
            }
      //  }
    }
    
    private var totalMargin = 0.0;
    private var availableWidth = 0.0;
    private var availableHeight = 0.0;
    private var cellWidth = 0.0;
    
    func setBomb(_ b: (Int, Int)) {
        allowBombs = true
        initBomb(b)
    }
    
    func getBomb() -> (Int, Int)? {
        if !allowBombs {
            return nil
        }
        
        for i in 0..<self.lettersCells.count {
            for j in 0..<self.lettersCells[i].count {
                if self.lettersCells[i][j].title(for: .normal) == "💣" {
                    return self.lettersCells[i][j].customId;
                }
            }
        }
        
        return nil
    }
   
    func locationForRowAndColumn(row: Int, column: Int) -> CGRect {

    
        let x = totalMargin + CGFloat(column) * cellWidth
        let y = totalMargin + CGFloat(row) * cellWidth

        return CGRect(x: x, y: y, width: cellWidth, height: cellWidth)
    }
   
    
    public func localInput(_ allowBombs: Bool) {
        self.allowLocalInput = true
        self.allowBombs = allowBombs
    }
    
    public func endLocalInput() {
       // if (self.allowLocalInput) {
            var b = getBomb()
            
            if b != nil {
                self.lettersCells[b!.0][b!.1].setTitle(String(""), for: .normal)
            }
                
            self.allowLocalInput = false
            refreshAllCells()
            currentSelectedCells.removeAll()
            userSelection = false
            allowBombs = false       
            cellCallback = {b in}
            
   //     }
    }
    
    func returnSelectedValues() -> (String, [(Int, Int)], (Int, Int)?)? {
        if (selectedTextLabel.text != nil) {
            return (selectedTextLabel.text!, currentSelectedCells, getBomb())
        }

        return nil
    }
    
    private func addBurst(_ buttonField : GridView.CustomUITextField, _ cb: @escaping () -> Void) {
        if let fireLayer = buttonField.layer.sublayers?.first(where: { $0 is CAEmitterLayer }) as? CAEmitterLayer {
            fireLayer.birthRate = 0
        }
       
           // Create the explosion effect
        var explosionLayer = createFireEmitter(buttonField, 0.5)
           
        buttonField.layer.addSublayer(explosionLayer)
   
       // Remove the explosion effect after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.dfdd()
            explosionLayer.removeFromSuperlayer()
            cb()
        }
          
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.layer.sublayers?.forEach {
            if $0 is CAShapeLayer {
                $0.removeFromSuperlayer()
            }
        }
    }
    
    func createFireEmitter(_ buttonField : GridView.CustomUITextField, _ scale: CGFloat) -> CAEmitterLayer {
        let emitterLayer = CAEmitterLayer()
        
        // Position and size
        
        emitterLayer.emitterPosition = CGPoint(x: buttonField.bounds.width/2, y:buttonField.bounds.height/2)
        emitterLayer.emitterSize = CGSize(width: 2, height: 2)
        emitterLayer.emitterShape = .circle
        emitterLayer.renderMode = .additive // Makes the fire blend better

        // Create an emitter cell (the fire particles)
        let fireCell = CAEmitterCell()
        fireCell.contents = UIImage(named: "fireParticle")?.cgImage
        fireCell.birthRate = 300
        fireCell.lifetime = 0.7
        fireCell.velocity = 200
        fireCell.velocityRange = 2
        fireCell.emissionLongitude = CGFloat.pi*1.5
        fireCell.emissionRange = CGFloat.pi
        fireCell.scale = 0.5
        fireCell.scaleSpeed = 0.2
        fireCell.color = UIColor.orange.cgColor
        fireCell.alphaSpeed = -2.0
        
        let animation = CABasicAnimation(keyPath: "scale")
        animation.fromValue = 0.5
        animation.toValue = 4
        animation.duration = 0.1
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        
       emitterLayer.add(animation, forKey: "blastAnimation")


        // Set the emitter layer's emitterCells property
        emitterLayer.emitterCells = [fireCell]
        
        return emitterLayer
    }
    
    func dfdd() {
        self.refreshAllCells()
        self.setNeedsDisplay()
        self.isUpdatingCells = false
        cellCallback(true)
    }
    
    func fireBomb(_ coordinates: (Int, Int)!, _ cb: @escaping () -> Void) {
        refreshAllCells()
        addBurst(lettersCells[coordinates.0][coordinates.1], cb)
    }

}

