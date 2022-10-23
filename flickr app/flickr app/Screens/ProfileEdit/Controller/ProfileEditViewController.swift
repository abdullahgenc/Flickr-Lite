//
//  ProfileEditViewController.swift
//  flickr app
//
//  Created by Abdullah Genc on 23.10.2022.
//

import UIKit
import Kingfisher

final class ProfileEditViewController: FViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    private let viewModel: ProfileEditViewModel
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    init(viewModel: ProfileEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.cornerRadius = 20.0
        
        usernameTextField.layer.masksToBounds = true
        usernameTextField.layer.borderWidth = 0.2
        usernameTextField.layer.borderColor = UIColor.black.cgColor
        usernameTextField.layer.cornerRadius = 20.0
        
        saveButton.layer.masksToBounds = true
        saveButton.layer.cornerRadius = 20.0
        
        viewModel.delegate = self
        usernameTextField.text = viewModel.fetchUsername()
        viewModel.fetchImage()
    }
    
    @IBAction func didTapImageView(_ sender: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        profileImageView.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    @IBAction func didTapSaveButton(_ sender: UIButton) {
        viewModel.saveImagePicker(image: profileImageView.image)
        guard let text = usernameTextField.text else { return }
        viewModel.save(username: text)
    }
}

extension ProfileEditViewController: ProfileEditProtocol {
    func didErrorOccurred(_ error: Error) {
        showError(error)
    }
    
    func didFetchImage(_ image: URL) {
        profileImageView.kf.setImage(with: image)
    }
    
    func didSaveUser() {
        showAlert(title: "Warning", message: "Profile successfully saved!") { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
