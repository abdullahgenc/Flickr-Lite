//
//  SearchPhotoViewModel.swift
//  flickr app
//
//  Created by Abdullah Genc on 18.10.2022.
//

import Foundation

enum SearchPhotoChanges {
    case didErrorOccurred(_ error: Error)
    case didFetchList
}

final class SearchPhotoViewModel {
    
    private var photosResponse: PhotosResponse? {
        didSet {
            self.changeHandler?(.didFetchList)
        }
    }
    
    var changeHandler: ((SearchPhotoChanges) -> Void)?
    
    var numberOfItems: Int {
        photosResponse?.photos?.photo?.count ?? .zero
    }
    
    func fetchSearch(search: String) {
        provider.request(.search(text: search)) { result in
            switch result {
            case .failure(let error):
                self.changeHandler?(.didErrorOccurred(error))
            case .success(let response):
                do {
                    let photosResponse = try JSONDecoder().decode(PhotosResponse.self, from: response.data)
                    self.photosResponse = photosResponse
                } catch {
                    self.changeHandler?(.didErrorOccurred(error))
                }
            }
        }
    }

    func photoForIndexPath(_ indexPath: IndexPath) -> Photo? {
        photosResponse?.photos?.photo?[indexPath.row]
    }
}
