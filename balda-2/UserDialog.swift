import UIKit

class UserEdit: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var imageView: UIImageView
    var label: UILabel
    
    init(imageView: UIImageView, label: UILabel) {
        self.imageView = imageView
        self.label = label
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.imageView = UIImageView()
        self.label = UILabel()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUserView()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userViewTapped))
        imageView.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
    }

    private func setupUserView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    @objc private func userViewTapped() {
        let alertController = UIAlertController(title: "Edit Profile", message: nil, preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "Enter name"
            textField.text = "123123"
        }

        let selectPhotoAction = UIAlertAction(title: "Select Photo", style: .default) { _ in
            self.showImagePicker()
        }

        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let textField = alertController.textFields?.first, let text = textField.text {
              //  self.userView.nameLabel.text = "23423432"
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(selectPhotoAction)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    private func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            //userView.imageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
