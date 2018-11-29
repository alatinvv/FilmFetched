//
//  Movie.swift
//  MovieTest
//
//  Created by Tinh Vu on 11/29/18.
//  Copyright © 2018 Tinh Vu. All rights reserved.
//

import Foundation
import ObjectMapper

class Movie: NSObject, Mappable, NSCoding {
    var id: Int = 0
    var title: String?
    var overview: String?
    var releaseDate: String?
    var posterPath: String?

    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        overview <- map["overview"]
        releaseDate <- map["release_date"]
        posterPath <- map["poster_path"]
    }

    required init?(map: Map) {

    }

    init(id: Int, title: String?, overview: String?, releaseDate: String?, posterPath: String?) {
        self.id = id
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.posterPath = posterPath
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(overview, forKey: "overview")
        aCoder.encode(releaseDate, forKey: "releaseDate")
        aCoder.encode(posterPath, forKey: "posterPath")
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "id")
        let title = aDecoder.decodeObject(forKey: "title") as? String
        let overview = aDecoder.decodeObject(forKey: "overview") as? String
        let releaseDate = aDecoder.decodeObject(forKey: "releaseDate") as? String
        let posterPath = aDecoder.decodeObject(forKey: "posterPath") as? String
        self.init(id: id, title: title, overview: overview, releaseDate: releaseDate, posterPath: posterPath)
    }
}

class MovieDetail: Movie {
    var backdropPath: String?
    var tagline: String?
    var genres: [SubValue]?
    var runtime: Int = 0
    var productCompanies: [SubValue]?
    var languages: [SubValue]?
    var revenue: Int64 = 0
    var budget: Int64 = 0

    override func mapping(map: Map) {
        super.mapping(map: map)
        backdropPath <- map["backdrop_path"]
        tagline <- map["tagline"]
        genres <- map["genres"]
        runtime <- map["runtime"]
        productCompanies <- map["production_companies"]
        languages <- map["spoken_languages"]
        revenue <- map["revenue"]
        budget <- map["budget"]
    }

    init(id: Int,
         title: String?,
         overview: String?,
         releaseDate: String?,
         posterPath: String?,
         backdropPath: String?,
         tagline: String?,
         genres: [SubValue]?,
         runtime: Int,
         productCompanies: [SubValue]?,
         languages: [SubValue]?,
         revenue: Int64,
         budget: Int64) {
        self.backdropPath = backdropPath
        self.tagline = tagline
        self.genres = genres
        self.runtime = runtime
        self.productCompanies = productCompanies
        self.languages = languages
        self.revenue = revenue
        self.budget = budget
        super.init(id: id, title: title, overview: overview, releaseDate: releaseDate, posterPath: posterPath)
    }

    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(backdropPath, forKey: "backdropPath")
        aCoder.encode(tagline, forKey: "tagline")
        aCoder.encode(genres, forKey: "genres")
        aCoder.encode(runtime, forKey: "runtime")
        aCoder.encode(productCompanies, forKey: "productCompanies")
        aCoder.encode(languages, forKey: "languages")
        aCoder.encode(revenue, forKey: "revenue")
        aCoder.encode(budget, forKey: "budget")
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "id")
        let title = aDecoder.decodeObject(forKey: "title") as? String
        let overview = aDecoder.decodeObject(forKey: "overview") as? String
        let releaseDate = aDecoder.decodeObject(forKey: "releaseDate") as? String
        let posterPath = aDecoder.decodeObject(forKey: "posterPath") as? String
        let backdropPath = aDecoder.decodeObject(forKey: "backdropPath") as? String
        let tagline = aDecoder.decodeObject(forKey: "tagline") as? String
        let runtime = aDecoder.decodeInteger(forKey: "runtime")
        let revenue = aDecoder.decodeInt64(forKey: "revenue")
        let budget = aDecoder.decodeInt64(forKey: "budget")
        let genres = aDecoder.decodeObject(forKey: "genres") as? [SubValue]
        let productCompanies = aDecoder.decodeObject(forKey: "productCompanies") as? [SubValue]
        let languages = aDecoder.decodeObject(forKey: "languages") as? [SubValue]
        self.init(id: id, title: title, overview: overview, releaseDate: releaseDate, posterPath: posterPath, backdropPath: backdropPath, tagline: tagline, genres: genres, runtime: runtime, productCompanies: productCompanies, languages: languages, revenue: revenue, budget: budget)
    }

    required init?(map: Map) {
        super.init(map: map)
    }

    static func stub() -> MovieDetail {
        return MovieDetail(id: 0, title: "No Name", overview: "No Overview", releaseDate: "No Release Date", posterPath: nil, backdropPath: nil, tagline: "No Tag", genres: nil, runtime: 0, productCompanies: nil, languages: nil, revenue: 0, budget: 0)
    }
}

class SubValue: NSObject, Mappable, NSCoding {
    var id: Int = 0
    var name: String?

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }

    required init?(map: Map) {

    }

    init(id: Int, name: String?) {
        self.id = id
        self.name = name
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "id")
        let name = aDecoder.decodeObject(forKey: "name") as? String
        self.init(id: id, name: name)
    }
}

