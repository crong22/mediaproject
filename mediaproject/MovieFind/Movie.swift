//
//  Movie.swift
//  mediaproject
//
//  Created by 여누 on 6/11/24.
//

import Foundation

struct MovieList : Decodable {
    var page : Int
    var results: [MovieResult]
    let total_pages : Int
    let total_results: Int
}

struct MovieResult : Decodable {
    let poster_path : String
    let title : String
}
