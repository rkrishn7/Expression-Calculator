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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.displayText.delegate = self.displayText
    }

    //Tries to append char to the display
    private func tryAppendChar(_ c: Character)
    {
        if c == "."
        {
            if let txt = displayText.text
            {
                let tokens = Expression.convertToInfixArray(infixExpression: txt)
                
                let last = tokens.last!
                
                if !last.contains(".") && Character.isDigit(txt.last!)
                {
                    displayText.insertText(String(c))
                }
            }
        }
        else if Character.isOperator(c)
        {
            //Only append if the last character in the display is a number
            if let txt = displayText.text
            {
                if txt == "0" && c == OperatorCharacters.negation
                {
                    displayText.text = String(c)
                }
                else if Character.isDigit(txt.last!) || txt.last! == ")" || txt.last! == "e"
                {
                    displayText.insertText(String(c))
                }
                else if (txt.last! == "(" || Character.isOperator(txt.last!)) && c == OperatorCharacters.negation //Allow for unary negation
                {
                    displayText.insertText(String(c))
                }
            }
        }
        else if c == "("
        {
            if let txt = displayText.text
            {
                if Character.isOperator(txt.last!) || txt.last! == "("
                {
                    if self.equalsButton.isSelected == true
                    {
                        displayText.text = String(c)
                    }
                    else
                    {
                        displayText.insertText(String(c))
                    }
                }
                else if txt == "0"
                {
                    displayText.text = "("
                }
            }
        }
        else if c == ")"
        {
            if let txt = displayText.text
            {
                if Character.isDigit(txt.last!) || txt.last! == ")"
                {
                    displayText.insertText(String(c))
                }
            }
        }
        else
        {
            if displayText.text == "0"
            {
                displayText.text = String(c)
            }
            else
            {
                if self.equalsButton.isSelected == true
                {
                    displayText.text = String(c)
                }
                else
                {
                    if let txt = displayText.text
                    {
                        if txt.last != ")"
                        {
                            displayText.insertText(String(c))
                        }
                    }
                }
            }
        }
        
        self.equalsButton.isSelected = false
    }
    
    @IBAction func deleteButtonPress(_ sender: Any)
    {
        if let txt = displayText.text
        {
            if txt != "0" && txt.count != 1
            {
                /*let sub = txt.prefix(txt.count - 1)
                
                displayText.text = String(sub)*/
                
                displayText.deleteBackward()
            }
            else if txt.count == 1
            {
                displayText.text = "0"
            }
        }
        
        self.equalsButton.isSelected = false
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func leftParenButtonPress(_ sender: Any)
    {
        tryAppendChar("(")
        
        //animateButton(sender: sender as! UIButton)
    }
    
    
    @IBAction func rightParenButtonPress(_ sender: Any)
    {
        tryAppendChar(")")
        
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
        tryAppendChar(OperatorCharacters.division)
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func multiplyButtonPress(_ sender: Any)
    {
        tryAppendChar(OperatorCharacters.multiplication)
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func exponentButtonPress(_ sender: Any)
    {
        tryAppendChar(OperatorCharacters.exponentiation)
        
        //animateButton(sender: sender as! UIButton)
    }
    
    
    @IBAction func minusButtonPress(_ sender: Any)
    {
        tryAppendChar(OperatorCharacters.subtraction)
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func decimalButtonPress(_ sender: Any)
    {
        tryAppendChar(".")
        
        //animateButton(sender: sender as! UIButton)
    }
    @IBAction func plusButtonPress(_ sender: Any)
    {
        tryAppendChar(OperatorCharacters.addition)
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func modButtonPress(_ sender: Any)
    {
        tryAppendChar(OperatorCharacters.modulo)
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func answerButtonPress(_ sender: Any)
    {
        if let answer = self.savedAnswer
        {
            for c in answer
            {
                tryAppendChar(c)
            }
        }
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func equalsButtonPress(_ sender: Any)
    {
        //animateButton(sender: sender as! UIButton)
        
        if let txt = displayText.text
        {
            if Expression.convertToInfixArray(infixExpression: txt).count == 1
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
    
    /*
        Numeric Button Presses
     */
    
    @IBAction func zeroButtonPress(_ sender: Any)
    {
        tryAppendChar("0")
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func oneButtonPress(_ sender: Any)
    {
        tryAppendChar("1")
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func twoButtonPress(_ sender: Any)
    {
        tryAppendChar("2")
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func threeButtonPress(_ sender: Any)
    {
        tryAppendChar("3")
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func fourButtonPress(_ sender: Any)
    {
        tryAppendChar("4")
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func fiveButtonPress(_ sender: Any)
    {
        tryAppendChar("5")
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func sixButtonPress(_ sender: Any)
    {
        tryAppendChar("6")
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func sevenButtonPress(_ sender: Any)
    {
        tryAppendChar("7")
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func eightButtonPress(_ sender: Any)
    {
        tryAppendChar("8")
        
        //animateButton(sender: sender as! UIButton)
    }
    
    @IBAction func nineButtonPress(_ sender: Any)
    {
        tryAppendChar("9")
        
        //animateButton(sender: sender as! UIButton)
    }
}
