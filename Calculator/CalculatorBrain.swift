//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Брызгалов Николай on 01.02.15.
//  Copyright (c) 2015 Брызгалов Николай. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op {
        case Operand(Double)
        case UnaryOperand(description: String, Double -> Double)
        case Constant(description: String, () -> Double)
        case BinaryOperand(description: String, (Double, Double) -> Double)
        case Variable(description: String, Double -> Double)
    }
    
    private var opStack = [Op]()
    
    private var knowOps = [String:Op]()
    
    var variableValues = [String:Double]()
    
    var description: String {
        get {
            var result = ""
            for op in opStack {
                switch op {
                case .Operand(let operand):
                    let (res, _) = evaluate([op])
                    if res != nil {
                        result += NSNumberFormatter.localizedStringFromNumber(NSNumber(double: res!), numberStyle: NSNumberFormatterStyle.DecimalStyle)
                    }
                case .UnaryOperand(let unaryName, let value):
                    let (res, _) = evaluate([op])
                    if res != nil {
                        result += "\(unaryName)"
                        result += NSNumberFormatter.localizedStringFromNumber(NSNumber(double: res!), numberStyle: NSNumberFormatterStyle.DecimalStyle)
                    }
                default: break
                }
            }
            return ""
        }
    }
    
    init() {
        knowOps["×"] = Op.BinaryOperand(description: "×", *)
        knowOps["÷"] = Op.BinaryOperand(description: "÷") {$1 / $0}
        knowOps["+"] = Op.BinaryOperand(description: "+", +)
        knowOps["−"] = Op.BinaryOperand(description: "−") {$1 - $0}
        knowOps["√"] = Op.UnaryOperand(description: "√", sqrt)
        knowOps["SIN"] = Op.UnaryOperand(description: "√", sin)
        knowOps["COS"] = Op.UnaryOperand(description: "√", cos)
        knowOps["π"] = Op.Constant(description: "π", { M_PI } )
    }
    
    func flushStack() {
        opStack.removeAll(keepCapacity: true)
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        println("\(opStack)")
        return evaluate()
    }
    
    func pushOperand(operand: String) -> Double? {
        opStack.append(Op.Variable(description: operand) { $0 } )
        println("\(opStack)")
        return evaluate()
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remaingOps: [Op]) {
        
        if !ops.isEmpty {
            var remaingOps = ops
            let op = remaingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remaingOps)
            case .UnaryOperand(_, let operation):
                let operandEvaluation = evaluate(remaingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remaingOps)
                }
            case .BinaryOperand(_, let operation):
                let op1Evaluation = evaluate(remaingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remaingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remaingOps)
                    }
                }
            case .Constant(_, let operation):
                return (operation(), remaingOps)
            case .Variable(let variableName, let variable):
                let operandEvaluation = evaluate(remaingOps)
                if let variableValue = variableValues[variableName] {
                    return (variable(variableValue), operandEvaluation.remaingOps)
                }
            }
        }
        
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, _ ) = evaluate(opStack)
        return result
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knowOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}
