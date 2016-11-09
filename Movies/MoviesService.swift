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
    
    
    func loadData(completionHandler: ((_ errorType:LoadDataError?) -> Void)?) {
        
        //weakify self to avoid retain cycles.
        Alamofire.request(url).responseJSON {[weak self]
            response in
            guard let this = self else {return}
            
            
            //converting the response result into the Movie Response Object
            guard let moviesData = Mapper<MoviesResponse>().map(JSON: response.result.value as! [String : Any]) else {
                completionHandler?(LoadDataError.serverError(message: this.defaultErrorMessage))
               return
            }
        
            //persisting loginData
            do {
                try this.realm.write {
                    //cleaning the cache data to avoid inconsistency between stored data locally and on server
                    this.realm.delete(this.realm.objects(User.self))
                    this.realm.delete(this.realm.objects(Movie.self))
                    this.realm.delete(this.realm.objects(Rating.self))
                    
                    //adding the new Data
                    this.realm.add(moviesData.users, update: true)
                    this.realm.add(moviesData.movies, update: true)
                    this.realm.add(moviesData.ratings, update: true)
                    
                }
            }catch {
                completionHandler?(LoadDataError.serverError(message: this.defaultPersistenceErrorMessage))
                return
            }
            
            completionHandler?(nil)
            debugPrint(response)
        }
    }
    
}
