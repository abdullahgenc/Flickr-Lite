//
//  FlickrAPI.swift
//  flickr app
//
//  Created by Abdullah Genc on 16.10.2022.
//

import Moya
import Foundation

enum FlickrAPI {
    case getRecent
    case search(text: String)
}

private let apiKey = "ca3c24381b5fa8ec9337f168639fe712"

extension FlickrAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://www.flickr.com/services/rest") else {
            fatalError("Base url not found.")
        }
        return url
    }
    
    var path: String {
        "/"
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .getRecent:
            let parameters: [String: Any] = ["method" : "flickr.photos.getRecent",
                                             "api_key" : apiKey,
                                             "extras" : "owner_name, icon_server",
                                             "format" : "json",
                                             "nojsoncallback" : 1]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .search(let text):
            let parameters: [String: Any] = ["method" : "flickr.photos.search",
                                             "api_key" : apiKey,
                                             "text" : text,
                                             "extras" : "owner_name, icon_server",
                                             "format" : "json",
                                             "nojsoncallback" : 1]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}
