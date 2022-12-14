//
//  Constants.swift
//  MoviesApp
//
//  Created by Jawed on 13/10/2022.
//

import Foundation


    
    typealias CompletionHandler = (_ Success: Bool) -> ()
    
     let PICTURE_BASE_URL = "https://image.tmdb.org/t/p/w500/"
     let GET_MOVIES_URL = "https://api.themoviedb.org/3/discover/movie"
     let GET_DETAILS_MOVIES_URL = "https://api.themoviedb.org/3/movie"
    
     let HEADERS = [
        "Content-Type":"application/x-www-form-urlencoded",
    ]
    
    
