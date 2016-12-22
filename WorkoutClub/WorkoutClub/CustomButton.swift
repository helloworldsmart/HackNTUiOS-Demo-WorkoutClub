//
//  CustomButton.swift
//  WorkoutClub
//
//  Created by mac on 2016/12/21.
//  Copyright © 2016年 hackntuios.minithon.teama. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor(red: 255/255, green: 128/255, blue: 0/255, alpha: 1.0).cgColor
        layer.borderWidth = 1.0
    }

}
