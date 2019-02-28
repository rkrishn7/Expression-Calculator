//
//  ExpressionView.swift
//  Calculator
//
//  Created by User on 2/20/19.
//  Copyright © 2019 Rohan Krishnaswamy. All rights reserved.
//

import UIKit



class ExpressionView: UITextView, UITextViewDelegate
{
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect, textContainer: NSTextContainer?)
    {
        super.init(frame: frame, textContainer: textContainer)
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        if let c = self.text.last
        {
            if c == ")"
            {
                highlightMatchingParentheses(indexOfRParen: self.text.index(before: self.text.endIndex))
                resetTypingAttributes()
            }
            else{
                resetTextAttributes()
            }
        }
        
        //
    }
    
    private func resetTypingAttributes()
    {
        let default_attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25.0, weight: UIFont.Weight.ultraLight),
                                  NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.typingAttributes = default_attributes
    }
    
    private func resetTextAttributes()
    {
        if let txt = self.text
        {
            let attributed = NSMutableAttributedString(string: txt)
            
            let default_attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25.0, weight: UIFont.Weight.ultraLight),
                                      NSAttributedString.Key.foregroundColor: UIColor.white]
            
            attributed.addAttributes(default_attributes, range: NSMakeRange(0, txt.count))
            
            self.attributedText = attributed
        }
    }
    
    private func highlightMatchingParentheses(indexOfRParen: String.Index)
    {
        if self.text == nil{
            return
        }
    
        let txt = self.text!
        
        var z = indexOfRParen
        var c = 0
        var match: String.Index?
        
        while z >= txt.startIndex
        {
            if txt[z] == ")"{
                c += 1
            }
            else if txt[z] == "("
            {
                c -= 1
                
                if c == 0{
                    match = z
                    break
                }
            }
            
            z = txt.index(z, offsetBy: -1)
        }
        
        let attributedTxt = NSMutableAttributedString(string: txt)
        
        let default_attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25.0, weight: UIFont.Weight.ultraLight),
                                  NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let custom_attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30.0, weight: UIFont.Weight.ultraLight),
                                 NSAttributedString.Key.foregroundColor: UIColor.yellow]

        attributedTxt.addAttributes(default_attributes, range: NSMakeRange(0, txt.count))
        
        attributedTxt.addAttributes(custom_attributes, range: NSRange(location: match!.encodedOffset, length: 1))
        
        attributedTxt.addAttributes(custom_attributes, range: NSRange(location: indexOfRParen.encodedOffset, length: 1))
        
        self.attributedText = attributedTxt
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        //Check parentheses count
        
        var lParenCount = 0
        var rParenCount = 0
        
        let new_str = self.text + text
        
        for c in new_str
        {
            if c == "("{
                lParenCount += 1
            }
            else if c == ")"{
                rParenCount += 1
            }
        }
        
        if rParenCount > lParenCount{
            return false
        }
        
        return true
    }
    
    override func insertText(_ text: String)
    {
        if textView(self, shouldChangeTextIn: NSRange(location: self.text.startIndex.encodedOffset, length: self.text.endIndex.encodedOffset), replacementText: text)
        {
            super.insertText(text)
        }
    }
    
    //
}
