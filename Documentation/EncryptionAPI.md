# Encryption API

<!-- TOC START -->
## Table of Contents
- [Encryption API](#encryption-api)
- [Overview](#overview)
- [Core Components](#core-components)
  - [DataEncryptionManager](#dataencryptionmanager)
  - [KeyManagementManager](#keymanagementmanager)
  - [FileEncryptionManager](#fileencryptionmanager)
- [API Reference](#api-reference)
  - [Data Encryption](#data-encryption)
  - [Key Management](#key-management)
  - [File Encryption](#file-encryption)
  - [Database Encryption](#database-encryption)
  - [Memory Encryption](#memory-encryption)
- [Supported Algorithms](#supported-algorithms)
  - [Symmetric Encryption](#symmetric-encryption)
  - [Asymmetric Encryption](#asymmetric-encryption)
  - [Hashing Algorithms](#hashing-algorithms)
- [Error Handling](#error-handling)
- [Best Practices](#best-practices)
- [Security Considerations](#security-considerations)
- [Examples](#examples)
- [Related Documentation](#related-documentation)
<!-- TOC END -->


## Overview

The Encryption API provides enterprise-grade encryption capabilities for iOS applications. It supports multiple encryption algorithms, key management, and secure data handling with comprehensive security features.

## Core Components

### DataEncryptionManager

Manages data encryption and decryption operations with various algorithms.

```swift
import EnterpriseSecurityFramework

// Initialize data encryption manager
let dataEncryption = DataEncryptionManager()

// Configure encryption settings
let encryptionConfig = EncryptionConfiguration()
encryptionConfig.algorithm = .aes256
encryptionConfig.mode = .gcm
encryptionConfig.keySize = 256
encryptionConfig.enableKeyRotation = true

// Encrypt sensitive data
let encryptedData = await dataEncryption.encrypt(data: sensitiveData, configuration: encryptionConfig)
```

### KeyManagementManager

Handles secure key generation, storage, and rotation.

```swift
// Initialize key management
let keyManager = KeyManagementManager()

// Generate encryption key
let key = await keyManager.generateKey(
    algorithm: .aes256,
    keySize: 256
)

// Store key securely
await keyManager.storeKey(key, in: .keychain)

// Rotate encryption keys
let rotation = await keyManager.rotateKeys(algorithm: .aes256)
```

### FileEncryptionManager

Manages file encryption and secure file operations.

```swift
// Initialize file encryption
let fileEncryption = FileEncryptionManager()

// Encrypt file
await fileEncryption.encryptFile(
    sourcePath: "/path/to/file.txt",
    destinationPath: "/path/to/encrypted/file.enc",
    algorithm: .aes256
)

// Decrypt file
await fileEncryption.decryptFile(
    sourcePath: "/path/to/encrypted/file.enc",
    destinationPath: "/path/to/decrypted/file.txt"
)
```

## API Reference

### Data Encryption

```swift
// Basic encryption
let encryptedData = await dataEncryption.encrypt(
    data: "Sensitive information",
    algorithm: .aes256
)

// Encryption with custom configuration
let config = EncryptionConfiguration()
config.algorithm = .aes256
config.mode = .gcm
config.keySize = 256
config.enableKeyRotation = true

let encryptedData = await dataEncryption.encrypt(
    data: sensitiveData,
    configuration: config
)

// Decrypt data
let decryptedData = await dataEncryption.decrypt(
    encryptedData: encryptedData,
    key: encryptionKey
)

// Encrypt large data
let encryptedChunks = await dataEncryption.encryptLargeData(
    data: largeData,
    chunkSize: 1024 * 1024, // 1MB chunks
    algorithm: .aes256
)
```

### Key Management

```swift
// Generate encryption key
let key = await keyManager.generateKey(
    algorithm: .aes256,
    keySize: 256
)
print("Key ID: \(key.keyId)")
print("Algorithm: \(key.algorithm)")
print("Key size: \(key.keySize)")

// Store key securely
await keyManager.storeKey(key, in: .keychain)

// Retrieve key
let retrievedKey = await keyManager.retrieveKey(keyId: key.keyId)

// Rotate keys
let rotation = await keyManager.rotateKeys(algorithm: .aes256)
print("Old key ID: \(rotation.oldKeyId)")
print("New key ID: \(rotation.newKeyId)")
print("Rotation time: \(rotation.rotationTime)")

// Delete key
await keyManager.deleteKey(keyId: key.keyId)

// List all keys
let keys = await keyManager.listKeys(algorithm: .aes256)
```

### File Encryption

```swift
// Encrypt file
await fileEncryption.encryptFile(
    sourcePath: "/path/to/file.txt",
    destinationPath: "/path/to/encrypted/file.enc",
    algorithm: .aes256
)

// Decrypt file
await fileEncryption.decryptFile(
    sourcePath: "/path/to/encrypted/file.enc",
    destinationPath: "/path/to/decrypted/file.txt"
)

// Encrypt directory
await fileEncryption.encryptDirectory(
    sourcePath: "/path/to/directory",
    destinationPath: "/path/to/encrypted/directory",
    algorithm: .aes256
)

// Verify file integrity
let integrity = await fileEncryption.verifyFileIntegrity(
    filePath: "/path/to/file.txt"
)
```

### Database Encryption

```swift
// Initialize database encryption
let dbEncryption = DatabaseEncryptionManager()

// Encrypt database
await dbEncryption.encryptDatabase(
    databasePath: "/path/to/database.sqlite",
    algorithm: .aes256
)

// Encrypt specific columns
await dbEncryption.encryptColumn(
    tableName: "users",
    columnName: "ssn",
    algorithm: .aes256
)

// Encrypt query results
let encryptedResults = await dbEncryption.encryptQueryResults(
    query: "SELECT * FROM users WHERE id = ?",
    parameters: [userId],
    algorithm: .aes256
)
```

### Memory Encryption

```swift
// Initialize memory encryption
let memoryEncryption = MemoryEncryptionManager()

// Encrypt sensitive data in memory
let encryptedMemory = await memoryEncryption.encryptInMemory(
    data: sensitiveData,
    algorithm: .aes256
)

// Secure memory allocation
let secureMemory = await memoryEncryption.allocateSecureMemory(
    size: 1024,
    algorithm: .aes256
)

// Clear secure memory
await memoryEncryption.clearSecureMemory(secureMemory)
```

## Supported Algorithms

### Symmetric Encryption
- **AES-128**: 128-bit Advanced Encryption Standard
- **AES-256**: 256-bit Advanced Encryption Standard
- **ChaCha20**: High-performance stream cipher
- **Twofish**: Alternative block cipher

### Asymmetric Encryption
- **RSA-2048**: 2048-bit RSA encryption
- **RSA-4096**: 4096-bit RSA encryption
- **ECC-256**: 256-bit Elliptic Curve Cryptography
- **ECC-384**: 384-bit Elliptic Curve Cryptography

### Hashing Algorithms
- **SHA-256**: 256-bit Secure Hash Algorithm
- **SHA-512**: 512-bit Secure Hash Algorithm
- **HMAC-SHA256**: Hash-based Message Authentication Code
- **PBKDF2**: Password-Based Key Derivation Function

## Error Handling

```swift
do {
    let encryptedData = try await dataEncryption.encrypt(data: sensitiveData)
} catch EncryptionError.invalidKey {
    // Handle invalid key error
} catch EncryptionError.algorithmNotSupported {
    // Handle unsupported algorithm
} catch EncryptionError.insufficientMemory {
    // Handle memory issues
} catch EncryptionError.fileNotFound {
    // Handle file not found
} catch {
    // Handle other encryption errors
}
```

## Best Practices

1. **Use strong encryption algorithms (AES-256)**
2. **Implement proper key management**
3. **Rotate encryption keys regularly**
4. **Store keys securely in Keychain**
5. **Use secure random generation**
6. **Implement proper error handling**
7. **Log encryption operations for audit**
8. **Use appropriate key sizes**

## Security Considerations

- Never store encryption keys in plain text
- Use secure random number generation
- Implement proper key rotation
- Validate all input data
- Use secure communication channels
- Implement proper access controls
- Monitor encryption operations
- Handle sensitive data carefully

## Examples

See the [Encryption Examples](../Examples/EncryptionExamples/) directory for complete implementation examples.

## Related Documentation

- [Security Manager API](SecurityManagerAPI.md)
- [Authentication API](AuthenticationAPI.md)
- [Key Management API](KeyManagementAPI.md)
- [Encryption Guide](EncryptionGuide.md)
- [Getting Started Guide](GettingStarted.md)
