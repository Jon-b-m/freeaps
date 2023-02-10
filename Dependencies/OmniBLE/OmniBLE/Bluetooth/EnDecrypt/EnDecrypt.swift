//
//  EnDecrypt.swift
//  OmniBLE
//
//  Created by Randall Knutson on 11/4/21.
//  Copyright © 2021 LoopKit Authors. All rights reserved.
//

import Foundation
import CryptoSwift
import os.log

class EnDecrypt {
    private let MAC_SIZE = 8
    private let log = OSLog(category: "EnDecrypt")
    private let nonce: Nonce
    private let ck: Data

    init(nonce: Nonce, ck: Data) {
        self.nonce = nonce
        self.ck = ck
    }

    func decrypt(_ msg: MessagePacket, _ nonceSeq: Int) throws -> MessagePacket {
        let payload = msg.payload
        let header = msg.asData(forEncryption: false).subdata(in: 0..<16)

        let n = nonce.toData(sqn: nonceSeq, podReceiving: false)
#if LOG_DEBUG
        log.debug("Decrypt ck %@", ck.hexadecimalString)
        log.debug("Decrypt header %@", header.hexadecimalString)
        log.debug("Decrypt payload: %@", payload.hexadecimalString)
        log.debug("Decrypt Nonce %@", n.hexadecimalString)
        log.debug("Decrypt Tag: %@", Data(payload).subdata(in: (payload.count - MAC_SIZE)..<payload.count).hexadecimalString)
#endif
        let ccm = CCM(iv: n.bytes, tagLength: MAC_SIZE, messageLength: payload.count - MAC_SIZE, additionalAuthenticatedData: header.bytes)
        let aes = try AES(key: ck.bytes, blockMode: ccm, padding: .noPadding)
        let decryptedPayload = try aes.decrypt(payload.bytes)
#if LOG_DEBUG
        log.debug("Decrypted payload %@", Data(decryptedPayload).hexadecimalString)
#endif
        
        var msgCopy = msg
        msgCopy.payload = Data(decryptedPayload)
        return msgCopy
    }

    func encrypt(_ headerMessage: MessagePacket, _ nonceSeq: Int) throws -> MessagePacket {
        let payload = headerMessage.payload
        let header = headerMessage.asData(forEncryption: true).subdata(in: 0..<16)

        let n = nonce.toData(sqn: nonceSeq, podReceiving: true)
#if LOG_DEBUG
        log.debug("Encrypt Ck %@", ck.hexadecimalString)
        log.debug("Encrypt Header %@", header.hexadecimalString)
        log.debug("Encrypt Payload: %@", payload.hexadecimalString)
        log.debug("Encrypt Nonce %@", n.hexadecimalString)
#endif
        let ccm = CCM(iv: n.bytes, tagLength: MAC_SIZE, messageLength: payload.count, additionalAuthenticatedData: header.bytes)
        let aes = try AES(key: ck.bytes, blockMode: ccm, padding: .noPadding)
        let encryptedPayload = try aes.encrypt(payload.bytes)
#if LOG_DEBUG
        log.debug("Encrypted payload: %@", Data(encryptedPayload).subdata(in: 0..<(encryptedPayload.count - MAC_SIZE)).hexadecimalString)
        log.debug("Encrypt Tag: %@", Data(encryptedPayload).subdata(in: (encryptedPayload.count - MAC_SIZE)..<encryptedPayload.count).hexadecimalString)
#endif

        var msgCopy = headerMessage
        msgCopy.payload = Data(encryptedPayload)
        return msgCopy
    }
}
