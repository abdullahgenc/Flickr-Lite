//
//  ProfileViewController.swift
//  flickr app
//
//  Created by Abdullah Genc on 18.10.2022.
//

import UIKit
import FirebaseAuth

final class ProfileViewController: FViewController {
    
    private let viewModel: ProfileViewModel
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile"
        
        let nib = UINib(nibName: "PhotoCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "logout"), for: .normal)
        button.addTarget(self, action: #selector(self.clickedSignOut), for: .touchUpInside)
        let rightButtonBar = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = rightButtonBar

        viewModel.fetchFavorites { error in
            if let error = error {
                self.showError(error)
            } else {
                self.collectionView.reloadData()
            }
        }

        viewModel.fetchBookmarks { error in
            if let error = error {
                self.showError(error)
            } else {
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBAction func didValueChangedSegmentedControl(_ sender: UISegmentedControl) {
        let title = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
        if title == "Favorites" {
            viewModel.fetchFavorites { error in
                if let error = error {
                    self.showError(error)
                } else {
                    self.collectionView.reloadData()
                }
            }
        } else {
            viewModel.fetchBookmarks { error in
                if let error = error {
                    self.showError(error)
                } else {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    @objc
    private func clickedSignOut() {
        showAlert(title: "Warning", message: "Are you sure to sign out?", cancelButtonTitle: "Cancel") { _ in
            print("SIGNED OUT")
            do {
                try Auth.auth().signOut()
                self.tabBarController?.navigationController?.popToRootViewController(animated: true)
            } catch {
                self.showError(error)
            }
        }
    }
    
}

extension ProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        print("TAPPED")
    }
    
}

extension ProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCollectionViewCell
        
        guard let photo = viewModel.photoForIndexPath(indexPath) else { fatalError("photo not found") }
        print(photo.title)
        cell.photoImageView.kf.setImage(with: photo.photoImageUrl)
        
        return cell
    }
}
