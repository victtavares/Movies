//
//  MoviesService.swift
//  Movies
//
//  Created by Gisminer 001 on 09/11/16.
//  Copyright © 2016 Victor. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import ObjectMapper


enum LoadDataError {
    case serverError(message: String)
    case persistenceError(message: String)
}


class MoviesService {
    
    let url = "https://cdn.cubos.io/downloads/moviesdataset.json"
    let defaultErrorMessage = "Erro de conexão!"
    let defaultPersistenceErrorMessage = "Erro ao persistir seus dados!"
    var realm: Realm
    
    
    
    init() {
        realm = try! Realm()
    }
    
    
    ///Loading the data and parsing it on a background thread
    ///Too big json to load it on main thread.
    func loadData(completionHandler: ((_ errorType:LoadDataError?) -> Void)?) {
        
        
        //weakify self to avoid retain cycles.
        Alamofire.request(url).responseJSON {[weak self]
            response in
            guard let this = self else {return}
            
            
            //dispatch it on back thread, the json response is too big to load it on the main thread.
            DispatchQueue.global(qos: .userInitiated).async {
                
                
                let backRealm = try! Realm() //background thread realm..

                guard let moviesData = Mapper<MoviesResponse>().map(JSON: response.result.value as! [String : Any]) else {
                    completionHandler?(LoadDataError.serverError(message: this.defaultErrorMessage))
                    return
                }
                
                
                backRealm.beginWrite()
                //adding the new Data
                backRealm.add(moviesData.users, update: true)
                backRealm.add(moviesData.movies, update: true)
                backRealm.add(moviesData.ratings, update: true)
                
                do {
                    try backRealm.commitWrite()
                } catch {
                    completionHandler?(LoadDataError.serverError(message: this.defaultPersistenceErrorMessage))
                }
                
                print("done here")
                completionHandler?(nil)
                
            }
            
            //converting the response result into the Movie Response Object
            
        }
        
    }

        
        func getLocalMovies() -> Results<Movie> {
            return realm.objects(Movie.self)
        }
        
    
}
