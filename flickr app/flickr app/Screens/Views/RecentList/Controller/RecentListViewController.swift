//
//  RecentListViewController.swift
//  flickr app
//
//  Created by Abdullah Genc on 16.10.2022.
//

import UIKit
import Kingfisher

final class RecentListViewController: UIViewController {
    
    private var viewModel: PhotoViewModel
    
    @IBOutlet private weak var tableView: UITableView!

    init(viewModel: PhotoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Recent Posts"
        
        let nib = UINib(nibName: "PhotoTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        viewModel.fetchRecentList()
        
        viewModel.changeHandler = {change in
            switch change {
            case .didFetchList:
                self.tableView.reloadData()
            case .didErrorOccured(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension RecentListViewController: UITableViewDelegate {
    
    
    
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
        return cell
    }
    
    
}



