//
//  DRHTableViewDataModel.swift
//  WorkoutClub
//
//  Created by mac on 2016/12/20.
//  Copyright © 2016年 hackntuios.minithon.teama. All rights reserved.
//

import UIKit

protocol DRHTableViewDataModelDelegate: class {
    func didRecieveDataUpdate(data: [DRHTableViewDataModelItem])
    func didFailDataUpdateWithError(error: Error)
}


class DRHTableViewDataModel {
    
    weak var delegate: DRHTableViewDataModelDelegate?
    
    func requestData() {
        // code to request data from API or local JSON file will go here
        // this two vars were returned from wherever:
        let response: [AnyObject]? = nil
        let error: Error? = nil
        
        if let error = error {
            //handle error
            delegate?.didFailDataUpdateWithError(error: error)
        } else if let response = response {
            // parse response to [DRHTableViewDataModelItem]
            setDataWithResponse(response: response)
        }
        
    }
    
    private func setDataWithResponse(response: [AnyObject]) {
        var data = [DRHTableViewDataModelItem]()
        
        for item in response {
            // create DRHTableViewDataModelItem out of AnyObject
            if let drhTableViewDataModelItem = DRHTableViewDataModelItem(data: item as? [String : String]){
                data.append(drhTableViewDataModelItem)
            }
        }
        delegate?.didRecieveDataUpdate(data: data)
    }

}
