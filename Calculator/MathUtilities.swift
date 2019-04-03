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
        
        let whole = num[num.startIndex..<num.lastIndex(of: ".")!]
        let dec   = num[num.index(after: num.lastIndex(of: ".")!)..<num.endIndex]
        
        var precision = NSDecimalNumber(value: 1)
        
        for _ in dec{
            precision = precision.multiplying(by: NSDecimalNumber(value: 10))
        }
        
        let numerator = (NSDecimalNumber(string: String(whole)).multiplying(by: precision)).adding(NSDecimalNumber(string: String(dec))).uint64Value
        
        return reduceFraction(numerator: numerator, denominator: precision.uint64Value)
    }
    
    func reduceFraction(numerator: UInt64, denominator: UInt64) -> String
    {
        let x = gcd(numerator: numerator, denominator: denominator)
        
        return String(numerator / x) + Operators.fractionalDivision.rawValue + String(denominator / x)
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
