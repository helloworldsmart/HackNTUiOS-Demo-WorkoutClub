//
//  CustomView.swift
//  WorkoutClub
//
//  Created by mac on 2016/12/21.
//  Copyright © 2016年 hackntuios.minithon.teama. All rights reserved.
//

import UIKit

class CustomView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        layer.cornerRadius = 4.0
        //layer.backgroundColor = UIColor.black.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 0.5
        layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        
    }

}
