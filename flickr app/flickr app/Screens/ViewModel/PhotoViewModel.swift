//
//  PhotoViewModel.swift
//  flickr app
//
//  Created by Abdullah Genc on 16.10.2022.
//

import Moya
import Foundation

enum RecentListChanges {
    case didErrorOccured(_ error: Error)
    case didFetchList
}

final class PhotoViewModel {
    
    private let provider = MoyaProvider<FlickrAPI>()
    
    private var photosResponse: PhotosResponse? {
        didSet {
            self.changeHandler?(.didFetchList)
        }
    }
    
    var changeHandler: ((RecentListChanges) -> Void)?
    
    var numberOfRows: Int {
        photosResponse?.photos?.photo?.count ?? .zero
    }
    
    func fetchRecentList() {
        provider.request(.getRecent) { result in
            switch result {
            case .failure(let error):
                self.changeHandler?(.didErrorOccured(error))
            case .success(let response):
                do {
                    let photosResponse = try JSONDecoder().decode(PhotosResponse.self, from: response.data)
                    self.photosResponse = photosResponse
                } catch {
                    self.changeHandler?(.didErrorOccured(error))
                }
            }
        }
    }
    
    func fetchSearch(search: String) {
        provider.request(.search(text: search)) { result in
            switch result {
            case .failure(let error):
                self.changeHandler?(.didErrorOccured(error))
            case .success(let response):
                do {
                    let photosResponse = try JSONDecoder().decode(PhotosResponse.self, from: response.data)
                    self.photosResponse = photosResponse
                } catch {
                    self.changeHandler?(.didErrorOccured(error))
                }
            }
        }
    }

    func photoForIndexPath(_ indexPath: IndexPath) -> Photo? {
        photosResponse?.photos?.photo?[indexPath.row]
    }
}
