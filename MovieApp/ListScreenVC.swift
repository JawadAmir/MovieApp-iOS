//
//  ListScreenVC.swift
//  MoviesApp
//
//  Created by Jawed on 13/10/2022.
//

import UIKit
import ViewAnimator
import LNICoverFlowLayout
import BouncyLayout

var screenSize: CGRect = UIScreen.main.bounds

var deviceUsedNow = UIDevice.current.userInterfaceIdiom

class ListScreenVC: UIViewController {

    @IBOutlet weak var moviesText: UILabel!
    @IBOutlet weak var trendingNowText: UILabel!
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var trendingLoadingContainer: UIStackView!
    @IBOutlet weak var trendingNoContentContainer: UIStackView!
    @IBOutlet weak var moviesLoadingContainer: UIStackView!
    @IBOutlet weak var moviesNoContentContainer: UIStackView!
    @IBOutlet weak var coverFlowLayout: LNICoverFlowLayout!
    
    var refreshControl:UIRefreshControl!
    
    var trendingList: [MovieModel] = []
    var moviesList: [MovieModel] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trendingCollectionView.delegate = self
        trendingCollectionView.dataSource = self
        
        trendingCollectionView.alwaysBounceVertical = true
        trendingCollectionView.bounces = true
        
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        
        moviesCollectionView.alwaysBounceVertical = true
        moviesCollectionView.bounces = true
        
        configureLayout()
        addRefresher()
        
        getMovies()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
    }
    
    func addRefresher() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(getMovies), for: .valueChanged)
        trendingCollectionView!.addSubview(refreshControl)
        moviesCollectionView!.addSubview(refreshControl)
    }


}

extension ListScreenVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == trendingCollectionView {
            
            return trendingList.count
        } else {
            
            return moviesList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == trendingCollectionView {
            
            guard let cell = trendingCollectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCell", for: indexPath) as? TrendingCell else { return UICollectionViewCell()}
            
            cell.configureCell(with: trendingList[indexPath.item])
            return cell
        } else {
            
            guard let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else { return UICollectionViewCell()}
            
            cell.configureCell(with: moviesList[indexPath.item])
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc : MovieDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsVC") as! MovieDetailsVC
                
            
        if collectionView == trendingCollectionView {
            
            vc.movie = trendingList[indexPath.item]
        } else {
            
            vc.movie = moviesList[indexPath.item]

        }
        
        self.present(vc, animated: true, completion: nil)
    }

}


