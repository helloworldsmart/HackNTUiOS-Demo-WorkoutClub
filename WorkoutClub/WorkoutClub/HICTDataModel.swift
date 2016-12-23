//
//  HICTDataModel.swift
//  WorkoutClub
//
//  Created by mac on 2016/12/23.
//  Copyright © 2016年 hackntuios.minithon.teama. All rights reserved.
//


import Foundation

class HICTDataModel {
    
    var image = ""
    var HICT = ""
    var isDone = false
    
    init(image:String, HICT:String, isDone:Bool) {
        self.image = image
        self.HICT = HICT
        self.isDone = isDone
    }
}
