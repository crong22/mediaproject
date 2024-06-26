//
//  MovieAPI.swift
//  mediaproject
//
//  Created by 여누 on 6/26/24.
//

import Foundation
import Alamofire

class MovieAPI {
    
    static let shared = MovieAPI()
    private init() {}
    
    typealias  movieHandler = ([movie]?, String?) -> Void
    
    func callRequest(api : MoiveRequest ,completionHandler : @escaping movieHandler) {
        AF.request(api.endpoint, method: api.method, encoding: URLEncoding(destination: .queryString) ,headers: api.header).responseDecodable(of: Movie.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value.results, nil)
            case .failure(let error):
                print(error)
                }
            }
    }
    
    
}
