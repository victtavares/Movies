//
//  MoviesViewController.swift
//  Movies
//
//  Created by Gisminer 001 on 09/11/16.
//  Copyright © 2016 Victor. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class MoviesViewController: UIViewController {

    var service: MoviesService!
    
    let segueIdentifier = "goDetailMovie"
    let cellIdentifier = "movieCell"
    let cellHeight: CGFloat = 59
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var moviesList: Results<Movie>!
    var filteredMovieList = [Movie]()
    
    var token: NotificationToken? //must retain it
    var selectedMovie: Movie?
    
    
    var searchController: UISearchController!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //init service
        service = MoviesService()
        
        moviesList = service.getLocalMovies()
        
        //search controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies by Name"
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        //loading data from service
        loadMovies()
        
        //configure tableview dynamic height
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = cellHeight
        
        //adding observer on movies list, must retain the token in order to receive notifications
        token = moviesList.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            self?.tableView.reloadData()
        }
    }
    
    

    func loadMovies() {
    
        activityIndicator.startAnimating()
        
        service.loadData { [weak self]
            error in
            guard let this = self else {return}
            
            DispatchQueue.main.async {
               this.activityIndicator.stopAnimating()
                if let currentError = error {
                    let errorMessage: String
                    switch currentError {
                    case .persistenceError(let message):
                        errorMessage = message
                    case .serverError(let message):
                        errorMessage = message
                    }
                    this.displayAlertMessage(message: errorMessage)
                    return
                }
            }
            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segueIdentifier {
            let dest = segue.destination as! MovieDetailViewController
            dest.currentMovie = selectedMovie!
        }
    }
    
    
    func filterContentForSearchText(searchText: String) {
        filteredMovieList = moviesList.filter { movie in
            
            guard let title = movie.title else {return false}
            return title.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
}


extension MoviesViewController: UISearchResultsUpdating {
    
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
}

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredMovieList.count
        }
        return moviesList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MoviesTableViewCell
        
        let movie: Movie
        
        if searchController.isActive && searchController.searchBar.text != "" {
            movie = filteredMovieList[indexPath.row]
        } else {
            movie = moviesList[indexPath.row]
        }
        
        
        cell.movieNameLabel.text = movie.title
        
        if let ratingList  = movie.ratingList, !ratingList.isEmpty {
            cell.reviewsCountLabel.text = "\(ratingList.count) ratings"
        } else {
            cell.reviewsCountLabel.text = "No Ratings"
        }
        
        if let rating = movie.overallRating {
            let ratingString = String(format: "%.1f", rating)
            cell.movieOverallLabel.text = "\(ratingString)/5"
            cell.starImageView.isHidden = false
        } else {
            cell.movieOverallLabel.text = ""
             cell.starImageView.isHidden = true
        }
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = moviesList[indexPath.row]
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    
}
