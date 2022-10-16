//
//  RecentListViewController.swift
//  flickr app
//
//  Created by Abdullah Genc on 16.10.2022.
//

import UIKit

final class RecentListViewController: UIViewController {
    
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        viewModel.fetchRecentList()
        
        viewModel.changeHandler = {change in
            switch change {
            case .didFetchList:
                self.tableView.reloadData()
            case .didErrorOccured(let error):
                print(error.localizedDescription)
            }
        }

        // Do any additional setup after loading the view.
    }
}

extension RecentListViewController: UITableViewDelegate {
    
    
    
}

extension RecentListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.photoForIndexPath(indexPath)?.ownername
        return cell
    }
    
    
}

// key : 0abf7d115f6645b13e0e48902dab7f8b
// secret : a1d613624e986eaf
// format : https://live.staticflickr.com/{server-id}/{id}_{secret}_{size-suffix}.jpg




