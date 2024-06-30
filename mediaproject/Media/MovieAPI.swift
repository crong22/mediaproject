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
    
    typealias  posterHandler = ([movieposter]?, String?) -> Void
    
    func callRequestPoster(api : MoiveRequest ,completionHandler : @escaping posterHandler) {
        AF.request(api.endpoint, method: api.method, encoding: URLEncoding(destination: .queryString) ,headers: api.header).responseDecodable(of: MoviePoster.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value.posters, nil)
            case .failure(let error):
                print(error)
                }
            }
    }
    
    typealias  detailHandler = (DetailMovie?, String?) -> Void
    
    func callRequestDetail(api : MoiveRequest ,completionHandler : @escaping detailHandler) {
        AF.request(api.endpoint, method: api.method, encoding: URLEncoding(destination: .queryString) ,headers: api.header).responseDecodable(of: DetailMovie.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value, nil)
            case .failure(let error):
                print(error)
                }
            }
    }
    
    typealias  mediaHandler = ([media]?, String?) -> Void

    func callRequestmain(api : MoiveRequest, completionHandler : @escaping mediaHandler) {
        AF.request(api.twoURL).responseDecodable(of: Media.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value.results, nil)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}

