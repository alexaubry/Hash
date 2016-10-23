# `import Hash`

![Swift 3.0](https://img.shields.io/badge/Swift-3.0-ee4f37.svg)
![Licence](https://img.shields.io/badge/Licence-MIT-000000.svg)
[![Build Status](https://travis-ci.org/alexaubry/Hash.svg?branch=master)](https://travis-ci.org/alexaubry/Hash)

`Hash` is a protocol-oriented Swift library to generates message digests/hashes.

## Supported Hashes

- [x] MD4, MD5
- [x] SHA-1
- [x] SHA-224, SHA-256
- [x] SHA-384, SHA-512
- [x] RIPEMD-160
- [x] NULL

## Installation

This library is only available via the Swift Package Manager. To include it in your package, add this line to your Package.swift :

~~~swift
.Package(url: "https://github.com/alexaubry/Hash", majorVersion: 1)
~~~

## Usage

### Hashing Bytes

To hash an array of bytes—`Array<UInt8>`— call `Hash.hash(bytes:,using:)` with the bytes to hash and the algorithm to use. Objects returned are `Data` structures containing the bytes of the hash.

#### Example with SHA-256 :

~~~swift
// Note: error handling has been omitted for brevity

let bytes: Array<UInt8> = [0x16, 0x32, 0x64]
let hash = try Hash.hash(bytes, using: .sha256)
~~~

### Hashing `BytesConvertible` objects

All objects that conform to the `BytesConvertible` protocol defined in [BytesKit](https://github.com/alexaubry/BytesKit) can be hashed with the `hash(using:)` convenience method, with the algorithm to use.

This means you can create hashes from `String` and `Data` object, as well as from your custom types.

#### Examples :

~~~swift
let string = "Hash me!"
let sha256 = try string.hash(using: .sha256)

let data = Data(bytes: [0x1a, 0x2b, 0x3c, 0x4d])
let sha512 = try data.hash(using: .sha512)
~~~


### Error Handling

Errors thrown by the `hash(using:)` method are `CryptoError` objects.

~~~swift

do {
    let hash = try "string".hash(using: .md5)
} catch let error as CryptoError {
    print(error.code)
} catch {
    dump(error)
}
~~~

See [CryptoError](https://github.com/alexaubry/CryptoError) for more informations.

## Disclaimer

This library's security has not been audited. Use at your own risk.

## Acknowledgements

This library relies on [CLibreSSL](https://github.com/vapor/ClibreSSL).

It is also built with some of my projects that you can check out :

- [BytesKit](https://github.com/alexaubry/BytesKit)
- [CryptoLoader](https://github.com/alexaubry/CryptoLoader)
- [CryptoError](https://github.com/alexaubry/CryptoError)
