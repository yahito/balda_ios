import UIKit

class HintWindow: UIView {

    private var hintLabel: UILabel!
    public var finalText: String = ""
    private var countdownValue: Int = 10 // Set the default countdown duration
    private var countdownTimer: Timer?


    // Initializer for the window
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // Ensure that the timer is invalidated when the view is removed from the superview
    override func removeFromSuperview() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        super.removeFromSuperview()
    }
    
    func updateVisibility(percentage: CGFloat) {
        // Ensure the percentage is between 0 and 1
        self.alpha = max(0, min(1, percentage))
    }
    
    private func commonInit() {
        // Configure the window appearance
        backgroundColor = .white
        layer.cornerRadius = 10
        clipsToBounds = true
        
        // Initialize and add the label
        hintLabel = UILabel()
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.textAlignment = .center
        hintLabel.textColor = .black
        addSubview(hintLabel)
        
        // Constraints for the label
        NSLayoutConstraint.activate([
            hintLabel.topAnchor.constraint(equalTo: topAnchor),
            hintLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            hintLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            hintLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func configure(with text: String, countdown: Int = 3) {
        finalText = text
        countdownValue = countdown
        startCountdown()
    }

    private func startCountdown() {
        countdownTimer?.invalidate() // Invalidate any existing timer
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
        
    @objc private func updateCountdown() {
        if countdownValue > 0 {
            hintLabel.text = "Please wait... \(countdownValue)"
            countdownValue -= 1
        } else {
            countdownTimer?.invalidate()
            countdownTimer = nil
            hintLabel.text = finalText // Set the final text
        }
      }

    // Show the hint window with an animation
    func show(in view: UIView) {
        self.alpha = 0
        view.addSubview(self)
        
        // Center the hint window in the parent view
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        // Animate the appearance
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    // Hide the hint window with an animation
    func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
