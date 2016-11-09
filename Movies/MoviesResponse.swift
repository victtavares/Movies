//
//  MoviesResponse.swift
//  Movies
//
//  Created by Gisminer 001 on 09/11/16.
//  Copyright © 2016 Victor. All rights reserved.
//

import Foundation
import ObjectMapper

//Response object from the movie dataset network call
class MoviesResponse: Mappable {
    
    var movies = [Movie]()
    var ratings = [Rating]()
    var users = [User]()
    
    
    //Mappable init protocol
    required init?(map: Map) {}
    
    //Mapping the JSON fields with the ones from this object.
    func mapping(map: Map) {
        movies <- map["movies"]
        ratings <- map["ratings"]
        users <- map["users"]
    }
    

}
