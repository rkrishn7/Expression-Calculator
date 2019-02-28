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

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var expView: ExpressionView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    func tryAppendText(textToInsert: String)
    {
        if let expText = expView.text
        {
            if expText == "0"
            {
                expView.text = textToInsert
            }
            else
            {
                if expText.hasPrefix("0b")
                {
                    if textToInsert == "0" || textToInsert == "1"
                    {
                        expView.insertText(textToInsert)
                    }
                }
                else if expText.hasPrefix("0x")
                {
                    if textToInsert != "0b" && textToInsert != "0x"
                    {
                        expView.insertText(textToInsert)
                    }
                }
                else if Character.isDigit(expText.first!)
                {
                    if Character.isDigit(textToInsert.first!) && (textToInsert != "0b" && textToInsert != "0x")
                    {
                        expView.insertText(textToInsert)
                    }
                }
            }
        }
    }
    
    
    @IBAction func clearButtonPress(_ sender: Any)
    {
        expView.text = "0"
    }
    
    @IBAction func backspaceButtonPress(_ sender: Any)
    {
        if expView.text.count == 1 || expView.text == "0b" || expView.text == "0x"
        {
            expView.text = "0"
        }
        else
        {
            expView.deleteBackward()
        }
    }
    
    @IBAction func toHexButtonPress(_ sender: Any)
    {
        let converter = BaseConverter()
        
        let output = converter.convertTo(base: BaseType.Hex, input: expView.text)
        
        if let txt = output
        {
            expView.text = txt
        }
    }
    
    @IBAction func toBinaryButtonPress(_ sender: Any)
    {
        let converter = BaseConverter()
        
        let output = converter.convertTo(base: BaseType.Binary, input: expView.text)
        
        if let txt = output
        {
            expView.text = txt
        }
    }
    
    @IBAction func toDecimalButtonPress(_ sender: Any)
    {
        let converter = BaseConverter()
        
        let output = converter.convertTo(base: BaseType.Decimal, input: expView.text)
        
        if let txt = output
        {
            expView.text = txt
        }
    }
    
    @IBAction func numericButtonPress(_ sender: Any)
    {
        tryAppendText(textToInsert: (sender as! UIButton).titleLabel!.text!)
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
