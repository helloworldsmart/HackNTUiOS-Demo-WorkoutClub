//
//  WorkoutDataModel.swift
//  WorkoutClub
//
//  Created by mac on 2016/12/22.
//  Copyright © 2016年 hackntuios.minithon.teama. All rights reserved.
//

import Foundation

class WorkoutDataModel {
    var date = ""
    var timer = ""
    var location = ""
    var miles = ""
    var image = ""
    var isOutside = false
    var rating = ""
    
    var achievement = ""
    var pounds = ""
    var numberOfGroups = ""
    
    init(date:String, timer:String, location:String, miles:String, image:String, isOutside:Bool) {
        self.date = date
        self.timer = timer
        self.location = location
        self.miles = miles
        self.image = image
        self.isOutside = isOutside
    }
}




