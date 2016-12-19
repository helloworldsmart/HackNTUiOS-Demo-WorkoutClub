//
//  LoginViewController.swift
//  WorkoutClub
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 hackntuios.minithon.teama. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var textDownConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var skipBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        textDownConstraint.constant -= view.bounds.width
        skipBtn.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseOut,
                       animations: {
                        self.textDownConstraint.constant += self.view.bounds.width
                        self.skipBtn.alpha = 1
                        self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO:- 加跳下一頁
    @IBAction func SkipOkBtn(_ sender: Any) {
        UIView.animate(withDuration: 1.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.textDownConstraint.constant -= self.view.bounds.width
            self.skipBtn.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: nil)
        
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
