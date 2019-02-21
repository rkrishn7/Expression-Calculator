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
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        //self.resignFirstResponder()
        
        return true
    }
    
    override func insertText(_ text: String)
    {
        if textView(self, shouldChangeTextIn: NSRange(location: self.text.startIndex.encodedOffset, length: self.text.endIndex.encodedOffset), replacementText: text)
        {
            super.insertText(text)
        }
    }
}
