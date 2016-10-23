/*
 * ==---------------------------------------------------------------------------------==
 *
 *  File            :   HashTests.swift
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

import XCTest
import Foundation
@testable import Hash

class HashTests: XCTestCase {
    
    func testMD4() {
        performTest(with: md4Fixtures, mode: .text)
    }
    
    func testMD5() {
        performTest(with: md5Fixtures, mode: .text)
    }
    
    func testSHA1() {
        performTest(with: sha1Fixtures)
    }

    func testSHA224() {
        performTest(with: sha224Fixtures)
    }
    
    func testSHA256() {
        performTest(with: sha256Fixtures)
    }
    
    func testSHA384() {
        performTest(with: sha384Fixtures)
    }
    
    func testSHA512() {
        performTest(with: sha512Fixtures)
    }
    
    func testRipeMd160() {
        performTest(with: ripeMd160Fixtures)
    }
    
    func testNull() {
        performTest(with: nullFixtures)
    }
    
    // MARK: - Utilities
    
    enum Mode {
        case text
        case bytes
        func message(from string: String) -> [UInt8] {
            switch self {
            case .text: return string.bytes
            case .bytes: return Data(hexString: string)!.bytes
            }
        }
    }
    
    func performTest(with fixtures: Array<HashFixture>, mode: Mode = .bytes) {
        
        for fixture in fixtures {
            
            let message = mode.message(from: fixture.message)
            
            do {
                
                let hash = try Hash.hash(message, using: fixture.alg)
                XCTAssertEqual(hash.hexString.lowercased(), fixture.expectedHash.lowercased())
                
            } catch {
                
                XCTFail("Could not hash message")
                
            }
            
        }
        
    }
    
    static var allTests : [(String, (HashTests) -> () throws -> Void)] {
        return [
            ("testMD4", testMD4),
            ("testMD5", testMD5),
            ("testSHA1", testSHA1),
            ("testSHA224", testSHA224),
            ("testSHA256", testSHA256),
            ("testSHA384", testSHA384),
            ("testSHA512", testSHA512),
            ("testRipeMd160", testRipeMd160),
            ("testNull", testNull)
        ]
    }

}
