//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Victor Tavares on 11/10/16.
//  Copyright © 2016 Victor. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    
    //Header variables
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var movieOverallLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentMovie: Movie!
    
    let cellIdentifier = "ratingCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillHeader()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        
        tableView.reloadData()
        
    }
    
    
    func fillHeader() {
        
        movieNameLabel.text = currentMovie.title
        
        if let ratingList  = currentMovie.ratingList, !ratingList.isEmpty {
            reviewsCountLabel.text = "\(ratingList.count) ratings"
        } else {
            reviewsCountLabel.text = "No Ratings"
        }
        
        if let rating = currentMovie.overallRating {
            let ratingString = String(format: "%.1f", rating)
            movieOverallLabel.text = "\(ratingString)/5"
            starImageView.isHidden = false
        } else {
            movieOverallLabel.text = ""
            starImageView.isHidden = true
        }

        
    }


}


extension MovieDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let ratings = currentMovie.ratingList {
            return ratings.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RatingTableViewCell
        
        let rating = currentMovie.ratingList![indexPath.row]
        
        cell.usernameLabel.text = rating.user.name
        
        var subtitle = ""
        
        if let email = rating.user.email {
            subtitle += email
        }
        
        if let ip = rating.ip {
            if !subtitle.isEmpty {
                subtitle += " (\( ip))"
            } else {
               subtitle += " \(ip)"
            }
        }
        
        cell.subtitleLabel.text = subtitle
        
        
        cell.ratingLabel.text = "\(rating.score)/5"
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        cell.dateLabel.text = formatter.string(from: rating.date)
        return cell
    }
    
}
