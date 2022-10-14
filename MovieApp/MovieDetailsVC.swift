//
//  MovieDetailsVC.swift
//  MovieApp
//
//  Created by jawed on 14/10/2022.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON


class MovieDetailsVC: UIViewController {
    
    @IBOutlet weak var titreMovie: UILabel!
    @IBOutlet weak var imageMovie: UIImageView!
    
    @IBOutlet weak var languageOriginal: UILabel!
    @IBOutlet weak var releasedDate: UILabel!
    @IBOutlet weak var ratingMovie: UILabel!
    @IBOutlet weak var descriptionMovie: UITextView!
        
    @IBOutlet weak var genreMovie: UILabel!
    
    var favorite = false
    
    var movie = MovieModel(poster_path: "", adult: false, id: "", original_title: "", original_language: "", title: "", backdrop_path: "", popularity: "", overview: "", release_date: "", vote_count: "", video: "", vote_average: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titreMovie.text = movie.title
        ratingMovie.text = "\(movie.vote_average) (\(movie.vote_count))"
        releasedDate.text = movie.release_date
        languageOriginal.text = movie.original_language
        descriptionMovie.text = movie.overview
        if(movie.poster_path  == "" || movie.poster_path == "-1"){
            
        } else{
            imageMovie.kf.setImage(with: URL(string: "\(PICTURE_BASE_URL)\(movie.poster_path)"))
        }
        
        getDetails()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
    }
}

extension MovieDetailsVC {
    @objc func getDetails(){
        
        let parametres = [ "api_key": "c9856d0cb57c3f14bf75bdc6c063b8f3"] as [String : Any]
        Alamofire.request("\(GET_DETAILS_MOVIES_URL)/\(movie.id)", method: .get, parameters: parametres, encoding: URLEncoding(), headers: HEADERS).validate().responseJSON { (response) in
            
            if response.result.error != nil {
                print(response)
                let errorData = JSON(arrayLiteral: response.result.value ?? "")
                print(errorData)
                
            } else {

                let data = JSON(arrayLiteral: response.result.value ?? "")
                
                self.genreMovie.text = data[0]["genres"][0]["name"].stringValue
        
                
            }
            
        }
    }
    
    
}

