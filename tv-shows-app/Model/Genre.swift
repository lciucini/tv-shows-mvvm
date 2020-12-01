//
//  Genre.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 22/11/2020.
//

import Foundation

struct Genre: Codable {
    let id: Int
    let name: String
}

struct GenreList: Codable {
    let genres: [Genre]
}
