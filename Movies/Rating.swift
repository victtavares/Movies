//
//  Rating.swift
//  Movies
//
//  Created by Gisminer 001 on 09/11/16.
//  Copyright © 2016 Victor. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
//    - "ratings": Lista de avaliações feitas por esses usuários nesses filmes. Cada avaliação tem o id do filme "movie", o id do usuário "user", a nota 0 a 5 em "score", além de um "timestamp" e o "ip" do momento em que a avaliação foi feita.
class Rating: Object, Mappable {
    
    dynamic var id: String = ""
    dynamic var idMovie: Int = 0
    dynamic var idUser: Int = 0
    dynamic var score: Int = 0
    dynamic var timestamp: TimeInterval = 0
    dynamic var ip: String?

    //define the primary key
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    var user: User! {
        return realm!.object(ofType: User.self, forPrimaryKey: idUser)!
    }
    
    var date: Date {
        return Date(timeIntervalSince1970: timestamp)
    }
    
    required convenience init?(map: Map) {
        
        //In case the JSON doesn't have this fields, returns nil
        if map.JSON["movie"] == nil || map.JSON["user"] == nil ||  map.JSON["score"] == nil || map.JSON["timestamp"] == nil {
            return nil
        }
        
        self.init()
    }
    
    func mapping(map: Map) {
        idMovie <- map["movie"]
        idUser <- map["user"]
        score <- map["score"]
        timestamp <- map["timestamp"]
        ip <- map["ip"]
        
        id = "\(idMovie)\(idUser)"
    }

    
    
}
