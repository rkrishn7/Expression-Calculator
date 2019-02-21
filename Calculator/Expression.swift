//
//  Expression.swift
//  Calculator
//
//  Created by User on 2/11/19.
//  Copyright © 2019 Rohan Krishnaswamy. All rights reserved.
//

import Foundation

class Expression
{
    private var exp: String!
    
    init(expression exp: String!)
    {
        self.exp = exp
    }
    
    func evaluate() throws -> Double //implicitly internal
    {
        do
        {
            let result = try evaluate(infixExp: self.exp)
            
            return result
        }
        catch ExpressionError.INVALID_EXPRESSION
        {
            throw ExpressionError.INVALID_EXPRESSION
        }
        catch ExpressionError.CALCULATION_OVERFLOW
        {
            throw ExpressionError.CALCULATION_OVERFLOW
        }
    }
    
    /*
     *Evaluates the given infix expression
     *Throws INVALID_EXPRESSION error if the input expression is not formatted correctly
     *Throws CALCULATION_OVERFLOW error if the calculation is too large
     */
    private func evaluate(infixExp: String!) throws -> Double
    {
        do
        {
            let postfix = try convertToPostfix(infixExp: exp)
            
            var output = Stack<String>()
            
            for token in postfix
            {
                if Character.isDigit(token[token.startIndex]) || token == "-1"
                {
                    output.push(token)
                }
                else
                {
                    if let x = output.pop(), let y = output.pop()
                    {
                        let val1 = NSDecimalNumber(string: x)
                        let val2 = NSDecimalNumber(string: y)
                        
                        
                        //Catch dividing by zero
                        if val1 == NSDecimalNumber(value: 0) && token == String(OperatorCharacters.division)
                        {
                            throw ExpressionError.DIVIDES_BY_ZERO
                        }
                        
                        switch token
                        {
                            case String(OperatorCharacters.addition):
                                output.push(String(describing: val2.adding(val1)))
                            case String(OperatorCharacters.subtraction):
                                output.push(String(describing: val2.subtracting(val1)))
                            case String(OperatorCharacters.multiplication):
                                output.push(String(describing: val2.multiplying(by: val1)))
                            case String(OperatorCharacters.division):
                                output.push(String(describing: val2.dividing(by: val1)))
                            case String(OperatorCharacters.modulo):
                                output.push(String(describing: val2.doubleValue.truncatingRemainder(dividingBy: val1.doubleValue)))
                            case String(OperatorCharacters.exponentiation):
                                output.push(String(pow(val2.doubleValue, val1.doubleValue)))
                            default:
                                throw ExpressionError.INVALID_EXPRESSION
                        }
                        
                        if let t = output.peek()
                        {
                            let ns = NSDecimalNumber(string: t)
                            
                            if ns == NSDecimalNumber.notANumber
                            {
                                throw ExpressionError.CALCULATION_OVERFLOW
                            }
                        }
                    }
                    else
                    {
                        throw ExpressionError.INVALID_EXPRESSION
                    }
                }
            }
            
            if let result = output.pop()
            {
                let nsDecimalResult = NSDecimalNumber(string: result)
                
                if nsDecimalResult == NSDecimalNumber.notANumber
                {
                    throw ExpressionError.CALCULATION_OVERFLOW
                }
                else
                {
                    return nsDecimalResult.doubleValue
                }
            }
            else
            {
                throw ExpressionError.INVALID_EXPRESSION
            }
            
        }
        catch ExpressionError.INVALID_EXPRESSION
        {
            throw ExpressionError.INVALID_EXPRESSION
        }
    }
    
    
    
    /*
     *Converts an infix expression to a postfix one
     *For example, 5 * 2 + 3 -> 5 2 * 3 +
     *Throws INVALID_EXPRESSION error if the input expression is not formatted properfly
     */
    private func convertToPostfix(infixExp: String) throws -> [String]
    {
        var stk = Stack<String>()
        
        let tokens = Expression.convertToInfixArray(infixExpression: exp)
        var output = [String]()
        
        for token in tokens
        {
            if Character.isDigit(token[token.startIndex]) || token == "-1"
            {
                output.append(token)
            }
            else if token[token.startIndex] == "("
            {
                stk.push(String(token))
            }
            else if token[token.startIndex] == ")"
            {
                while(!stk.isEmpty() && stk.peek() != "(")
                {
                    if let t = stk.pop()
                    {
                        output.append(t)
                    }
                    else
                    {
                        throw ExpressionError.INVALID_EXPRESSION
                    }
                }
                
                if(!stk.isEmpty() && stk.peek() == "(")
                {
                    let t = stk.pop()
                    
                    if t == nil
                    {
                        throw ExpressionError.INVALID_EXPRESSION
                    }
                }
            }
            else
            {
                //We can forcibly peek since we know the stack is not empty
                while(!stk.isEmpty() && precedence(token[token.startIndex]) <= precedence(stk.peek()![stk.peek()!.startIndex]))
                {
                    if let t = stk.pop()
                    {
                        output.append(t)
                    }
                    else
                    {
                        throw ExpressionError.INVALID_EXPRESSION
                    }
                }
                
                stk.push(String(token))
            }
        }
        
        while(!stk.isEmpty())
        {
            if let t = stk.pop()
            {
                output.append(t)
            }
            else
            {
                throw ExpressionError.INVALID_EXPRESSION
            }
        }
        
        return output
    }
    