extension ListScreenVC {
    @objc func getMovies(){
        
        DataService.instance.getMovies() { (success) in
            if success == "Oui" {
                self.moviesList = DataService.moviesList
                self.trendingList = DataService.trendingList
                
                self.refreshControl?.endRefreshing()
                self.trendingCollectionView.reloadData()
                self.moviesCollectionView.reloadData()
                
                if self.trendingList.count == 0 {
                    self.showNoContentTrending()
                } else {
                    self.showContentTrending()
                }
                
                self.trendingCollectionView.performBatchUpdates(nil) { (success) in
                    if success {
                        


                        self.animateTrendingCells(scrollAnimated: true, shouldHideHeader: true)
                    }
                }
                
                if self.moviesList.count == 0 {
                    self.showNoContentMovies()
                } else {
                    self.showContentMovies()
                }
                
                self.moviesCollectionView.performBatchUpdates(nil) { (success) in
                    if success {
                        


                        self.animateMoviesCells(scrollAnimated: true, shouldHideHeader: true)
                    }
                }
                
                
            } else {
                self.showNoContentMovies()
                self.showNoContentTrending()
                self.cleanCollection()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    func cleanCollection() {
        trendingList.removeAll()
        moviesList.removeAll()
        trendingCollectionView.reloadData()
        moviesCollectionView.reloadData()
    }
    
}

extension ListScreenVC {
    func animateTrendingCells(scrollAnimated : Bool, shouldHideHeader: Bool) {
        let fromAnimationColl = AnimationType.from(direction: .bottom, offset: 0)
        
        UIView.animate(views: trendingCollectionView.visibleCells, animations: [fromAnimationColl], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, animationInterval: 0, duration: 1, options: []) {
            if (!self.trendingList.isEmpty){
                self.trendingCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .top, animated: true)
            }
        }
        
    }
    
    func animateMoviesCells(scrollAnimated : Bool, shouldHideHeader: Bool) {
        let fromAnimationColl = AnimationType.from(direction: .bottom, offset: 0)
        
        UIView.animate(views: moviesCollectionView.visibleCells, animations: [fromAnimationColl], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.0, animationInterval: 0, duration: 1, options: []) {
            if (!self.moviesList.isEmpty){
                self.moviesCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
        }
        
    }
    
    func configureLayout () {
        
        
        switch deviceUsedNow {
        case .phone:
            
           let width = screenSize.width - 56
            let height = screenSize.height
            
            coverFlowLayout.minimumInteritemSpacing = 0
            coverFlowLayout.minimumLineSpacing = 0
            
            coverFlowLayout.itemSize = CGSize(width: width , height: height/3 )
            coverFlowLayout.scrollDirection = .horizontal
            //            collectionViewProduit.isPagingEnabled = true
            
            coverFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            coverFlowLayout.coverDensity = 0.065
            coverFlowLayout.maxCoverDegree = 35
            coverFlowLayout.minCoverScale = 0.72
            coverFlowLayout.minCoverOpacity = 1
            trendingCollectionView.reloadData()
            
            
        case .pad:
            let layout = BouncyLayout()
            
            layout.minimumLineSpacing = 40
            layout.minimumInteritemSpacing = 0
            
            layout.scrollDirection = .horizontal
            
            
            layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 32, right: 24)
            trendingCollectionView.setCollectionViewLayout(layout , animated: true)
        default:
            return
        }
        
        let layoutt = UICollectionViewFlowLayout()
        let widthh = screenSize.width
        let heightt : CGFloat = 180
        switch deviceUsedNow {
        case .phone:
            layoutt.minimumInteritemSpacing = 10
            layoutt.minimumLineSpacing = 0
        case .pad:
            
            
            //            if UIDevice.current.orientation.isLandscape {
            //                widthh = screenSizee.height
            //            }
            layoutt.minimumInteritemSpacing = 20
            layoutt.minimumLineSpacing = 20
            
        default:
            return
        }
        
        layoutt.itemSize = CGSize(width: widthh , height: heightt)
        layoutt.scrollDirection = .vertical
        
        layoutt.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        moviesCollectionView.setCollectionViewLayout(layoutt , animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 380, height: 250)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // centrer collectionViewcell
        if deviceUsedNow == .phone{
            
            let layout = trendingCollectionView.collectionViewLayout as! LNICoverFlowLayout
            let cellCidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing + 28
            
            var offset = targetContentOffset.pointee
            let index = (offset.x + scrollView.contentInset.left) / cellCidthIncludingSpacing
            
            let roundIndex = round(index)
            
            offset = CGPoint(x: roundIndex * cellCidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
            
            targetContentOffset.pointee = offset
            
        }
    }
}

extension ListScreenVC {
    func showContentTrending(){
        trendingCollectionView.isHidden = false
        trendingLoadingContainer.isHidden = true
        trendingNoContentContainer.isHidden = true
    }
    
    func showLoadingTrending(){
        
        trendingCollectionView.isHidden = false
        trendingLoadingContainer.isHidden = false
        trendingNoContentContainer.isHidden = true
    }
    
    func showNoContentTrending(){
        trendingCollectionView.isHidden = false
        trendingLoadingContainer.isHidden = true
        trendingNoContentContainer.isHidden = false
    }
    
    func showContentMovies(){
        moviesCollectionView.isHidden = false
        moviesLoadingContainer.isHidden = true
        moviesNoContentContainer.isHidden = true
    }
    
    func showLoadingMovies(){
        
        moviesCollectionView.isHidden = false
        moviesLoadingContainer.isHidden = false
        moviesNoContentContainer.isHidden = true
    }
    
    func showNoContentMovies(){
        moviesCollectionView.isHidden = false
        moviesLoadingContainer.isHidden = true
        moviesNoContentContainer.isHidden = false
    }
}

