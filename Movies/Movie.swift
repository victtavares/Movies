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
    dynamic private var genresRaw: String? // list of genres separated by  "|"
    var genres: [String] {

        guard let genresList = genresRaw else {
            return [String]()
        }
        
        return genresList.components(separatedBy: "|")
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
        genresRaw <- map["genres"]
    }

    
    
}
