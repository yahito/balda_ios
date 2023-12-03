import UIKit

class OvalLabel: UIView {

    private var label: UILabel!

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
        label.backgroundColor = .darkGray
        label.textColor = .white

        addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.widthAnchor.constraint(equalTo: widthAnchor),
            label.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }

    private func updateLabelVisibility() {
        label.text = text
        isHidden = text?.isEmpty ?? true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.height / 6
        layer.masksToBounds = true
     //   layer.borderWidth = 4
       // layer.borderColor = UIColor.white.cgColor
    }
}
