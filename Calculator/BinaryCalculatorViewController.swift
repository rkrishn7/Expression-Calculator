//
//  BinaryCalculatorViewController.swift
//  Calculator
//
//  Created by User on 2/20/19.
//  Copyright © 2019 Rohan Krishnaswamy. All rights reserved.
//

import UIKit

class BinaryCalculatorViewController: UIViewController
{

    @IBOutlet weak var navBar: UINavigationItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navBar.hidesBackButton = true
    }
    
    @IBAction func unwindToCalculator(segue: UIStoryboardSegue)
    {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
