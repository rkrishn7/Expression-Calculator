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
    //Override supported interface orientation for this view controller
    //No need for landscape view, as it does not provide added functionality
    //Doesn't work
    /*
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation
    {
        return .portrait
    }
    
    override var shouldAutorotate: Bool
    {
        return false
    }
    */
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var expView: ExpressionView!
    
    @IBOutlet weak var binaryExpView: ExpressionView!
    @IBOutlet weak var hexExpView: ExpressionView!
    @IBOutlet weak var decimalExpView: ExpressionView!
    
    var mainView: ExpressionView!
    
    //HEX Buttons
    @IBOutlet weak var hexABtn: UIButton!
    @IBOutlet weak var hexBBtn: UIButton!
    @IBOutlet weak var hexCBtn: UIButton!
    @IBOutlet weak var hexDBtn: UIButton!
    @IBOutlet weak var hexEBtn: UIButton!
    @IBOutlet weak var hexFBtn: UIButton!
    
    //Decimal Buttons
    @IBOutlet weak var dec0Btn: UIButton!
    @IBOutlet weak var dec1Btn: UIButton!
    @IBOutlet weak var dec2Btn: UIButton!
    @IBOutlet weak var dec3Btn: UIButton!
    @IBOutlet weak var dec4Btn: UIButton!
    @IBOutlet weak var dec5Btn: UIButton!
    @IBOutlet weak var dec6Btn: UIButton!
    @IBOutlet weak var dec7Btn: UIButton!
    @IBOutlet weak var dec8Btn: UIButton!
    @IBOutlet weak var dec9Btn: UIButton!
    
    var hexBtns: [UIButton]!
    var binBtns: [UIButton]!
    var decBtns: [UIButton]!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        hexBtns = [hexABtn, hexBBtn, hexCBtn, hexDBtn, hexEBtn, hexFBtn]
        
        decBtns = [dec0Btn, dec1Btn, dec2Btn, dec3Btn, dec4Btn, dec5Btn, dec6Btn, dec7Btn, dec8Btn, dec9Btn]
        
        binBtns = [dec0Btn, dec1Btn]
        
        //Add tap gestures
        
        let bViewTap = UITapGestureRecognizer(target: self, action: #selector(self.binaryViewTap(sender:)))
        let hexViewTap = UITapGestureRecognizer(target: self, action: #selector(self.hexViewTap(sender:)))
        let decViewTap = UITapGestureRecognizer(target: self, action: #selector(self.decimalViewTap(sender:)))
        
        self.binaryExpView.addGestureRecognizer(bViewTap)
        self.decimalExpView.addGestureRecognizer(decViewTap)
        self.hexExpView.addGestureRecognizer(hexViewTap)
        
        enableExpressionView(view: self.decimalExpView)
    }
    
    //Override supported interface orientations
    
    @objc func binaryViewTap(sender: UITapGestureRecognizer)
    {
        enableExpressionView(view: self.binaryExpView)
    }
    
    @objc func decimalViewTap(sender: UITapGestureRecognizer)
    {
        enableExpressionView(view: self.decimalExpView)
    }
    
    @objc func hexViewTap(sender: UITapGestureRecognizer)
    {
        enableExpressionView(view: self.hexExpView)
    }
    
    func enableExpressionView(view: ExpressionView)
    {
        self.mainView = view
        view.backgroundColor = UIColor(red: 41.0 / 255.0, green: 42.0 / 255.0, blue: 48.0 / 255.0, alpha: 1.0)
        
        let defaultColor = UIColor(red: 30.0 / 255.0, green: 32.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
        
        if view == self.binaryExpView
        {
            for btn in hexBtns
            {
                btn.isEnabled = false
                btn.alpha = 0.7
            }
            
            for btn in decBtns
            {
                btn.isEnabled = false
                btn.alpha = 0.7
            }
            
            for btn in binBtns
            {
                btn.isEnabled = true
                btn.alpha = 0.899999976158142
            }
            
            self.decimalExpView.backgroundColor = defaultColor
            self.hexExpView.backgroundColor = defaultColor
        }
        else if view == self.decimalExpView
        {
            for btn in hexBtns
            {
                btn.isEnabled = false
                btn.alpha = 0.7
            }
            
            for btn in binBtns
            {
                btn.isEnabled = false
                btn.alpha = 0.7
            }
            
            for btn in decBtns
            {
                btn.isEnabled = true
                btn.alpha = 0.899999976158142
            }
            
            self.binaryExpView.backgroundColor = defaultColor
            self.hexExpView.backgroundColor = defaultColor
        }
        else if view == self.hexExpView
        {
            for btn in hexBtns
            {
                btn.isEnabled = true
                btn.alpha = 0.899999976158142
            }
            
            for btn in decBtns
            {
                btn.isEnabled = true
                btn.alpha = 0.899999976158142
            }
            
            self.binaryExpView.backgroundColor = defaultColor
            self.decimalExpView.backgroundColor = defaultColor
        }
    }

    @IBAction func clearButtonPress(_ sender: Any)
    {
        if mainView == self.hexExpView
        {
            mainView.text = "0x"
        }
        else if mainView == self.binaryExpView
        {
            mainView.text = "0b0"
        }
        else
        {
            mainView.text = "0"
        }
    }
    
    @IBAction func backspaceButtonPress(_ sender: Any)
    {
        if mainView.text.count == 3 && mainView == self.hexExpView
        {
            mainView.text = "0x0"
        }
        else if mainView.text.count == 3 && mainView == self.binaryExpView
        {
            mainView.text = "0b0"
        }
        else if mainView.text.count == 1 && mainView == self.decimalExpView
        {
            mainView.text = "0"
        }
        else
        {
            mainView.deleteBackward()
        }
        
        let baseConverter = BaseConverter()
        
        if mainView == self.decimalExpView
        {
            let hexVal = baseConverter.convertTo(base: BaseType.Hex, input: mainView.text)
            let binVal = baseConverter.convertTo(base: BaseType.Binary, input: mainView.text)
            
            self.hexExpView.text = hexVal ?? self.hexExpView.text
            self.binaryExpView.text = binVal ?? self.binaryExpView.text
            
        }
        else if mainView == self.hexExpView
        {
            let decVal = baseConverter.convertTo(base: BaseType.Decimal, input: mainView.text)
            let binVal = baseConverter.convertTo(base: BaseType.Binary, input: mainView.text)
            
            self.decimalExpView.text = decVal ?? self.decimalExpView.text
            self.binaryExpView.text = binVal ?? self.binaryExpView.text
            
        }
        else if mainView == self.binaryExpView
        {
            let decVal = baseConverter.convertTo(base: BaseType.Decimal, input: mainView.text)
            let hexVal = baseConverter.convertTo(base: BaseType.Hex, input: mainView.text)
            
            self.decimalExpView.text = decVal ?? self.decimalExpView.text
            self.hexExpView.text = hexVal ?? self.hexExpView.text
            
        }
    }
    
    @IBAction func numericButtonPress(_ sender: Any)
    {
        if mainView.text == "0" && (sender as! UIButton).titleLabel!.text! != "0"
        {
            mainView.text = (sender as! UIButton).titleLabel!.text!
        }
        else if mainView.text == "0b0" && (sender as! UIButton).titleLabel!.text! != "0"
        {
            mainView.text = "0b" + (sender as! UIButton).titleLabel!.text!
        }
        else if mainView.text == "0x0" && (sender as! UIButton).titleLabel!.text! != "0"
        {
            mainView.text = "0x" + (sender as! UIButton).titleLabel!.text!
        }
        else
        {
            mainView.insertText((sender as! UIButton).titleLabel!.text!)
        }
        
        let baseConverter = BaseConverter()
        
        if mainView == self.decimalExpView
        {
            let hexVal = baseConverter.convertTo(base: BaseType.Hex, input: mainView.text)
            let binVal = baseConverter.convertTo(base: BaseType.Binary, input: mainView.text)
            
            self.hexExpView.text = hexVal ?? self.hexExpView.text
            self.binaryExpView.text = binVal ?? self.binaryExpView.text
            
            if  hexVal == nil || binVal == nil{
                self.mainView.deleteBackward()
            }
        }
        else if mainView == self.hexExpView
        {
            let decVal = baseConverter.convertTo(base: BaseType.Decimal, input: mainView.text)
            let binVal = baseConverter.convertTo(base: BaseType.Binary, input: mainView.text)
            
            self.decimalExpView.text = decVal ?? self.decimalExpView.text
            self.binaryExpView.text = binVal ?? self.binaryExpView.text
            
            if decVal == nil || binVal == nil{
                self.mainView.deleteBackward()
            }
        }
        else if mainView == self.binaryExpView
        {
            let decVal = baseConverter.convertTo(base: BaseType.Decimal, input: mainView.text)
            let hexVal = baseConverter.convertTo(base: BaseType.Hex, input: mainView.text)
            
            self.decimalExpView.text = decVal ?? self.decimalExpView.text
            self.hexExpView.text = hexVal ?? self.hexExpView.text
            
            if decVal == nil || hexVal == nil{
                self.mainView.deleteBackward()
            }
        }
    }
}
