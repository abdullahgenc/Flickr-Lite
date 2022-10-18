//
//  SearchPhotoViewController.swift
//  flickr app
//
//  Created by Abdullah Genc on 17.10.2022.
//

import UIKit
import Kingfisher

final class SearchPhotoViewController: UIViewController {

    private var viewModel: PhotoViewModel
    
    @IBOutlet weak var collectionView: UICollectionView!

    init(viewModel: PhotoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search"
        
        let nib = UINib(nibName: "PhotoCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Nature, Celebration..."
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController

        viewModel.fetchSearch(search: "summer")
        
        viewModel.changeHandler = {change in
            switch change {
            case .didFetchList:
                self.collectionView.reloadData()
            case .didErrorOccured(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchPhotoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //searchte fotiye tıklanınca o fotiye uygun detail ekranı yapıp buraya ekle, custom tablecelli kullanabilirsin
//        let detailViewController = DetailViewController()
//        detailViewController.media = mediaResponse?.results?[indexPath.row]
        // navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}

extension SearchPhotoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCollectionViewCell
        
        guard let photo = viewModel.photoForIndexPath(indexPath) else { fatalError("photo not found") }
        cell.photoImageView.kf.setImage(with: photo.photoImageUrl)

        return cell
    }
}

extension SearchPhotoViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.count > 1 {
            viewModel.fetchSearch(search: text)
        } else {
            viewModel.fetchSearch(search: "summer")
        }

    }
}
