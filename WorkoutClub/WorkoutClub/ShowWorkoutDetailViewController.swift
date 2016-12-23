//
//  ShowWorkoutDetailViewController.swift
//  WorkoutClub
//
//  Created by mac on 2016/12/22.
//  Copyright © 2016年 hackntuios.minithon.teama. All rights reserved.
//

import UIKit

class ShowWorkoutDetailViewControler: UIViewController {
    
    @IBOutlet weak var workoutDetailImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var workoutDataModel:WorkoutDataModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        workoutDetailImageView.image = UIImage(named: workoutDataModel.image)
        
        // Change the color of the table view
        tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        
        // Remove the separators of the empty rows
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Change the color of the separator
        tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        
        // Set the title of the navigation bar
        title = workoutDataModel.date
        
        // Enable self sizing cells
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //TODO:- Set the rating of the restaurant
//        if workoutDataModel.rating != "" {
//            ratingButton.setImage(UIImage(named: workoutDataModel.rating), for: UIControlState())
//        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        workoutDetailImageView.layer.cornerRadius = 30
        workoutDetailImageView.layer.masksToBounds = true
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


extension ShowWorkoutDetailViewControler: UITableViewDelegate {
    
}

extension ShowWorkoutDetailViewControler: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutDetailCell", for: indexPath) as! ShowWorkoutDetailTableViewCell
        
        // Configure the cell...
        switch indexPath.row {
        case 0:
            
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = workoutDataModel.date
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = workoutDataModel.timer
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = workoutDataModel.location
        case 3:
            cell.fieldLabel.text = "Phone"
            cell.valueLabel.text = workoutDataModel.miles
        case 4:
            cell.fieldLabel.text = "Been here"
            cell.valueLabel.text = (workoutDataModel.isOutside) ? "Yes, I've been here before" : "No"
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        cell.backgroundColor = UIColor.clear
        
        return cell
        
    }

}




