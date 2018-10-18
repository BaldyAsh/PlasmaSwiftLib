//
//  Input.swift
//  PlasmaSwiftLib
//
//  Created by Anton Grigorev on 18.10.2018.
//  Copyright © 2018 The Matter. All rights reserved.
//

import Foundation
import SwiftRLP
import BigInt

class TransactionInput {
    
    public var blockNumber: BigUInt
    public var txNumberInBlock: BigUInt
    public var outputNumberInTx: BigUInt
    public var amount: BigUInt
    public var data: Data
    
    public init?(blockNumber: BigUInt, txNumberInBlock: BigUInt, outputNumberInTx: BigUInt, amount: BigUInt) {
        guard blockNumber.bitWidth <= Constants.blockNumberMaxWidth else {return nil}
        guard txNumberInBlock.bitWidth <= Constants.txNumberInBlockMaxWidth else {return nil}
        guard outputNumberInTx.bitWidth <= Constants.outputNumberInTxMaxWidth else {return nil}
        guard amount.bitWidth <= Constants.amountMaxWidth else {return nil}
        
        self.blockNumber = blockNumber
        self.txNumberInBlock = txNumberInBlock
        self.outputNumberInTx = outputNumberInTx
        self.amount = amount
        
        let dataArray = [blockNumber, txNumberInBlock, outputNumberInTx, amount] as [AnyObject]
        guard let data = RLP.encode(dataArray) else {return nil}
        self.data = data
    }
}
