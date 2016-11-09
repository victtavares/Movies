//
//  User.swift
//  Movies
//
//  Created by Gisminer 001 on 09/11/16.
//  Copyright © 2016 Victor. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class User:Object, Mappable {
    
    dynamic var id: Int = 0
    dynamic var name: String?
    dynamic var email: String?
    
//    "id", "name" e "email"

//    - "ratings": Lista de avaliações feitas por esses usuários nesses filmes. Cada avaliação tem o id do filme "movie", o id do usuário "user", a nota 0 a 5 em "score", além de um "timestamp" e o "ip" do momento em que a avaliação foi feita.
//    
    
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
        name <- map["name"]
        email <- map["email"]
    }
}
