//
//  MoviesViewController.swift
//  Movies
//
//  Created by Gisminer 001 on 09/11/16.
//  Copyright © 2016 Victor. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {

    let service = MoviesService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service.loadData(completionHandler: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
}
