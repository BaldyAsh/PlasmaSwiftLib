//
//  PlasmaSwiftLibTests.swift
//  PlasmaSwiftLibTests
//
//  Created by Anton Grigorev on 18.10.2018.
//  Copyright © 2018 The Matter. All rights reserved.
//

import XCTest
import BigInt
import EthereumAddress

@testable import PlasmaSwiftLib

class TransactionTests: XCTestCase {

    func formInputsForTransaction() -> [TransactionInput]? {
        let blockNumber1In: BigUInt = 10
        let txNumberInBlock1In: BigUInt = 1
        let outputNumberInTx1In: BigUInt = 3
        let amount1In: BigUInt = 5
        guard let input1 = TransactionInput(blockNumber: blockNumber1In,
                                            txNumberInBlock: txNumberInBlock1In,
                                            outputNumberInTx: outputNumberInTx1In,
                                            amount: amount1In) else {return nil}

        let blockNumber2In: BigUInt = 10
        let txNumberInBlock2In: BigUInt = 1
        let outputNumberInTx2In: BigUInt = 3
        let amount2In: BigUInt = 4
        guard let input2 = TransactionInput(blockNumber: blockNumber2In,
                                            txNumberInBlock: txNumberInBlock2In,
                                            outputNumberInTx: outputNumberInTx2In,
                                            amount: amount2In) else {return nil}
        return [input1, input2]
    }

    func formOutputsForTransaction() -> [TransactionOutput]? {
        let outputNumberInTx1Out: BigUInt = 3
        let receiverEthereumAddress1Out: EthereumAddress = EthereumAddress("0x6891dc3962e710f0ff711b9c6acc26133fd35cb4")!
        let amount1Out: BigUInt = 3
        guard let output1 = TransactionOutput(outputNumberInTx: outputNumberInTx1Out,
                                              receiverEthereumAddress: receiverEthereumAddress1Out,
                                              amount: amount1Out) else {return nil}

        let outputNumberInTx2Out: BigUInt = 3
        let receiverEthereumAddress2Out: EthereumAddress = EthereumAddress("0x6891dc3962e710f0ff711b9c6acc26133fd35cb5")!
        let amount2Out: BigUInt = 2
        guard let output2 = TransactionOutput(outputNumberInTx: outputNumberInTx2Out,
                                              receiverEthereumAddress: receiverEthereumAddress2Out,
                                              amount: amount2Out) else {return nil}

        let outputNumberInTx3Out: BigUInt = 3
        let receiverEthereumAddress3Out: EthereumAddress = EthereumAddress("0x6891dc3962e710f0ff711b9c6acc26133fd35ca5")!
        let amount3Out: BigUInt = 4
        guard let output3 = TransactionOutput(outputNumberInTx: outputNumberInTx3Out,
                                              receiverEthereumAddress: receiverEthereumAddress3Out,
                                              amount: amount3Out) else {return nil}
        return [output1, output2, output3]
    }

    func testInput() {
        let blockNumber: BigUInt = 10
        let txNumberInBlock: BigUInt = 1
        let outputNumberInTx: BigUInt = 1
        let amount: BigUInt = 500000000000000
        guard let input1 = TransactionInput(blockNumber: blockNumber, txNumberInBlock: txNumberInBlock, outputNumberInTx: outputNumberInTx, amount: amount) else {return}
        let data = input1.data
        guard let input2 = TransactionInput(data: data) else {return}
        print("input passed")
        XCTAssert(input1 == input2)
    }

    func testOutput() {
        let outputNumberInTx: BigUInt = 10
        let receiverEthereumAddress: EthereumAddress = EthereumAddress("0x6891dc3962e710f0ff711b9c6acc26133fd35cb4")!
        let amount: BigUInt = 500000000000000
        guard let output1 = TransactionOutput(outputNumberInTx: outputNumberInTx, receiverEthereumAddress: receiverEthereumAddress, amount: amount) else {return}
        let data = output1.data
        guard let output2 = TransactionOutput(data: data) else {return}
        print("output passed")
        XCTAssert(output1 == output2)
    }

    func testEmptyTransaction() {
        let txType = Transaction.TransactionType.split
        let inputs = [TransactionInput]()
        let outputs = [TransactionOutput]()

        guard let transaction1 = Transaction(txType: txType, inputs: inputs, outputs: outputs) else {return}
        let data = transaction1.data
        guard let transaction2 = Transaction(data: data) else {return}
        print("transaction empty passed")
        XCTAssert(transaction1 == transaction2)
    }

    func testNonEmptyTransaction() {
        let txType = Transaction.TransactionType.split

        let blockNumber: BigUInt = 10
        let txNumberInBlock: BigUInt = 1
        let outputNumberInTx: BigUInt = 1
        let amount: BigUInt = 500000000000000
        guard let input = TransactionInput(blockNumber: blockNumber, txNumberInBlock: txNumberInBlock, outputNumberInTx: outputNumberInTx, amount: amount) else {return}

        let receiverEthereumAddress: EthereumAddress = EthereumAddress("0x6891dc3962e710f0ff711b9c6acc26133fd35cb4")!
        guard let output = TransactionOutput(outputNumberInTx: outputNumberInTx, receiverEthereumAddress: receiverEthereumAddress, amount: amount) else {return}

        let inputs = [input]
        let outputs = [output]

        guard let transaction1 = Transaction(txType: txType, inputs: inputs, outputs: outputs) else {return}
        let data = transaction1.data
        guard let transaction2 = Transaction(data: data) else {return}
        print("transaction passed")
        XCTAssert(transaction1 == transaction2)
    }

    func testParseTransaction() {
        let data = Data(hex: "0xf8dcf89702f85aec8400000058840000000000a00000000000000000000000000000000000000000000000000023b46bf7fe2000ec840000005d840000000000a00000000000000000000000000000000000000000000000000000befe6f672000f838f70094832a630b949575b87c0e3c00f624f773d9b160f4a00000000000000000000000000000000000000000000000000024736a676540001ca037b2fdabbbe29d3a5f24ba99e22ae3136065ba0b4fb74e476639b4dbaaed321ba060eb7b276bad0c651e427b278250921e73b2f47c072151159c72c852c2481516")
        guard let signedTX = SignedTransaction(data: data) else {return}
        for output in signedTX.transaction.outputs {
            print("output:")
            print(output.amount)
            print(output.outputNumberInTx)
            print(output.receiverEthereumAddress)
        }
        for input in signedTX.transaction.inputs {
            print("input:")
            print(input.amount)
            print(input.outputNumberInTx)
            print(input.blockNumber)
            print(input.txNumberInBlock)
        }
        print(signedTX.transaction.txType)
        print("parse passed")
        XCTAssert(signedTX.data == data)
    }

    func testMergeOutputsForFixedAmount() {
        guard let inputs = formInputsForTransaction() else {return}
        guard let outputs = formOutputsForTransaction() else {return}
        guard let tx = Transaction(txType: .split, inputs: inputs, outputs: outputs) else {return}
        guard let newTx = tx.mergeOutputs(untilMaxAmount: 6) else {return}
        print("merge amount passed")
        XCTAssert(newTx.outputs.last?.amount == 5)
    }

    func testMergeOutputsForFixedNumber() {
        guard let inputs = formInputsForTransaction() else {return}
        guard let outputs = formOutputsForTransaction() else {return}
        guard let tx = Transaction(txType: .split, inputs: inputs, outputs: outputs) else {return}
        guard let newTx = tx.mergeOutputs(forMaxNumber: 2) else {return}
        print("merge output passed")
        XCTAssert(newTx.outputs.count == 2)
    }
}
