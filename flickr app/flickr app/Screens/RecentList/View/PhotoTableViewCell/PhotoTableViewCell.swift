//
//  PhotoTableViewCell.swift
//  flickr app
//
//  Created by Abdullah Genc on 16.10.2022.
//

import UIKit

protocol PhotoTableViewCellDelegate: AnyObject {
    func photoTableViewCell(likeButton button: UIButton)
    func photoTableViewCell(bookmarkButton button: UIButton)
}

class PhotoTableViewCell: UITableViewCell {
    
    weak var delegate: PhotoTableViewCellDelegate?
    
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
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var bookmarkButton: UIButton!
    
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

    }
    
    @IBAction func didTapLikeButton(_ sender: UIButton) {
        self.delegate?.photoTableViewCell(likeButton: self.likeButton)
    }
    
    @IBAction func didTapBookmarkButton(_ sender: UIButton) {
        self.delegate?.photoTableViewCell(bookmarkButton: self.bookmarkButton)
    }
}
