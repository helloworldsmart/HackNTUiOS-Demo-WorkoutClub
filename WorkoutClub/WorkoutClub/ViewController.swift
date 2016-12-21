//
//  ViewController.swift
//  WorkoutClub
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 hackntuios.minithon.teama. All rights reserved.
//

//Tutorial area

import UIKit

class ViewController: UIViewController {
    
    private let dataModel = DataModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        dataModel.requestData { [weak self] (data:String) in
//            self?.useData(data: data)
//        }
//        
//        // 1.5
//        dataModel.onDataUpdate = { [weak self] (data:String) in
//            self?.useData(data: data)
//        }
//        dataModel.dataRequest()
        // 2.
        dataModel.delegate = self
        dataModel.requestData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func useData(data: String) {
        print(data)
    }

}

extension ViewController: DataModelDelegate {
    
    func didRecieveDataUpdata(data: String) {
        print(data)
    }
}

