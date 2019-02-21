//
//  Stack.swift
//  Calculator
//
//  Created by User on 2/11/19.
//  Copyright © 2019 Rohan Krishnaswamy. All rights reserved.
//

import Foundation

struct Stack<T>
{
    var arr = [T]()
    
    mutating func push(_ element: T)
    {
        arr.append(element)
    }
    
    mutating func pop() -> T?
    {
        if arr.count == 0
        {
            return nil
        }
        else
        {
            return arr.removeLast()
        }
    }
    
    func peek() -> T?
    {
        return arr.last
    }
    
    func size() -> Int
    {
        return arr.count
    }
    
    func isEmpty() -> Bool
    {
        return arr.count == 0
    }
}
