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
    
    
    var baseURL : String {
        return "https://api.themoviedb.org/3/movie/"
    }
    
    var endpoint : URL {
        switch self {
        case .callRequestMovie(let id):
            return URL(string: baseURL + "\(id)/similar")!
        case .callRequestTV(let id):
            return URL(string: baseURL + "\(id)/recommendations")!
        case .callRequest(let id):
            return URL(string: baseURL + "\(id)/images")!
        }
    }
    
    var header : HTTPHeaders {
        return ["Authorization" : APIKey.tmdbToken]
    }
    
    var method : HTTPMethod {
        return .get
    }
    
}
