//
//  MoviesTableViewCell.swift
//  Movies
//
//  Created by Victor Tavares on 11/10/16.
//  Copyright © 2016 Victor. All rights reserved.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {

    @IBOutlet weak var movieNameLabel: UILabel!

    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var movieOverallLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
