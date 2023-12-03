import UIKit

class ScoreBoardView: UIView {
    private var player1View: PlayerView!
    private var player2View: PlayerView!
    
    private let closeButton: UIButton = {
       let button = UIButton(type: .system)
       button.setTitle("Close", for: .normal)
       button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
       return button
    }()
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Check if the touch is within this view's bounds
        if self.bounds.contains(point) {
            // Let subviews have a chance to handle the touch
            let subviewHitTest = super.hitTest(point, with: event)
            if subviewHitTest != nil {
                return subviewHitTest
            }
            
            // If no subviews handle the touch, this view will handle it
            return self
        }
        
        // If the touch is outside this view's bounds, return nil
        return self
    }
    
    
    @objc private func closeButtonTapped() {
        removeFromSuperview()
    }

    init(frame: CGRect, info: Info) {
        super.init(frame: frame)
        
        setupViews()
        
        player1View.setPlayer(name: info.opponentInfo1.name, score: info.opponentInfo1.score, words: info.opponentInfo1.words, fails: info.opponentInfo1.fails)
        player2View.setPlayer(name: info.opponentInfo2.name, score: info.opponentInfo2.score, words: info.opponentInfo2.words, fails: info.opponentInfo2.fails)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        player1View = PlayerView()
        player2View = PlayerView()
        
        addSubview(player1View)
        addSubview(player2View)
        addSubview(closeButton)

        NSLayoutConstraint.activate([
            player1View.leadingAnchor.constraint(equalTo: leadingAnchor),
            player1View.topAnchor.constraint(equalTo: topAnchor),
            player1View.bottomAnchor.constraint(equalTo: bottomAnchor),
            player1View.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),

            player2View.trailingAnchor.constraint(equalTo: trailingAnchor),
            player2View.topAnchor.constraint(equalTo: topAnchor),
            player2View.bottomAnchor.constraint(equalTo: bottomAnchor),
            player2View.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8), // Changed this line
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            
            
        ])
        

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        player1View.translatesAutoresizingMaskIntoConstraints = false
        player2View.translatesAutoresizingMaskIntoConstraints = false
        
    }
}


class PlayerView: UIView {
    private let nameLabel = UILabel()
    private let scoreLabel = UILabel()
    private let wordsList = UITextView()
    
    init() {
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var wordsListHeightConstraint: NSLayoutConstraint!

    
    func setPlayer(name: String, score: Int, words: [String], fails: [Int]) {
        nameLabel.text = name
        scoreLabel.text = "Score: \(score)"
        let attributedString = NSMutableAttributedString()
        for (i, word) in words.enumerated() {
            if fails.contains(i) {
                // If the word is the one to cross out, apply strikethrough
                let str = NSAttributedString(string: "\(word)\n", attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
                attributedString.append(str)
            } else {
                // Otherwise, add it normally
                let str = NSAttributedString(string: "\(word)\n")
                attributedString.append(str)
            }
        }
        wordsList.attributedText = attributedString
        wordsList.isEditable = false
        wordsList.isSelectable = false
        wordsList.textColor = .white
        wordsList.backgroundColor = .black

        setupViews()
    }
    
    func heightForText(_ text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let textStorage = NSTextStorage(string: text, attributes: [.font: font])
        let textContainer = NSTextContainer(size: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        layoutManager.glyphRange(for: textContainer)
        return layoutManager.usedRect(for: textContainer).height
    }
    
    private func setupViews() {
    
    
        nameLabel.font = .boldSystemFont(ofSize: 24)
        scoreLabel.font = .systemFont(ofSize: 20)
        wordsList.font = .systemFont(ofSize: 20)

        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, scoreLabel, wordsList])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
}
