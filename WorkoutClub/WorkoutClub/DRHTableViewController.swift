//
//  DRHTableViewController.swift
//  WorkoutClub
//
//  Created by mac on 2016/12/20.
//  Copyright © 2016年 hackntuios.minithon.teama. All rights reserved.
//

import UIKit

class DRHTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    
    private let dataSource = DRHTableViewDataModel()

    fileprivate var dataArray = [DRHTableViewDataModelItem]() {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView?.register(DRHTableViewCell.nib, forCellReuseIdentifier: DRHTableViewCell.identifier)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        dataSource.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataSource.requestData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DRHTableViewController: UITableViewDelegate {
    
}

extension DRHTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DRHTableViewCell.identifier, for: indexPath) as? DRHTableViewCell {
            
            cell.configureWithItem(item: dataArray[indexPath.item])
            return cell
        }
        return UITableViewCell()
    }
    
}

extension DRHTableViewController: DRHTableViewDataModelDelegate {
    
    func didRecieveDataUpdate(data: [DRHTableViewDataModelItem]) {
         dataArray = data
    }
    
    func didFailDataUpdateWithError(error: Error) {
       // handle error case appropriately (display alert, log an error, etc.)
    }
}
