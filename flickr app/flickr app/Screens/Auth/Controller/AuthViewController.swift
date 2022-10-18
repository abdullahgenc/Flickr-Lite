//
//  AuthViewController.swift
//  flickr app
//
//  Created by Abdullah Genc on 18.10.2022.
//

import UIKit
import FirebaseAuth

final class AuthViewController: UIViewController {
    
    enum AuthType: String {
        case signIn = "Sign In"
        case signUp = "Sign Up"
        
        init(text: String) {
            switch text {
            case "Sign In":
                self = .signIn
            case "Sign Up":
                self = .signUp
            default:
                self = .signIn
            }
        }
    }
    
    var authType: AuthType = .signIn {
        didSet {
            titleLabel.text = title
            confirmButton.setTitle(title, for: .normal)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var credentionTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Auth"
    }
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        
        guard let credential = credentionTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        switch authType {
        case .signIn:
            Auth.auth().signIn(withEmail: credential, password: password) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                print("success")
            }
        case .signUp:
            Auth.auth().createUser(withEmail: credential, password: password) { authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
        }
    }
    
    @IBAction func didValueChangedSegmentedControl(_ sender: UISegmentedControl) {
        let title = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
        authType = AuthType(text: title ?? "Sign In")
    }
}
