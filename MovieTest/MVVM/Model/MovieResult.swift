//
//  MovieResult.swift
//  MovieTest
//
//  Created by Tinh Vu on 11/29/18.
//  Copyright © 2018 Tinh Vu. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieResult: Mappable {

    var page: Int = 1
    var totalPages: Int = 0
    var totalResults: Int = 0
    var results: [Movie]?

    func mapping(map: Map) {
        page <- map["page"]
        totalPages <- map["total_pages"]
        totalResults <- map["total_results"]
        results <- map["results"]
    }

    required init?(map: Map) {
        
    }
}
