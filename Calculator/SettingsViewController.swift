//
//  SettingsViewController.swift
//  Calculator
//
//  Created by User on 2/20/19.
//  Copyright © 2019 Rohan Krishnaswamy. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
{
    
    @IBOutlet weak var viewPicker: UIPickerView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.viewPicker.delegate   = self
        self.viewPicker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return CalculatorViews.allViews.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?
    {
        let s = CalculatorViews.allViews[row].rawValue
        
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25.0, weight: UIFont.Weight.ultraLight) ]
        
        return NSAttributedString(string: s, attributes: attributes)
    }

    @IBAction func backButtonPressed(_ sender: Any)
    {
        let selectedRow = viewPicker.selectedRow(inComponent: 0)
        
        let decimalCalculatorView = self.storyboard?.instantiateViewController(withIdentifier: "decimalCalcNavControl")
        let binaryCalculatorView = self.storyboard?.instantiateViewController(withIdentifier: "binaryCalcNavControl")
        
        if selectedRow == 1
        {
            UIApplication.shared.keyWindow?.rootViewController = binaryCalculatorView!
        }
        else
        {
            UIApplication.shared.keyWindow?.rootViewController = decimalCalculatorView!
        }
    }
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let selectedRow = viewPicker.selectedRow(inComponent: 0)
        
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "decimalCalculator")
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "settings")
        let vc3 = self.storyboard?.instantiateViewController(withIdentifier: "binaryCalculator")
        
        if selectedRow == 1
        {
            self.navigationController?.setViewControllers([vc3!, vc2!, vc1!], animated: true)
        }
    }
    */
}
