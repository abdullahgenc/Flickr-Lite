//
//  RecentListViewController.swift
//  flickr app
//
//  Created by Abdullah Genc on 16.10.2022.
//

import UIKit
import Kingfisher

final class RecentListViewController: FViewController {
    
    private var viewModel: RecentListViewModel
    
    private var favTags = [Int]()
    
    private var bookTags = [Int]()
    
    @IBOutlet private weak var tableView: UITableView!

    init(viewModel: RecentListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Recent Posts"
        
        tabBarController?.navigationItem.hidesBackButton = true
        
        let nib = UINib(nibName: "PhotoTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        viewModel.fetchRecentList()
        
        viewModel.changeHandler = {change in
            switch change {
            case .didFetchList:
                self.tableView.reloadData()
            case .didErrorOccurred(let error):
                self.showError(error)
            }
        }
    }
}

extension RecentListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped row: \(indexPath.row)")
    }
    
}

extension RecentListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotoTableViewCell
        
        guard let photo = viewModel.photoForIndexPath(indexPath) else {
            fatalError("photo not found")
        }
        cell.userName = photo.ownername
        cell.title = (photo.title == "") ? "-- No Description --" : photo.title
        cell.profileImageView.kf.setImage(with: photo.profileImageUrl)
        cell.photoImageView.kf.setImage(with: photo.photoImageUrl)
        cell.delegate = self
        cell.likeButton.tag = indexPath.row
        cell.bookmarkButton.tag = indexPath.row
        
        if favTags.contains(indexPath.row) {
            cell.likeButton.setImage(UIImage(named: "heart.fill"), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(named: "heart"), for: .normal)
        }
        
        if bookTags.contains(indexPath.row) {
            cell.bookmarkButton.setImage(UIImage(named: "bookmark.fill"), for: .normal)
        } else {
            cell.bookmarkButton.setImage(UIImage(named: "bookmark"), for: .normal)
        }
        return cell
    }
}

extension RecentListViewController: PhotoTableViewCellDelegate {
    
    func photoTableViewCell(likeButton button: UIButton) {
        let indexPath = IndexPath(row: button.tag, section: .zero)
        if favTags.contains(button.tag) {
            let index = favTags.firstIndex(of: button.tag)
            favTags.remove(at: index!)
            button.setImage(UIImage(named: "heart"), for: .normal)
            viewModel.removeFavorite(indexPath)
        } else {
            favTags.append(button.tag)
            button.setImage(UIImage(named: "heart.fill"), for: .normal)
            viewModel.addFavorite(indexPath)
        }
    }
    
    func photoTableViewCell(bookmarkButton button: UIButton) {
        let indexPath = IndexPath(row: button.tag, section: .zero)
        if bookTags.contains(button.tag) {
            let index = bookTags.firstIndex(of: button.tag)
            bookTags.remove(at: index!)
            button.setImage(UIImage(named: "bookmark"), for: .normal)
            viewModel.removeBookmark(indexPath)
        } else {
            bookTags.append(button.tag)
            button.setImage(UIImage(named: "bookmark.fill"), for: .normal)
            viewModel.addBookmark(indexPath)
        }
    }
}
