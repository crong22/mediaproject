//
//  MovieRequest.swift
//  mediaproject
//
//  Created by 여누 on 6/26/24.
//

import UIKit
import Alamofire

enum MoiveRequest {
    case callRequestMovie(id :Int)
    case callRequestTV(id :Int)
    case callRequest(id :Int)
    case callRequestDetailMovie(id :Int)
    case callRequestMain
    
    var baseURL : String {
        return "https://api.themoviedb.org/3/movie/"
    }
    
    var twoURL : String {
        return "https://api.themoviedb.org/3/trending/movie/day"
    }

    var endpoint : URL {
        switch self {
        case .callRequestMain:
            return URL(string: twoURL)!
        case .callRequestMovie(let id):
            return URL(string: baseURL + "\(id)/similar")!
        case .callRequestTV(let id):
            return URL(string: baseURL + "\(id)/recommendations")!
        case .callRequest(let id):
            return URL(string: baseURL + "\(id)/images")!
        case .callRequestDetailMovie(let id):
            return URL(string: baseURL + "\(id)")!
        }
    }
    
    var header : HTTPHeaders {
        return ["Authorization" : APIKey.tmdbToken]
    }
    
    var method : HTTPMethod {
        return .get
    }
    
}
