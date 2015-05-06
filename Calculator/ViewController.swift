//
//  ViewController.swift
//  Calculator
//
//  Created by Sam Winter on 5/5/15.
//  Copyright (c) 2015 Sam Winter. All rights reserved.
//

// Math symbols
// + − × ÷

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    var userIsInTheMiddleOfTypingANumber = false
    var operandStack = [Double]()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        switch digit {
        case ".":
            // If the '.' is in the string
            if display.text!.rangeOfString(digit) != nil {
                return
            }
        default: break
        }
        
        if userIsInTheMiddleOfTypingANumber {
            display.text! += digit
        }
        else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func appendConstant(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        switch digit {
        case "π":
            displayValue = M_PI
        default: break
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        switch(operation) {
        case "×": performBinaryOperation { $0 * $1 }
        case "÷": performBinaryOperation { $1 / $0 }
        case "+": performBinaryOperation { $0 + $1 }
        case "−": performBinaryOperation { $1 - $0 }
        case "√": performUnaryOperation(sqrt)
        case "sin": performUnaryOperation(sin)
        case "cos": performUnaryOperation(cos)
        default: break
        }
    }
    
    func performBinaryOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performUnaryOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    @IBAction func clear(sender: UIButton) {
        // Clear the stack and the display text
//        displayValue = 0
        display.text = "0"
        operandStack.removeAll(keepCapacity: false)
    }

    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

