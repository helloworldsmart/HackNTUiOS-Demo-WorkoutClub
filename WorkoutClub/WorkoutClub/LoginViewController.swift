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
    
    var gradientLayer: CAGradientLayer!
    var colorSets = [[CGColor]]()
    var currentColorSet: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createColorSets()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.handleTapGesture(gestureRecognizer:)))
        
        self.view.addGestureRecognizer(tapGestureRecognizer)
        

    }

    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated)
        
        //TODO :- GradientLayer會蓋住原本物件
        createGradientLayer()
        
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
    
    //MARK:- gradientLayer
    func createGradientLayer() {
        
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        //gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
        gradientLayer.colors = colorSets[currentColorSet]
        
        self.view.layer.addSublayer(gradientLayer)
    }
    
    func createColorSets() {
        colorSets.append([UIColor.red.cgColor, UIColor.yellow.cgColor])
        colorSets.append([UIColor.green.cgColor, UIColor.magenta.cgColor])
        colorSets.append([UIColor.gray.cgColor, UIColor.lightGray.cgColor])
        
        currentColorSet = 0
    }
    
    func handleTapGesture(gestureRecognizer: UITapGestureRecognizer) {
        if currentColorSet < colorSets.count - 1 {
            currentColorSet! += 1
        } else {
            currentColorSet = 0
        }
        
        let colorChangeAnimation = CABasicAnimation(keyPath: "colors")
        colorChangeAnimation.duration = 2.0
        colorChangeAnimation.toValue = colorSets[currentColorSet]
        colorChangeAnimation.fillMode = kCAFillModeForwards
        colorChangeAnimation.isRemovedOnCompletion = false
        gradientLayer.add(colorChangeAnimation, forKey: "colorChange")
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
