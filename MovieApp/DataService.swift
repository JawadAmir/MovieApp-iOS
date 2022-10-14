//
//  DataService.swift
//  MovieApp
//
//  Created by Jawed on 13/10/2022.
//

import UIKit
import Alamofire
import SwiftyJSON

class DataService {
    
    static let instance = DataService()

    static var trendingList: [MovieModel] = []
    
    static var moviesList: [MovieModel] = []
    
    func getMovies (completion : @escaping (_ Success: String) -> ()) {
        
        let parametres = [ "api_key": "c9856d0cb57c3f14bf75bdc6c063b8f3"] as [String : Any]
        Alamofire.request(GET_MOVIES_URL, method: .get, parameters: parametres, encoding: URLEncoding(), headers: HEADERS).validate().responseJSON { (response) in
            
            if response.result.error != nil {
                print(response)
                let errorData = JSON(arrayLiteral: response.result.value as Any)
                print(errorData)
                completion("Erreur")
                
            } else {

                let data = JSON(arrayLiteral: response.result.value as Any)
                print(data)
                
                let dataJSON = data[0]["results"].arrayValue
                
                DataService.trendingList.removeAll()
                DataService.moviesList.removeAll()
            
                var movieModel: MovieModel
                
                for movie in dataJSON {
                movieModel = MovieModel(poster_path: movie["poster_path"].stringValue, adult: movie["adult"].boolValue, id: movie["id"].stringValue, original_title: movie["original_title"].stringValue, original_language: movie["original_language"].stringValue, title: movie["title"].stringValue, backdrop_path: movie["backdrop_path"].stringValue, popularity: movie["popularity"].stringValue, overview: movie["overview"].stringValue, release_date: movie["release_date"].stringValue, vote_count: movie["vote_count"].stringValue, video: movie["video"].stringValue, vote_average: movie["vote_average"].stringValue)
                    
                    print(movieModel.popularity)
                    if(Double(movieModel.popularity) ?? 0 > 1700){
                        DataService.trendingList.append(movieModel)
                    }
                    DataService.moviesList.append(movieModel)
                }
                if DataService.moviesList.count == 0 {
                    completion("Non")
                } else {
                    completion("Oui")
                }
            }
            
        }
    }
    
}
