//
//  CharacterExtensions.swift
//  Calculator
//
//  Created by User on 2/21/19.
//  Copyright © 2019 Rohan Krishnaswamy. All rights reserved.
//

import Foundation

extension Character
{
    static func isDigit(_ char: Character) -> Bool
    {
        return (char >= "0" && char <= "9")
    }
    
    static func isHexChar(_ char: Character) -> Bool
    {
        return (char >= "A" && char <= "F")
    }
    
    static func isOperator(_ char: Character) -> Bool
    {
        return char == OperatorCharacters.addition || char == OperatorCharacters.subtraction    ||
            char == OperatorCharacters.division || char == OperatorCharacters.multiplication ||
            char == OperatorCharacters.modulo   || char == OperatorCharacters.exponentiation ||
            char == OperatorCharacters.negation
    }
}
