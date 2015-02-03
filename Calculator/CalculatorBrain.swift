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
        case UnaryOperand(String, Double -> Double)
        case BinaryOperand(String, (Double, Double) -> Double)

    }
    
    private var opStack = [Op]()
    
    private var knowOps = [String:Op]()
    
    init() {
        knowOps["×"] = Op.BinaryOperand("×", *)
        knowOps["÷"] = Op.BinaryOperand("÷") {$1 / $0}
        knowOps["+"] = Op.BinaryOperand("+", +)
        knowOps["−"] = Op.BinaryOperand("−") {$1 - $0}
        knowOps["√"] = Op.UnaryOperand("√", sqrt)
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
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
