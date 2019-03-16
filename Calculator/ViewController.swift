//
//  ViewController.swift
//  Calculator
//
//  Created by User on 2/11/19.
//  Copyright © 2019 Rohan Krishnaswamy. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var displayText: ExpressionView!
    
    @IBOutlet weak var equalsButton: UIButton!
    
    private var savedAnswer: String?
    
    //SCIENTIFIC BUTTONS
    @IBOutlet weak var cosBtn: UIButton!
    @IBOutlet weak var sinBtn: UIButton!
    @IBOutlet weak var tanBtn: UIButton!
    @IBOutlet weak var coshBtn: UIButton!
    @IBOutlet weak var sinhBtn: UIButton!
    @IBOutlet weak var tanhBtn: UIButton!
    @IBOutlet weak var logBtn: UIButton!
    @IBOutlet weak var lnBtn: UIButton!
    @IBOutlet weak var sqrtBtn: UIButton!
    @IBOutlet weak var cubertBtn: UIButton!
    @IBOutlet weak var factorialBtn: UIButton!
    @IBOutlet weak var eConstBtn: UIButton!
    @IBOutlet weak var pow2Btn: UIButton!
    @IBOutlet weak var pow3Btn: UIButton!
    @IBOutlet weak var piConstBtn: UIButton!
    
    //Array for buttons hidden on startup
    var hiddenButtons: [UIButton]!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.displayText.delegate = self.displayText
        
        hiddenButtons = [cosBtn, sinBtn, tanBtn, coshBtn, sinhBtn, tanhBtn, logBtn, lnBtn, sqrtBtn, cubertBtn, factorialBtn, eConstBtn, pow2Btn, pow3Btn, piConstBtn]
        
        //Hide scientific buttons on startup (if orientation is portrait)
        if UIDevice.current.orientation.isPortrait
        {
            for btn in hiddenButtons
            {
                btn.isHidden = true
            }
        }
    }
    
    private func backspace()
    {
        if let expression = displayText.text
        {
            let last = String(expression.last!)
            
            if expression.count == 1
            {
                displayText.text = "0"
            }
            else if last.isNumber() || last == "." || last == "(" || last == ")"
            {
                displayText.deleteBackward()
            }
            else
            {
                let tokens = Expression.convertToInfixArray(infixExpression: expression)
                
                var newText = ""
                
                for i in 0..<(tokens!.count - 1)
                {
                    newText += tokens![i]
                }
                
                if newText.isEmpty
                {
                    displayText.text = "0"
                }
                else
                {
                    displayText.text = newText
                }
            }
            
            self.equalsButton.isSelected = false
        }
    }
    
    //Tries to append char to the display
    private func tryAppendText(_ textToAppend: String)
    {
        if let expression = displayText.text
        {
            let tokens = Expression.convertToInfixArray(infixExpression: expression) //There should always be at least one value
            
            if textToAppend == "."
            {
                if let last = tokens?.last
                {
                    if !last.contains(".") && Character.isDigit(expression.last!)
                    {
                        displayText.insertText(textToAppend)
                    }
                }
            }
            else if textToAppend.isOperator()
            {
                if expression == "0" && textToAppend == Operators.subtraction.rawValue
                {
                    displayText.text = textToAppend
                }
                else if (tokens!.last!.isNumber() || tokens!.last! == ")" || tokens!.last! == "e") && expression.last! != "."
                {
                    displayText.insertText(textToAppend)
                }
                else if (tokens!.last! == "(" || tokens!.last!.isOperator() || tokens!.last!.isFunction()) && textToAppend == Operators.subtraction.rawValue //Allow for negation
                {
                    displayText.insertText(textToAppend)
                }
            }
            else if textToAppend.isFunction()
            {
                if expression == "0" || self.equalsButton.isSelected == true
                {
                    displayText.text = textToAppend
                }
                else if (tokens!.last! == "(" || tokens!.last!.isOperator() || tokens!.last!.isFunction())
                {
                    displayText.insertText(textToAppend)
                }
            }
            else if textToAppend == "("
            {
                if Character.isOperator(expression.last!) || expression.last! == "(" || tokens!.last!.isFunction()
                {
                    if self.equalsButton.isSelected == true
                    {
                        displayText.text = textToAppend
                    }
                    else
                    {
                        displayText.insertText(textToAppend)
                    }
                }
                else if expression == "0"
                {
                    displayText.text = "("
                }
            }
            else if textToAppend == ")"
            {
                if Character.isDigit(expression.last!) || expression.last! == ")"
                {
                    displayText.insertText(textToAppend)
                }
            }
            else
            {
                if displayText.text == "0"
                {
                    displayText.text = textToAppend
                }
                else if (!(tokens!.last!.contains(".")) || !(textToAppend.contains(".")))
                {
                    if self.equalsButton.isSelected == true
                    {
                        displayText.text = textToAppend
                    }
                    else
                    {
                        if expression.last != ")"
                        {
                            displayText.insertText(textToAppend)
                        }
                    }
                }
            }
            self.equalsButton.isSelected = false
        }
    }
    
    @IBAction func functionButtonPress(_ sender: Any)
    {
        tryAppendText((sender as! UIButton).titleLabel!.text!)
        tryAppendText("(")
    }
    
    @IBAction func deleteButtonPress(_ sender: Any)
    {
        backspace()
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func leftParenButtonPress(_ sender: Any)
    {
        tryAppendText("(")
        
        //animateButton(sender: sender as! UIButton)
    }
    
    
    @IBAction func rightParenButtonPress(_ sender: Any)
    {
        tryAppendText(")")
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func clearButtonPress(_ sender: Any)
    {
        displayText.text = "0"
        self.equalsButton.isSelected = false
        
        suppressErrors()
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func divideButtonPress(_ sender: Any)
    {
        tryAppendText(Operators.division.rawValue)
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func multiplyButtonPress(_ sender: Any)
    {
        tryAppendText(Operators.multiplication.rawValue)
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func exponentButtonPress(_ sender: Any)
    {
        tryAppendText(Operators.exponentiation.rawValue)
        
        //animateButton(sender: sender as! UIButton)
    }
    
    
    @IBAction func minusButtonPress(_ sender: Any)
    {
        tryAppendText(Operators.subtraction.rawValue)
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func decimalButtonPress(_ sender: Any)
    {
        tryAppendText(".")
        
        //animateButton(sender: sender as! UIButton)
    }
    @IBAction func plusButtonPress(_ sender: Any)
    {
        tryAppendText(Operators.addition.rawValue)
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func modButtonPress(_ sender: Any)
    {
        tryAppendText(Operators.modulo.rawValue)
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func answerButtonPress(_ sender: Any)
    {
        if let answer = self.savedAnswer
        {
            tryAppendText(answer)
        }
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func equalsButtonPress(_ sender: Any)
    {
        //animateButton(sender: sender as! UIButton)
        
        if let txt = displayText.text
        {
            if Expression.convertToInfixArray(infixExpression: txt)!.count == 1
            {
                suppressErrors()
                return
            }
            
            let exp = Expression(expression: txt)
            
            do
            {
                let result = try exp.evaluate()
                
                let str = String(result)
                displayText.text = str
                self.savedAnswer = str
                
                suppressErrors()
            }
            catch ExpressionError.INVALID_EXPRESSION
            {
                alertError(message: "Invalid Expression")
            }
            catch ExpressionError.CALCULATION_OVERFLOW
            {
                alertError(message: "Overflow")
            }
            catch ExpressionError.DIVIDES_BY_ZERO
            {
                alertError(message: "Error: Divides by Zero")
            }
            catch
            {
                alertError(message: "Unexpected Error")
            }
        }
    }
    
    func alertError(message: String)
    {
        self.navigationItem.title = message
        
        //Animate Navigation Bar
        self.navigationController?.navigationBar.alpha = 0.5
        
        UIView.animate(withDuration: 0.5, animations: {
            self.navigationController?.navigationBar.alpha = 1.0
            })
    }
    
    func suppressErrors()
    {
        self.navigationItem.title = "Calculator"
    }
    
    func animateButton(sender: UIButton)
    {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.1) {
                            sender.transform = CGAffineTransform.identity
                        }
        })
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isPortrait //Regular Mode
        {
            for btn in hiddenButtons
            {
                btn.isHidden = true
            }
        }
        else if UIDevice.current.orientation.isLandscape //Scientific Mode
        {
            for btn in hiddenButtons
            {
                btn.isHidden = false
            }
        }
    }
    
    /*
        Numeric Button Presses
     */
    
    @IBAction func zeroButtonPress(_ sender: Any)
    {
        tryAppendText("0")
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func oneButtonPress(_ sender: Any)
    {
        tryAppendText("1")
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func twoButtonPress(_ sender: Any)
    {
        tryAppendText("2")
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func threeButtonPress(_ sender: Any)
    {
        tryAppendText("3")
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func fourButtonPress(_ sender: Any)
    {
        tryAppendText("4")
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func fiveButtonPress(_ sender: Any)
    {
        tryAppendText("5")
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func sixButtonPress(_ sender: Any)
    {
        tryAppendText("6")
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func sevenButtonPress(_ sender: Any)
    {
        tryAppendText("7")
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func eightButtonPress(_ sender: Any)
    {
        tryAppendText("8")
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func nineButtonPress(_ sender: Any)
    {
        tryAppendText("9")
        
        //animateButton(sender: sender as! UIButton)
    }
}

extension NSLayoutConstraint
{
    /**
     Change multiplier constraint
     
     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
     */
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint
    {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
