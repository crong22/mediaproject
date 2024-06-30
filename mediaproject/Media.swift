//
//  Media.swift
//  mediaproject
//
//  Created by 여누 on 6/10/24.
//

import Foundation

struct Media : Decodable {
    let page : Int
    var results : [media]
}

struct media : Decodable {
    let title : String
    let overview : String
    let poster_path : String
    let vote_average : Double
    let release_date : String
    let id : Int
}




enum imageFontSize {
    static let mainImage = 25
}

//tv, movie
struct Movie : Decodable {
    var results : [movie]
}

struct movie : Decodable {
    let poster_path : String
    let id : Int
}

//poster
struct MoviePoster : Decodable {
    var posters : [movieposter]
}

struct movieposter : Decodable {
    let file_path : String
}

// Detail

struct DetailMovie : Decodable {
    var poster_path : String
    let original_title : String
}

struct belongs_to : Decodable {
    let poster_path : String
    let name : String
}
