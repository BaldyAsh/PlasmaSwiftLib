//
//  OutputsManagement.swift
//  PlasmaSwiftLib
//
//  Created by Anton Grigorev on 23.10.2018.
//  Copyright © 2018 The Matter. All rights reserved.
//

import Foundation
import BigInt

extension Transaction {
    func mergeOutputs(until maxAmount: BigUInt) -> Transaction? {
        let receiverAddress = self.outputs[0].receiverEthereumAddress
        
        var sortedOutputs: Array<TransactionOutput> = self.outputs.sorted { $0.amount <= $1.amount }
        
        var mergedAmount: BigUInt = 0
        var mergedCount: BigUInt = 0
        
        for output in sortedOutputs {
            let currentOutputAmount = output.amount
            if currentOutputAmount <= (maxAmount - mergedAmount) {
                mergedCount += 1
                mergedAmount += currentOutputAmount
            } else {
                break
            }
        }
        
        guard mergedCount > 1 else { return nil }
        print(mergedCount)
//        guard let mergedOutput = TransactionOutput(outputNumberInTx: newOutputsCount, receiverEthereumAddress: receiverAddress, amount: mergedAmount) else {return nil}
        
        sortedOutputs.removeFirst(Int(mergedCount))
        
        var newOutputsArray: Array<TransactionOutput> = []
        var index: BigUInt = 0
        for output in sortedOutputs {
            guard let fixedOutput = TransactionOutput(outputNumberInTx: index, receiverEthereumAddress: receiverAddress, amount: output.amount) else {return nil}
            newOutputsArray.append(fixedOutput)
            index += 1
        }
        guard let mergedOutput = TransactionOutput(outputNumberInTx: index, receiverEthereumAddress: receiverAddress, amount: mergedAmount) else {return nil}
        newOutputsArray.append(mergedOutput)
        
        guard let fixedTx = Transaction(txType: self.txType, inputs: self.inputs, outputs: newOutputsArray) else {return nil}
        
        return fixedTx
    }
}
