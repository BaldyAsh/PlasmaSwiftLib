//
//  BlockHeader.swift
//  PlasmaSwiftLib
//
//  Created by Anton Grigorev on 18.10.2018.
//  Copyright © 2018 The Matter. All rights reserved.
//

import Foundation
import SwiftRLP
import BigInt

public struct BlockHeader {
    public var blockNumber: BigUInt
    public var numberOfTxInBlock: BigUInt
    public var parentHash: Data
    public var merkleRootOfTheTxTree: Data
    public var v: BigUInt
    public var r: Data
    public var s: Data
    public var data: Data {
        do {
            return try self.serialize()
        } catch {
            return Data()
        }
    }

    public init(blockNumber: BigUInt, numberOfTxInBlock: BigUInt, parentHash: Data, merkleRootOfTheTxTree: Data, v: BigUInt, r: Data, s: Data) throws {
        guard blockNumber.bitWidth <= blockNumberMaxWidth else {throw StructureErrors.wrongBitWidth}
        guard numberOfTxInBlock.bitWidth <= numberOfTxInBlockMaxWidth else {throw StructureErrors.wrongBitWidth}
        guard parentHash.count <= parentHashByteLength else {throw StructureErrors.wrongBitWidth}
        guard merkleRootOfTheTxTree.count <= merkleRootOfTheTxTreeByteLength else {throw StructureErrors.wrongBitWidth}
        guard v.bitWidth <= vMaxWidth else {throw StructureErrors.wrongBitWidth}
        guard r.count <= rByteLength else {throw StructureErrors.wrongBitWidth}
        guard s.count <= sByteLength else {throw StructureErrors.wrongBitWidth}

        guard v == 27 || v == 28 else {throw StructureErrors.wrongData}

        self.blockNumber = blockNumber
        self.numberOfTxInBlock = numberOfTxInBlock
        self.parentHash = parentHash
        self.merkleRootOfTheTxTree = merkleRootOfTheTxTree
        self.v = v
        self.r = r
        self.s = s
    }
    
    public init(data: Data) throws {
        var max = 0
        var min = 0
        var elements = [String]()
        let dataString = data.toHexString()
        let dataStringArray = dataString.split(intoChunksOf: 2)
        
        guard dataStringArray.count == Int(blockHeaderByteLength) else {throw StructureErrors.wrongDataCount}
        
        for i in 0..<7 {
            var bytes = 0
            switch i {
            case 0:
                bytes = Int(blockNumberByteLength)
            case 1:
                bytes = Int(blockNumberByteLength)
            case 2:
                bytes = Int(parentHashByteLength)
            case 3:
                bytes = Int(merkleRootOfTheTxTreeByteLength)
            case 4:
                bytes = Int(vByteLength)
            case 5:
                bytes = Int(rByteLength)
            default:
                bytes = Int(sByteLength)
            }
            min = max
            max += bytes
            let elementSlice = dataStringArray[min..<max]
            let elementArray: [String] = Array(elementSlice)
            let element = elementArray.joined()
            elements.append(element)
        }
        
        guard let blockNumberDec = UInt8(elements[0], radix: 16) else {throw StructureErrors.wrongData}
        let blockNumber = BigUInt(blockNumberDec)
        guard let numberOfTxInBlockDec = UInt8(elements[1], radix: 16) else {throw StructureErrors.wrongData}
        let numberOfTxInBlock = BigUInt(numberOfTxInBlockDec)
        let parentHash = Data(hex: elements[2])
        let merkleRootOfTheTxTree = Data(hex: elements[3])
        guard let vDec = UInt8(elements[4], radix: 16) else {throw StructureErrors.wrongData}
        let v = BigUInt(vDec)
        let r = Data(hex: elements[5])
        let s = Data(hex: elements[6])

        guard blockNumber.bitWidth <= blockNumberMaxWidth else {throw StructureErrors.wrongBitWidth}
        guard numberOfTxInBlock.bitWidth <= numberOfTxInBlockMaxWidth else {throw StructureErrors.wrongBitWidth}
        guard parentHash.count <= parentHashByteLength else {throw StructureErrors.wrongBitWidth}
        guard merkleRootOfTheTxTree.count <= merkleRootOfTheTxTreeByteLength else {throw StructureErrors.wrongBitWidth}
        guard v.bitWidth <= vMaxWidth else {throw StructureErrors.wrongBitWidth}
        guard r.count <= rByteLength else {throw StructureErrors.wrongBitWidth}
        guard s.count <= sByteLength else {throw StructureErrors.wrongBitWidth}

        self.blockNumber = blockNumber
        self.numberOfTxInBlock = numberOfTxInBlock
        self.parentHash = parentHash
        self.merkleRootOfTheTxTree = merkleRootOfTheTxTree
        self.v = v
        self.r = r
        self.s = s
    }

    public func serialize() throws -> Data {
        var d = Data()
        guard let blockNumberData = self.blockNumber.serialize().setLengthLeft(blockNumberByteLength) else {throw StructureErrors.cantEncodeData}
        guard let txNumberData = self.numberOfTxInBlock.serialize().setLengthLeft(txNumberInBlockByteLength) else {throw StructureErrors.cantEncodeData}

        d.append(blockNumberData)
        d.append(txNumberData)
        d.append(self.parentHash)
        d.append(self.merkleRootOfTheTxTree)

        let vData = self.v.serialize().setLengthLeft(vByteLength)!
        d.append(vData)
        d.append(self.r)
        d.append(self.s)

        precondition(d.count == blockHeaderByteLength)
        return d
    }
}

extension BlockHeader: Equatable {
    public static func ==(lhs: BlockHeader, rhs: BlockHeader) -> Bool {
        return lhs.blockNumber == rhs.blockNumber &&
            lhs.numberOfTxInBlock == rhs.numberOfTxInBlock &&
            lhs.parentHash == rhs.parentHash &&
            lhs.merkleRootOfTheTxTree == rhs.merkleRootOfTheTxTree &&
            lhs.v == rhs.v &&
            lhs.r == rhs.r &&
            lhs.s == rhs.s
    }
}
