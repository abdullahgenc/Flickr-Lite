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
            case .didPhotoAddedToFavorites(let indexPath):
                let cell = self.tableView.cellForRow(at: indexPath) as! PhotoTableViewCell
                cell.likeButton.setImage(UIImage(named: "heart.fill"), for: .normal)
            case .didPhotoAddedToBookmarks(let indexPath):
                let cell = self.tableView.cellForRow(at: indexPath) as! PhotoTableViewCell
                cell.bookmarkButton.setImage(UIImage(named: "bookmark.fill"), for: .normal)
                
            }
        }
    }
}

extension RecentListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(tableView.cellForRow(at: indexPath)?.tag)
        
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
        cell.photoImageView.kf.setImage(with: photo.photoImageUrl) { _ in
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.delegate = self
        cell.likeButton.tag = indexPath.row
        cell.bookmarkButton.tag = indexPath.row

        return cell
    }
    
}

extension RecentListViewController: PhotoTableViewCellDelegate {
    func photoTableViewCell(likeButton button: UIButton) {
        print("----")
        if button.image(for: .normal)?.pngData() == (UIImage(named: "heart.fill")?.pngData()) {
            print("REMOVED FROM FAVORITE")

            button.setImage(UIImage(named: "heart"), for: .normal)

        } else {
            let indexPath = IndexPath(row: button.tag, section: .zero)
            viewModel.addFavorite(indexPath)
        }
    }
    
    func photoTableViewCell(bookmarkButton button: UIButton) {
        print("----")
        if button.image(for: .normal)?.pngData() == (UIImage(named: "bookmark.fill")?.pngData()) {
            print("REMOVED FROM FAVORITE")

            button.setImage(UIImage(named: "bookmark"), for: .normal)

        } else {
            let indexPath = IndexPath(row: button.tag, section: .zero)
            viewModel.addBookmark(indexPath)
        }
    }
}
