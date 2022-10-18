//
//  PhotoTableViewCell.swift
//  flickr app
//
//  Created by Abdullah Genc on 16.10.2022.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    var userName: String? {
        set {
            userNameLabel.text = newValue
        }
        get {
            userNameLabel.text
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title ?? "No Title."
        }
    }

    @IBOutlet private(set) weak var profileImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private(set) weak var photoImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.cornerRadius = 20.0
        
        photoImageView.layer.masksToBounds = true
        photoImageView.layer.borderWidth = 0.2
        profileImageView.layer.borderColor = UIColor.black.cgColor
        photoImageView.layer.cornerRadius = 20.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapLikeButton(_ sender: UIButton) {
    }
    
    @IBAction func didTapBookmarkButton(_ sender: UIButton) {
    }
    
    
}
