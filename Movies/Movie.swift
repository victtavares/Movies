//
//  Movie.swift
//  Movies
//
//  Created by Gisminer 001 on 09/11/16.
//  Copyright © 2016 Victor. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Movie: Object, Mappable {

    dynamic var id: Int = 0
    dynamic var title: String?
    dynamic var genresString: String? // list of genres separated by  "|"
    
    
    var genres: [String] {

        guard let genresList = genresString else {
            return [String]()
        }
        
        return genresList.components(separatedBy: "|")
    }
    
    
    var ratingList: Results<Rating>? {
        return realm?.objects(Rating.self).filter("idMovie == \(id)")
    }
    
    
    var overallRating: Double? {
        guard  let list = realm?.objects(Rating.self).filter("idMovie == \(id)"), !list.isEmpty else {
            return nil
        }
        
        var counter:Double = 0
        for element in list {
            counter += Double(element.score)
        }
        
        return counter/Double(list.count)
        
        
    }
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        
        //In case the JSON doesn't have this fields, returns nil
        if map.JSON["id"] == nil {
            return nil
        }
        
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        genresString <- map["genres"]
    }

    
    
}
