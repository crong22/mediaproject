//
//  Media.swift
//  mediaproject
//
//  Created by 여누 on 6/10/24.
//

import Foundation

struct Media : Decodable {
    let page : Int
    let results : [media]
}

struct media : Decodable {
    let title : String
    let overview : String
    let poster_path : String
    let vote_average : Double
    let release_date : String
}