    /*
     *Returns the operator precedence of 'op'
     */
    private func precedence(_ op: Character?) -> Int
    {
        switch op
        {
            case OperatorCharacters.addition, OperatorCharacters.subtraction:
                return 1
            case OperatorCharacters.multiplication, OperatorCharacters.division, OperatorCharacters.modulo:
                return 2
            case OperatorCharacters.exponentiation:
                return 3
            default:
                return -1
        }
    }
    
    /*
     *Converts the given infix expression to an array of tokens
     *For example: "2 + 232 / 34 * -9" -> ["2", "+", "232", "/", "34", "*", "(", "-1", "*", "9", ")"]
     *Negative numbers are inputted into the array as follows" "(", "-1", "*", "NUMBER", ")"
     */
    static func convertToInfixArray(infixExpression: String) -> [String]
    {
        var tokens = [String]()
        
        var partialToken = ""
        
        var index = infixExpression.startIndex
        
        //Store the number of left parentheses, we'll need this when evaluating negative numbers
        var lParenCount = 0
        
        //Loop until end of expression
        while index < infixExpression.endIndex
        {
            //Loop while our character is a digit/decimal point
            while index < infixExpression.endIndex &&
                (Character.isDigit(infixExpression[index]) || infixExpression[index] == ".")
            {
                //Add digit to partial token
                partialToken += String(infixExpression[index])
                
                //Increment index
                index = infixExpression.index(index, offsetBy: 1)
            }
            
            //Check if our token is in scientific notation
            if index < infixExpression.endIndex && infixExpression[index] == "e"
            {
                //We expect a '+' followed by a string of digits
                partialToken += String(infixExpression[index])
                
                index = infixExpression.index(index, offsetBy: 1)
                
                //Loop while our character is a digit/plus sign
                while index < infixExpression.endIndex &&
                    (Character.isDigit(infixExpression[index]) || infixExpression[index] == OperatorCharacters.addition)
                {
                    //Add to partial token
                    partialToken += String(infixExpression[index])
                    
                    //Increment index
                    index = infixExpression.index(index, offsetBy: 1)
                }
            }
            
            //If there exists a token, add it to the array
            if !partialToken.isEmpty
            {
                tokens.append(partialToken)
                partialToken = ""
            }
            
            //Append a right parentheses for every left
            for _ in 0..<lParenCount
            {
                tokens.append(")")
            }
            
            lParenCount = 0
            
            if index < infixExpression.endIndex && Character.isOperator(infixExpression[index])
            {
                if infixExpression[index] == OperatorCharacters.negation
                {
                    let indexBefore = (index == infixExpression.startIndex) ? infixExpression.startIndex : infixExpression.index(index, offsetBy: -1)
                    
                    //Check if the character before it is an operator or a left parentheses
                    if Character.isOperator(infixExpression[indexBefore]) || infixExpression[indexBefore] == "("
                        || indexBefore == infixExpression.startIndex
                    {
                        
                        //Add (-1 x 'number')
                        while index < infixExpression.endIndex && infixExpression[index] == OperatorCharacters.negation
                        {
                            tokens.append("(")
                            tokens.append("-1")
                            tokens.append(String(OperatorCharacters.multiplication))
                            
                            lParenCount += 1
                            
                            index = infixExpression.index(index, offsetBy: 1)
                        }
                        
                        //Next character should be a digit, continue to top of loop to read it
                        continue
                    }
                    else //We are evaluating for subtraction
                    {
                        tokens.append(String(infixExpression[index]))
                        index = infixExpression.index(index, offsetBy: 1)
                    }
                }
                else //If it's another operator, add it to the tokens array
                {
                    tokens.append(String(infixExpression[index]))
                    index = infixExpression.index(index, offsetBy: 1)
                }
            }
            //Add parentheses to token array
            if index < infixExpression.endIndex && (infixExpression[index] == "(" || infixExpression[index] == ")")
            {
                tokens.append(String(infixExpression[index]))
                index = infixExpression.index(index, offsetBy: 1)
            }
        }
        //Add any leftover partial token
        if !partialToken.isEmpty
        {
            tokens.append(partialToken)
            partialToken = ""
        }
        
        return tokens
    }
}

struct OperatorCharacters
{
    static let multiplication: Character = "×" //Unicode Character
    static let division: Character = "÷" //Unicode Character
    static let subtraction: Character = "-"
    static let addition: Character = "+"
    static let modulo: Character = "%"
    static let exponentiation: Character = "^"
    
    //Unary operators
    static let negation: Character = "-"
}

enum ExpressionError: Error
{
    case INVALID_EXPRESSION
    case CALCULATION_OVERFLOW
    case DIVIDES_BY_ZERO
}
