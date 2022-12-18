//
//  infoViewController.swift
//  BMI Calculator
//
//  Created by Qing Liu on 10/18/22.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import UIKit

class infoViewController: UIViewController {

    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    
    
//    var bmiValue="0.0"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func heightSliderChanged(_ sender: UISlider) {
        let height=String(format: "%.0f", sender.value)
        heightLabel.text="\(height)"
    }
    @IBAction func weightSliderChanged(_ sender: UISlider) {
        let weight=String(format: "%.0f", sender.value)
        weightLabel.text="\(weight)"
    }
    @IBAction func calculatePressed(_ sender: UIButton) {
//        let height=heightSlider.value
//        let weight=weightSlider.value
//        bmiValue=String(format: "%.1f", weight/pow(height,2))
        
        
        self.performSegue(withIdentifier: "goToResult", sender: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToResult"{
//            let destinationView = segue.destination as! resultViewController
//            destinationView.bmiValue="2"
//        }
//
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
