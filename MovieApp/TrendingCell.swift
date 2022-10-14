//
//  TrendingCell.swift
//  MovieApp
//
//  Created by Jawed on 13/10/2022.
//

import UIKit
import Kingfisher
import AVFoundation

class TrendingCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var titreMovie: UILabel!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var ratingMovie: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundAndShadow()
        overrideDarkModeForLabels()
        
    }
    
    
    func overrideDarkModeForLabels() {
        
        
        
        titreMovie.overrideUserInterfaceStyle = .light
        ratingMovie.overrideUserInterfaceStyle = .light

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
        
        
        overlayView.blurView(color: .clear)
        
        
    }
    
    func configureCell(with movie: MovieModel){
        
        
        titreMovie.text = movie.title
        ratingMovie.text = "\(movie.vote_average) (\(movie.vote_count))"
        
        
        if(movie.poster_path  == "" || movie.poster_path == "-1"){
            
        } else{
            imageMovie.kf.setImage(with: URL(string: "\(PICTURE_BASE_URL)\(movie.poster_path)"))
        }
    }
    
}
