//
//  MovieCell.swift
//  MovieApp
//
//  Created by jawed on 14/10/2022.
//

import UIKit
import Kingfisher
import AVFoundation

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var titreMovie: UILabel!
    @IBOutlet weak var ratingMovie: UILabel!
    @IBOutlet weak var releaseDateMovie: UILabel!
    @IBOutlet weak var originalLanguageMovie: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundAndShadow()
        overrideDarkModeForLabels()
        
    }
    
    
    func overrideDarkModeForLabels() {
        
        titreMovie.overrideUserInterfaceStyle = .light
        ratingMovie.overrideUserInterfaceStyle = .light
        releaseDateMovie.overrideUserInterfaceStyle = .light
        originalLanguageMovie.overrideUserInterfaceStyle = .light

        
    }
    
    func roundAndShadow() {
        
        
        imageMovie.layer.cornerRadius = 10
        imageMovie.layer.cornerCurve = .continuous
        imageMovie.layer.masksToBounds = true
        
        if deviceUsedNow == .phone {
            if UIScreen.main.nativeBounds.height < 1335 {
                layer.shadowOffset = CGSize(width: 0, height: 7)
                layer.shadowRadius = 7
            }
        } else {
            
            layer.shadowRadius = 12
            
            layer.shadowOffset = CGSize(width: 0, height: 12)
        }
        
        
    }
    
    func configureCell(with movie: MovieModel){
        
        titreMovie.text = movie.title
        ratingMovie.text = "\(movie.vote_average) (\(movie.vote_count))"
        releaseDateMovie.text = movie.release_date
        originalLanguageMovie.text = movie.original_language
        
        if(movie.poster_path  == "" || movie.poster_path == "-1"){
            
        } else{
            imageMovie.kf.setImage(with: URL(string: "\(PICTURE_BASE_URL)\(movie.poster_path)"))
        }
    }
    
}

