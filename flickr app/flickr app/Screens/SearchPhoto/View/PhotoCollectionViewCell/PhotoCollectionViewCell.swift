//
//  PhotoCollectionViewCell.swift
//  flickr app
//
//  Created by Abdullah Genc on 18.10.2022.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.layer.masksToBounds = true
        photoImageView.layer.borderWidth = 1.0
        photoImageView.layer.borderColor = UIColor.black.cgColor
        photoImageView.layer.cornerRadius = 10.0
    }

}
