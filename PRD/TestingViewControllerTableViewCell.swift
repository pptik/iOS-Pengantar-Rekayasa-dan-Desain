//
//  TestingViewControllerTableViewCell.swift
//  PRD
//
//  Created by Ilham on 3/4/17.
//  Copyright © 2017 Ilham. All rights reserved.
//

import UIKit

class TestingViewControllerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
