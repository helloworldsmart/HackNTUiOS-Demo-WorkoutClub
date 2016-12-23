//
//  HICTTableViewCell.swift
//  WorkoutClub
//
//  Created by mac on 2016/12/23.
//  Copyright © 2016年 hackntuios.minithon.teama. All rights reserved.
//

import UIKit

class HICTTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
