//
//  MathUtilities.swift
//  Calculator
//
//  Created by User on 3/31/19.
//  Copyright © 2019 Rohan Krishnaswamy. All rights reserved.
//

import Foundation

class MathUtilities
{
    init()
    {
        
    }
    
    func convertToFraction(decimal: NSDecimalNumber) -> String
    {
        let num = String(describing: decimal)
        
        if !num.contains("."){
            return num + Operators.fractionalDivision.rawValue + "1"
        }
        
        var whole = String(num[num.startIndex..<num.lastIndex(of: ".")!])
        let dec   = String(num[num.index(after: num.lastIndex(of: ".")!)..<num.endIndex])
        
        var neg = false
        
        if whole.contains(Operators.subtraction.rawValue)
        {
            let c = whole.findInstances(of: Character(Operators.subtraction.rawValue))
            
            neg = c % 2 != 0
        }
        
        whole = whole.replacingOccurrences(of: "-", with: "")
        
        var precision = NSDecimalNumber(value: 1)
        
        for _ in dec{
            precision = precision.multiplying(by: NSDecimalNumber(value: 10))
        }
        
        let numerator = (NSDecimalNumber(string: whole).multiplying(by: precision)).adding(NSDecimalNumber(string: dec)).uint64Value
        
        return reduceFraction(numerator: numerator, denominator: precision.uint64Value, neg: neg)
    }
    
    func reduceFraction(numerator: UInt64, denominator: UInt64, neg: Bool) -> String
    {
        let x = gcd(numerator: numerator, denominator: denominator)
        
        return ((neg) ? Operators.subtraction.rawValue : "") + String(numerator / x) + Operators.fractionalDivision.rawValue + String(denominator / x)
    }
    
    func gcd(numerator: UInt64, denominator: UInt64) -> UInt64
    {
        var dividend = (numerator >= denominator) ? numerator : denominator
        var divisor  = (numerator <= denominator) ? numerator : denominator
        
        while(divisor != 0)
        {
            let remainder = dividend % divisor
            dividend = divisor
            divisor = remainder
        }
        
        return dividend
    }
}
