import UIKit

class OvalLabel: UIView {

    var label: UILabel!

    var text: String? {
        didSet {
            updateLabelVisibility()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
        updateLabelVisibility()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLabel() {
        label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hex: "#DF5386")
        label.font = UIFont.boldSystemFont(ofSize: 25)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            label.font = UIFont.boldSystemFont(ofSize: 35)
        }
        
        let backgroundImageView = UIImageView(frame: self.bounds)
        backgroundImageView.image = UIImage(named: "hint_back")
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundImageView)
        sendSubviewToBack(backgroundImageView)

        addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
          
            backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.widthAnchor.constraint(equalTo: widthAnchor),
            label.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        
    }

    private func updateLabelVisibility() {
        
        label.text = text
        isHidden = text?.isEmpty ?? true
        setNeedsDisplay()
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.height / 6
        layer.masksToBounds = true
     //   layer.borderWidth = 4
       // layer.borderColor = UIColor.white.cgColor
    }
}
