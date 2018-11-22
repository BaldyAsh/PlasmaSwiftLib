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

public struct TransactionInput {
    public var blockNumber: BigUInt
    public var txNumberInBlock: BigUInt
    public var outputNumberInTx: BigUInt
    public var amount: BigUInt
    public var data: Data {
        do {
            return try self.serialize()
        } catch {
            return Data()
        }
    }

    public init(blockNumber: BigUInt, txNumberInBlock: BigUInt, outputNumberInTx: BigUInt, amount: BigUInt) throws {

        guard blockNumber.bitWidth <= blockNumberMaxWidth else {throw StructureErrors.wrongBitWidth}
        guard txNumberInBlock.bitWidth <= txNumberInBlockMaxWidth else {throw StructureErrors.wrongBitWidth}
        guard outputNumberInTx.bitWidth <= outputNumberInTxMaxWidth else {throw StructureErrors.wrongBitWidth}
        guard amount.bitWidth <= amountMaxWidth else {throw StructureErrors.wrongBitWidth}

        self.blockNumber = blockNumber
        self.txNumberInBlock = txNumberInBlock
        self.outputNumberInTx = outputNumberInTx
        self.amount = amount
    }

    public init(data: Data) throws {

        guard let dataDecoded = RLP.decode(data) else {throw StructureErrors.cantDecodeData}
        guard dataDecoded.isList else {throw StructureErrors.isNotList}
        guard let count = dataDecoded.count else {throw StructureErrors.wrongDataCount}
        let dataArray: RLP.RLPItem
        guard let firstItem = dataDecoded[0] else {throw StructureErrors.dataIsNotArray}
        if count > 1 {
            dataArray = dataDecoded
        } else {
            dataArray = firstItem
        }
        guard dataArray.count == 4 else {throw StructureErrors.wrongDataCount}
        guard let blockNumberData = dataArray[0]?.data else {throw StructureErrors.isNotData}
        guard let txNumberInBlockData = dataArray[1]?.data else {throw StructureErrors.isNotData}
        guard let outputNumberInTxData = dataArray[2]?.data else {throw StructureErrors.isNotData}
        guard let amountData = dataArray[3]?.data else {throw StructureErrors.isNotData}

        let blockNumber = BigUInt(blockNumberData)
        let txNumberInBlock = BigUInt(txNumberInBlockData)
        let outputNumberInTx = BigUInt(outputNumberInTxData)
        let amount = BigUInt(amountData)

        guard blockNumber.bitWidth <= blockNumberMaxWidth else {throw StructureErrors.wrongBitWidth}
        guard txNumberInBlock.bitWidth <= txNumberInBlockMaxWidth else {throw StructureErrors.wrongBitWidth}
        guard outputNumberInTx.bitWidth <= outputNumberInTxMaxWidth else {throw StructureErrors.wrongBitWidth}
        guard amount.bitWidth <= amountMaxWidth else {throw StructureErrors.wrongBitWidth}

        self.blockNumber = blockNumber
        self.txNumberInBlock = txNumberInBlock
        self.outputNumberInTx = outputNumberInTx
        self.amount = amount
    }

    public func serialize() throws -> Data {
        let dataArray = self.prepareForRLP()
        guard let encoded = RLP.encode(dataArray) else {throw StructureErrors.cantEncodeData}
        return encoded
    }

    public func prepareForRLP() -> [AnyObject] {
        let blockNumberData = self.blockNumber.serialize().setLengthLeft(blockNumberByteLength)!
        let txNumberData = self.txNumberInBlock.serialize().setLengthLeft(txNumberInBlockByteLength)!
        let outputNumberData = self.outputNumberInTx.serialize().setLengthLeft(outputNumberInTxByteLength)
        let amountData = self.amount.serialize().setLengthLeft(amountByteLength)
        let dataArray = [blockNumberData, txNumberData, outputNumberData, amountData] as [AnyObject]
        return dataArray
    }
}

extension TransactionInput: Equatable {
    public static func ==(lhs: TransactionInput, rhs: TransactionInput) -> Bool {
        return lhs.blockNumber == rhs.blockNumber &&
            lhs.txNumberInBlock == rhs.txNumberInBlock &&
            lhs.outputNumberInTx == rhs.outputNumberInTx &&
            lhs.amount == rhs.amount &&
            lhs.data == rhs.data
    }
}
