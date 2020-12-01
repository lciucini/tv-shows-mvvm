//
//  PagedResults.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 22/11/2020.
//

import Foundation

struct PagedResults<T: Codable>: Codable {
    let page, totalResults, totalPages: Int
    let results: [T]
}
