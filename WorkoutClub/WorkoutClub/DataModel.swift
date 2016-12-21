//
//  DataModel.swift
//  WorkoutClub
//
//  Created by mac on 2016/12/20.
//  Copyright © 2016年 hackntuios.minithon.teama. All rights reserved.
//

import UIKit

protocol DataModelDelegate: class {
    func didRecieveDataUpdata(data:String)
}

class DataModel {

    weak var delegate: DataModelDelegate?
    
    var onDataUpdate: ((_ data: String) -> Void)?
    
    // 1. Closure func
//    func requestData(completion: ((_ data: String) -> Void)) {
//        
//        let data = "Data from where"
//        
//        completion(data)
//    }
//    
//    //1.5
//    func dataRequest() {
//        let data = "Data from where"
//        
//        onDataUpdate?(data)
//    }

    func requestData() {
        
        let data = "Data from where"
        delegate?.didRecieveDataUpdata(data: data)
    }

}
