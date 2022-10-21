//
//  AuthViewController.swift
//  flickr app
//
//  Created by Abdullah Genc on 18.10.2022.
//

import UIKit

final class AuthViewController: FViewController {
    
    private let viewModel: AuthViewModel
    
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
    
    var segmentedTitle: String = "Sign In"
    
    var authType: AuthType = .signIn {
        didSet {
            titleLabel.text = segmentedTitle
            confirmButton.setTitle(segmentedTitle, for: .normal)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var credentionTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.changeHandler = { change in
            switch change {
            case .didErrorOccurred(let error):
                self.showError(error)
            case .didSignUpSuccessful:
                self.showAlert(title: "SIGN UP SUCCESSFUL!")
            }
        }
        
        title = "Auth"
        
        viewModel.fetchRemoteConfig { isSignUpDisabled in
            self.segmentedControl.isHidden = isSignUpDisabled
        }
    }
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        
        guard let credential = credentionTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        switch authType {
        case .signIn:
            
            viewModel.signIn(email: credential, password: password) { [weak self] in
                guard let self = self else { return }
                
                let images = ["home", "search", "person"]
                let titles = ["Recent Posts", "Search", "Profile"]

                let recentViewController = RecentListViewController(viewModel: RecentListViewModel())
                let recentNavigationController = UINavigationController(rootViewController: recentViewController)
                
                let searchViewController = SearchPhotoViewController(viewModel: SearchPhotoViewModel())
                let searchNavigationController = UINavigationController(rootViewController: searchViewController)
                
                let profileViewController = ProfileViewController(viewModel: ProfileViewModel())
                let profileNavigationController = UINavigationController(rootViewController: profileViewController)

                let tabBarController = UITabBarController()
                tabBarController.viewControllers = [recentNavigationController, searchNavigationController, profileNavigationController]

                guard let items = tabBarController.tabBar.items else {
                    return
                }
                for x in 0..<items.count {
                    items[x].image = UIImage(named: images[x])
                    items[x].title = titles[x]
                }

                self.navigationController?.pushViewController(tabBarController, animated: true)
            }
        case .signUp:
            viewModel.signUp(email: credential, password: password)
        }
    }
    
    @IBAction func didValueChangedSegmentedControl(_ sender: UISegmentedControl) {
        segmentedTitle = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
        authType = AuthType(text: segmentedTitle)
    }
}
