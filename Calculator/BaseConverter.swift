//
//  BaseConverter.swift
//  Calculator
//
//  Created by User on 2/28/19.
//  Copyright © 2019 Rohan Krishnaswamy. All rights reserved.
//

import Foundation

class BaseConverter
{
    init()
    {
        //
    }
    
    func convertTo(base: BaseType, input: String) -> String?
    {
        let inputBase = getBaseType(of: input)
        
        if inputBase == nil{
            return nil
        }
        
        var formattedInput = input
        
        var input_radix = 10
        
        if inputBase == BaseType.Binary
        {
            formattedInput = input.replacingOccurrences(of: "0b", with: "", options: .literal, range: nil)
            input_radix = 2
        }
        else if inputBase == BaseType.Hex
        {
            formattedInput = input.replacingOccurrences(of: "0x", with: "", options: .literal, range: nil)
            input_radix = 16
        }
        
        var result_radix = 10
        
        var prefix = ""
        
        if base == BaseType.Binary
        {
            result_radix = 2
            prefix = "0b"
        }
        else if base == BaseType.Hex
        {
            result_radix = 16
            prefix = "0x"
        }
        
        let num = Int(formattedInput, radix: input_radix)
        
        if let result = num
        {
            return (prefix + String(result, radix: result_radix).uppercased())
        }
        
        return nil
    }
    
    private func getBaseType(of input: String) -> BaseType?
    {
        if input.hasPrefix("0b")
        {
            return BaseType.Binary
        }
        else if input.hasPrefix("0x")
        {
            return BaseType.Hex
        }
        else if let f = input.first
        {
            if Character.isDigit(f)
            {
                return BaseType.Decimal
            }
        }
        
        return nil
    }
}

enum BaseType
{
    case Decimal
    case Binary
    case Hex
}
