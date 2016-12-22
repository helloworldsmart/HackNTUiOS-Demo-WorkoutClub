//
//  WorkoutClubTableViewCell.swift
//  WorkoutClub
//
//  Created by mac on 2016/12/22.
//  Copyright © 2016年 hackntuios.minithon.teama. All rights reserved.
//

import UIKit

class WorkoutClubTableViewCell: UITableViewCell {

    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var MilesLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
