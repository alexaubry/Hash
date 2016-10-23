/*
 * ==---------------------------------------------------------------------------------==
 *
 *  File            :   Hash.swift
 *  Project         :   Hash
 *  Author          :   ALEXIS AUBRY RADANOVIC
 *
 *  License         :   The MIT License (MIT)
 *
 * ==---------------------------------------------------------------------------------==
 *
 *	The MIT License (MIT)
 *	Copyright (c) 2016 ALEXIS AUBRY RADANOVIC
 *
 *	Permission is hereby granted, free of charge, to any person obtaining a copy of
 *	this software and associated documentation files (the "Software"), to deal in
 *	the Software without restriction, including without limitation the rights to
 *	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 *	the Software, and to permit persons to whom the Software is furnished to do so,
 *	subject to the following conditions:
 *
 *	The above copyright notice and this permission notice shall be included in all
 *	copies or substantial portions of the Software.
 *
 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 *	FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 *	COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 *	IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 *	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ==---------------------------------------------------------------------------------==
 */

import Foundation
import CLibreSSL
import CryptoLoader
@_exported import BytesKit
@_exported import CryptoError

///
/// An enumeration of the supported hashing algorithms.
///

public enum HashingAlgorithm {
    
    ///
    /// The MD4 hashing algorithms.
    ///
    
    case md4
    
    ///
    /// The MD5 hashing algorithms.
    ///
    
    case md5
    
    ///
    /// The SHA-1 hashing algorithms.
    ///
    
    case sha1
    
    ///
    /// The SHA-224 hashing algorithms.
    ///
    
    case sha224
    
    ///
    /// The SHA-256 hashing algorithms.
    ///
    
    case sha256
    
    ///
    /// The SHA-384 hashing algorithms.
    ///
    
    case sha384
    
    ///
    /// The SHA-512 hashing algorithms.
    ///
    
    case sha512
    
    ///
    /// The RIPEMD-160 hashing algorithms.
    ///
    
    case ripeMd160
    
    ///
    /// A hashing algorithm that always returns an empty hash.
    ///
    
    case null
    
    ///
    /// The raw message digest pointer that can be used with OpenSSL APIs.
    ///
    
    public var messageDigest: UnsafePointer<EVP_MD>? {
        
        switch self {
            
        case .md4: return EVP_md4()
        case .md5: return EVP_md5()
        case .sha1: return EVP_sha1()
        case .sha224: return EVP_sha224()
        case .sha256: return EVP_sha256()
        case .sha384: return EVP_sha384()
        case .sha512: return EVP_sha512()
        case .ripeMd160: return EVP_ripemd160()
        case .null: return EVP_md_null()
            
        }
        
    }
    
}

///
/// Compute the hash of bytes.
///
/// - parameter bytes: The bytes to hash.
/// - parameter hashingAlgorithm: The algorithm to use to create the hash.
///
/// - throws: This method may throw a `CryptoError` object in case of a failure.
///
/// - returns: A `Data` object that contains the bytes of the hash.
///

public func hash(_ bytes: Array<UInt8>, using hashingAlgorithm: HashingAlgorithm) throws -> Data {
    
    CryptoLoader.load(.digests, .cryptoErrorStrings)
    
    /* Pointers */
    
    guard let messageDigest = hashingAlgorithm.messageDigest else {
        throw CryptoError.latest()
    }
    
    guard let context = EVP_MD_CTX_create() else {
        throw CryptoError.latest()
    }
    
    defer {
        EVP_MD_CTX_destroy(context)
    }
    
    /* Properties */
    
    var digestLength = UInt32(EVP_MD_size(messageDigest))
    var digest = Array<UInt8>(repeating: 0, count: Int(digestLength))
    
    /* Hashing */
    
    guard EVP_DigestInit(context, messageDigest) == 1 else {
        throw CryptoError.latest()
    }
    
    guard EVP_DigestUpdate(context, UnsafeRawPointer(bytes), bytes.count) == 1 else {
        throw CryptoError.latest()
    }
    
    guard EVP_DigestFinal(context, &digest, &digestLength) == 1 else {
        throw CryptoError.latest()
    }
    
    /* Final */
    
    return Data(bytes: digest.prefix(upTo: Int(digestLength)))
    
}

// MARK: - Convenience

public extension BytesConvertible {
    
    ///
    /// Compute the hash of the object based on its bytes.
    ///
    /// - parameter hashingAlgorithm: The algorithm to use to create the hash.
    ///
    /// - throws: This method may throw a `CryptoError` object in case of a failure.
    ///
    /// - returns: A `Data` object that contains the bytes of the hash.
    ///
    
    public func hash(using hashingAlgorithm: HashingAlgorithm) throws -> Data {
        return try Hash.hash(self.bytes, using: hashingAlgorithm)
    }
    
}
