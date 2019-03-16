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
    
    init(expression exp: String)
    {
        self.exp = exp
    }
    
    func evaluate() throws -> Double
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
                if token.isNumber()
                {
                    output.push(token)
                }
                else if token.isFunction()
                {
                    if let x = output.pop()
                    {
                        let val1 = NSDecimalNumber(string: x)
                        
                        switch token
                        {
                            case Functions.sin.rawValue:
                                output.push(String(sin(val1.doubleValue)))
                            case Functions.cos.rawValue:
                                output.push(String(cos(val1.doubleValue)))
                            case Functions.tan.rawValue:
                                output.push(String(tan(val1.doubleValue)))
                            case Functions.sininv.rawValue:
                                output.push(String(sinh(val1.doubleValue)))
                            case Functions.cosinv.rawValue:
                                output.push(String(cosh(val1.doubleValue)))
                            case Functions.taninv.rawValue:
                                output.push(String(tanh(val1.doubleValue)))
                            case Functions.log.rawValue:
                                output.push(String(log(val1.doubleValue)/log(10)))
                            case Functions.ln.rawValue:
                                output.push(String(log(val1.doubleValue)/Double(log(Irrationals.e.rawValue))))
                            case Functions.sqrt.rawValue:
                                output.push(String(sqrt(val1.doubleValue)))
                            case Functions.cubert.rawValue:
                                output.push(String(pow(val1.doubleValue, 1 / 3)))
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
        
        for token in (tokens ?? [])
        {
            //if Character.isDigit(token[token.startIndex]) || token == "-1"
            if token.isNumber()
            {
                output.append(token)
            }
                //else if token[token.startIndex] == "("
            else if token == "("
            {
                stk.push(String(token))
            }
                //else if token[token.startIndex] == ")"
            else if token == ")"
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
                //while(!stk.isEmpty() && precedence(token[token.startIndex]) <= precedence(stk.peek()![stk.peek()!.startIndex]))
                while(!stk.isEmpty() && precedence(token: token) <= precedence(token: stk.peek()!))
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
    private func precedence(token: String) -> Int
    {
        if token.isFunction()
        {
            return 4
        }
        else
        {
            switch token
            {
            case Operators.addition.rawValue, Operators.subtraction.rawValue:
                return 1
            case Operators.multiplication.rawValue, Operators.division.rawValue, Operators.modulo.rawValue:
                return 2
            case Operators.exponentiation.rawValue:
                return 3
            default:
                return -1
            }
        }
    }
    
    /*
     *Converts the given infix expression to an array of tokens
     *For example: "2 + 232 / 34 * -9" -> ["2", "+", "232", "/", "34", "*", "-9"]
     */
    static func convertToInfixArray(infixExpression: String) -> [String]?
    {
        do
        {
            var pattern = "(?<!\\d)-*\\d+(?:\\.\\d+)?|"
            
            
            //Add character class for the operators
            pattern += "["
            
            for op in Operators.allCases
            {
                pattern += op.rawValue
            }
            
            pattern += "()" //Don't forget about parentheses
            pattern += "]"
            pattern += "|"
            
            //Add capturing group for each function
            for i in 0..<Functions.allCases.count
            {
                pattern += "(\(Functions.allCases[i].rawValue))"
                
                if i != Functions.allCases.count - 1
                {
                    pattern += "|"
                }
            }
            
            let regex = try NSRegularExpression(pattern: pattern)
            
            let results = regex.matches(in: infixExpression, range: NSRange(infixExpression.startIndex..., in: infixExpression))
            
            var tokens = results.map
            {
                String(infixExpression[Range($0.range, in: infixExpression)!])
            }
            
            //Changing tokens with two or more negation signs to have only one negation sign
            //Example: "-----3" -> "-3"
            for i in 0..<tokens.count
            {
                if tokens[i].starts(with: "--")
                {
                    let c = tokens[i].findInstances(of: "-")
                    
                    let end   = tokens[i].index(tokens[i].lastIndex(of: "-")!, offsetBy: 1)
                    
                    let num = tokens[i][end..<tokens[i].endIndex]
                    
                    if c % 2 != 0
                    {
                        tokens[i] = "-" + num
                    }
                    else
                    {
                        tokens[i] = String(num)
                    }
                }
            }
            
            return tokens
        }
        catch
        {
            return nil
        }
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

extension String
{
    func isNumber() -> Bool
    {
        if self == "-"
        {
            return false
        }
        if self.findInstances(of: ".") > 1
        {
            return false
        }
        
        if let last = self.last
        {
            if last == "."
            {
                return false
            }
        }
        
        for i in 0..<self.count
        {
            if (!Character.isDigit(self[index(self.startIndex, offsetBy: i)])) && (self[index(self.startIndex, offsetBy: i)] != ".")
            {
                if (i == 0 && self[index(self.startIndex, offsetBy: i)] == "-")
                {
                    continue
                }
                else
                {
                    return false
                }
            }
        }
        
        return true
    }
    
    func isOperator() -> Bool
    {
        return
            self == Operators.addition.rawValue || self == Operators.subtraction.rawValue    ||
            self == Operators.division.rawValue || self == Operators.multiplication.rawValue ||
            self == Operators.modulo.rawValue   || self == Operators.exponentiation.rawValue
    }
    
    
    func isFunction() -> Bool
    {
        for function in Functions.allCases
        {
            if self == function.rawValue
            {
                return true
            }
        }
        
        return false
    }
    
    func findInstances(of cToFind: Character) -> Int
    {
        var count = 0
        
        for char in self
        {
            if char == cToFind
            {
                count += 1
            }
        }
        
        return count
    }
}

enum Functions: String, CaseIterable
{
    case cosinv = "cos⁻¹" //Unicode
    case sininv = "sin⁻¹" //Unicode
    case taninv = "tan⁻¹" //Unicode
    case cos = "cos"
    case sin = "sin"
    case tan = "tan"
    case ln  = "ln"
    case log = "log₁₀"
    case sqrt = "√" //Unicode
    case cubert = "∛"
    case factorial = "!"
}

enum Operators: String, CaseIterable
{
    case subtraction = "-" //DO NOT CHANGE THE POSITION OF THIS CASE
    case multiplication = "×" //Unicode
    case division = "÷" //Unicode
    case addition = "+"
    case modulo = "%"
    case exponentiation = "^"
}

enum Irrationals: Float
{
    case e = 2.71828
}

