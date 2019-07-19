//
//  PodcastTableViewCell.swift
//  iTunes Podcasts
//
//  Created by Eric Dolecki on 7/19/19.
//  Copyright © 2019 Eric Dolecki. All rights reserved.
//

import UIKit

class PodcastTableViewCell: UITableViewCell {

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
