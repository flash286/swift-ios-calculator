//
//  ViewController.swift
//  Calculator
//
//  Created by Брызгалов Николай on 01.02.15.
//  Copyright (c) 2015 Брызгалов Николай. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber: Bool = false
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        var digit = sender.currentTitle!
        println("current digit: \(digit)")
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            performCalculate()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            }
        } else {
            displayValue = 0
        }
    }
    
    @IBAction func clearDisplay() {
        displayValue = 0
        brain.flushStack()
    }
    
    @IBAction func performCalculate() {
        userIsInTheMiddleOfTypingANumber = false;
        if let value = displayValue {
            if let result = brain.pushOperand(value) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    var displayValue: Double? {
        get {
            if let text = display.text {
                return NSNumberFormatter().numberFromString(text)?.doubleValue
            } else {
                return nil
            }
        }
        set {
            if newValue != nil {
                var newValue = NSNumberFormatter.localizedStringFromNumber(NSNumber(double: newValue!), numberStyle: NSNumberFormatterStyle.DecimalStyle)
                display.text = "\(newValue)"
            } else {
                display.text = ""
            }
        }
    }
    
}

