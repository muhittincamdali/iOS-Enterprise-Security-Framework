# Encryption Guide

<!-- TOC START -->
## Table of Contents
- [Encryption Guide](#encryption-guide)
- [Overview](#overview)
- [Table of Contents](#table-of-contents)
- [Encryption Overview](#encryption-overview)
- [Symmetric Encryption](#symmetric-encryption)
  - [AES-256-GCM Encryption](#aes-256-gcm-encryption)
  - [Encrypt Data with AES](#encrypt-data-with-aes)
  - [Decrypt Data with AES](#decrypt-data-with-aes)
  - [ChaCha20-Poly1305 Encryption](#chacha20-poly1305-encryption)
- [Asymmetric Encryption](#asymmetric-encryption)
  - [RSA-4096 Encryption](#rsa-4096-encryption)
  - [Generate RSA Key Pair](#generate-rsa-key-pair)
  - [Encrypt with RSA](#encrypt-with-rsa)
  - [ECC Encryption](#ecc-encryption)
- [Key Management](#key-management)
  - [Key Generation](#key-generation)
  - [Key Storage](#key-storage)
  - [Key Rotation](#key-rotation)
  - [Key Retrieval](#key-retrieval)
- [Data Encryption](#data-encryption)
  - [In-Memory Encryption](#in-memory-encryption)
  - [Secure Data Storage](#secure-data-storage)
- [File Encryption](#file-encryption)
  - [File Encryption Setup](#file-encryption-setup)
  - [Encrypt Files](#encrypt-files)
  - [Decrypt Files](#decrypt-files)
  - [Directory Encryption](#directory-encryption)
- [Database Encryption](#database-encryption)
  - [SQLite Encryption](#sqlite-encryption)
  - [Encrypt Database](#encrypt-database)
  - [Encrypt Specific Columns](#encrypt-specific-columns)
- [Best Practices](#best-practices)
  - [Security Recommendations](#security-recommendations)
  - [Performance Considerations](#performance-considerations)
  - [Compliance Requirements](#compliance-requirements)
- [Troubleshooting](#troubleshooting)
  - [Common Issues](#common-issues)
  - [Debug Information](#debug-information)
- [API Reference](#api-reference)
- [Examples](#examples)
<!-- TOC END -->


## Overview

The Encryption Guide provides comprehensive information about implementing enterprise-grade encryption features in iOS applications using the iOS Enterprise Security Framework.

## Table of Contents

- [Encryption Overview](#encryption-overview)
- [Symmetric Encryption](#symmetric-encryption)
- [Asymmetric Encryption](#asymmetric-encryption)
- [Key Management](#key-management)
- [Data Encryption](#data-encryption)
- [File Encryption](#file-encryption)
- [Database Encryption](#database-encryption)
- [Best Practices](#best-practices)

## Encryption Overview

Encryption is a fundamental component of enterprise security. The iOS Enterprise Security Framework provides comprehensive encryption capabilities including:

- **Symmetric Encryption**: AES-256, ChaCha20-Poly1305
- **Asymmetric Encryption**: RSA-4096, ECC
- **Key Management**: Secure key generation and storage
- **Data Encryption**: Encrypt sensitive data in memory and storage
- **File Encryption**: Encrypt files and directories
- **Database Encryption**: Encrypt database contents

## Symmetric Encryption

Symmetric encryption uses the same key for encryption and decryption, providing fast and efficient encryption for large amounts of data.

### AES-256-GCM Encryption

```swift
import EnterpriseSecurity

// Configure AES-256-GCM encryption
let encryptionManager = EncryptionManager()

let aesConfig = AESConfiguration()
aesConfig.algorithm = .aes256
aesConfig.mode = .gcm
aesConfig.keySize = 256
aesConfig.enableAuthentication = true

try encryptionManager.configureAES(configuration: aesConfig)
```

### Encrypt Data with AES

```swift
// Encrypt sensitive data
let sensitiveData = "Confidential enterprise information"
let dataToEncrypt = sensitiveData.data(using: .utf8)!

let encryptionResult = try encryptionManager.encryptAES(
    data: dataToEncrypt,
    key: encryptionKey
)

print("✅ Data encrypted successfully")
print("Encrypted data: \(encryptionResult.encryptedData)")
print("IV: \(encryptionResult.iv)")
print("Tag: \(encryptionResult.tag)")
```

### Decrypt Data with AES

```swift
// Decrypt data
let decryptionResult = try encryptionManager.decryptAES(
    encryptedData: encryptionResult.encryptedData,
    key: encryptionKey,
    iv: encryptionResult.iv,
    tag: encryptionResult.tag
)

let decryptedString = String(data: decryptionResult, encoding: .utf8)
print("✅ Data decrypted successfully: \(decryptedString ?? "")")
```

### ChaCha20-Poly1305 Encryption

```swift
// Configure ChaCha20-Poly1305
let chachaConfig = ChaChaConfiguration()
chachaConfig.keySize = 256
chachaConfig.nonceSize = 12
chachaConfig.enableAuthentication = true

try encryptionManager.configureChaCha(configuration: chachaConfig)

// Encrypt with ChaCha20-Poly1305
let chachaResult = try encryptionManager.encryptChaCha(
    data: dataToEncrypt,
    key: chachaKey
)
```

## Asymmetric Encryption

Asymmetric encryption uses public and private key pairs, providing secure key exchange and digital signatures.

### RSA-4096 Encryption

```swift
// Configure RSA-4096
let rsaConfig = RSAConfiguration()
rsaConfig.keySize = 4096
rsaConfig.padding = .oaep
rsaConfig.hashAlgorithm = .sha256

try encryptionManager.configureRSA(configuration: rsaConfig)
```

### Generate RSA Key Pair

```swift
// Generate RSA key pair
let keyPair = try encryptionManager.generateRSAKeyPair()

print("✅ RSA key pair generated")
print("Public key: \(keyPair.publicKey)")
print("Private key: \(keyPair.privateKey)")
print("Key ID: \(keyPair.keyId)")
```

### Encrypt with RSA

```swift
// Encrypt data with RSA public key
let rsaEncrypted = try encryptionManager.encryptRSA(
    data: dataToEncrypt,
    publicKey: keyPair.publicKey
)

// Decrypt with RSA private key
let rsaDecrypted = try encryptionManager.decryptRSA(
    encryptedData: rsaEncrypted,
    privateKey: keyPair.privateKey
)
```

### ECC Encryption

```swift
// Configure ECC
let eccConfig = ECCConfiguration()
eccConfig.curve = .p256
eccConfig.keySize = 256

try encryptionManager.configureECC(configuration: eccConfig)

// Generate ECC key pair
let eccKeyPair = try encryptionManager.generateECCKeyPair()
```

## Key Management

Key management is critical for maintaining encryption security. The framework provides comprehensive key management capabilities.

### Key Generation

```swift
// Generate encryption keys
let keyManager = KeyManager()

let keyConfig = KeyGenerationConfiguration()
keyConfig.algorithm = .aes256
keyConfig.keySize = 256
keyConfig.useSecureRandom = true
keyConfig.enableHardwareAcceleration = true

let generatedKey = try keyManager.generateKey(configuration: keyConfig)
```

### Key Storage

```swift
// Store key securely in keychain
let storageConfig = KeyStorageConfiguration()
storageConfig.storageType = .keychain
storageConfig.accessibility = .whenUnlockedThisDeviceOnly
storageConfig.protectionLevel = .complete

try keyManager.storeKey(
    generatedKey,
    configuration: storageConfig
)
```

### Key Rotation

```swift
// Configure automatic key rotation
let rotationConfig = KeyRotationConfiguration()
rotationConfig.enableAutomaticRotation = true
rotationConfig.rotationInterval = 30 // days
rotationConfig.overlapPeriod = 7 // days

try keyManager.configureKeyRotation(configuration: rotationConfig)
```

### Key Retrieval

```swift
// Retrieve key from secure storage
let retrievedKey = try keyManager.retrieveKey(
    keyId: generatedKey.keyId,
    configuration: storageConfig
)
```

## Data Encryption

Data encryption protects sensitive information in memory and storage.

### In-Memory Encryption

```swift
// Encrypt data in memory
let memoryEncryption = MemoryEncryptionManager()

let memoryConfig = MemoryEncryptionConfiguration()
memoryConfig.enableMemoryProtection = true
memoryConfig.encryptionAlgorithm = .aes256
memoryConfig.autoCleanup = true

try memoryEncryption.configure(configuration: memoryConfig)

// Encrypt sensitive data in memory
let secureData = try memoryEncryption.encryptInMemory(
    data: sensitiveData,
    lifetime: .session
)
```

### Secure Data Storage

```swift
// Store encrypted data
let secureStorage = SecureDataStorage()

let storageConfig = SecureStorageConfiguration()
storageConfig.encryptionAlgorithm = .aes256
storageConfig.storageType = .keychain
storageConfig.accessibility = .whenUnlockedThisDeviceOnly

try secureStorage.store(
    key: "user_credentials",
    value: sensitiveData,
    configuration: storageConfig
)
```

## File Encryption

File encryption protects files and directories from unauthorized access.

### File Encryption Setup

```swift
// Configure file encryption
let fileEncryption = FileEncryptionManager()

let fileConfig = FileEncryptionConfiguration()
fileConfig.encryptionAlgorithm = .aes256
fileConfig.enableFileIntegrity = true
fileConfig.enableCompression = true

try fileEncryption.configure(configuration: fileConfig)
```

### Encrypt Files

```swift
// Encrypt a file
let fileURL = URL(fileURLWithPath: "/path/to/sensitive/file.txt")
let encryptedFileURL = URL(fileURLWithPath: "/path/to/encrypted/file.enc")

try fileEncryption.encryptFile(
    source: fileURL,
    destination: encryptedFileURL,
    key: fileEncryptionKey
)
```

### Decrypt Files

```swift
// Decrypt a file
let decryptedFileURL = URL(fileURLWithPath: "/path/to/decrypted/file.txt")

try fileEncryption.decryptFile(
    source: encryptedFileURL,
    destination: decryptedFileURL,
    key: fileEncryptionKey
)
```

### Directory Encryption

```swift
// Encrypt entire directory
let directoryURL = URL(fileURLWithPath: "/path/to/sensitive/directory")
let encryptedDirectoryURL = URL(fileURLWithPath: "/path/to/encrypted/directory")

try fileEncryption.encryptDirectory(
    source: directoryURL,
    destination: encryptedDirectoryURL,
    key: directoryEncryptionKey
)
```

## Database Encryption

Database encryption protects sensitive data stored in databases.

### SQLite Encryption

```swift
// Configure SQLite encryption
let databaseEncryption = DatabaseEncryptionManager()

let dbConfig = DatabaseEncryptionConfiguration()
dbConfig.encryptionAlgorithm = .aes256
dbConfig.enableColumnEncryption = true
dbConfig.enableTableEncryption = true

try databaseEncryption.configure(configuration: dbConfig)
```

### Encrypt Database

```swift
// Encrypt existing database
let databaseURL = URL(fileURLWithPath: "/path/to/database.sqlite")
let encryptedDatabaseURL = URL(fileURLWithPath: "/path/to/encrypted_database.sqlite")

try databaseEncryption.encryptDatabase(
    source: databaseURL,
    destination: encryptedDatabaseURL,
    key: databaseKey
)
```

### Encrypt Specific Columns

```swift
// Encrypt specific columns
let columnConfig = ColumnEncryptionConfiguration()
columnConfig.columns = ["password", "ssn", "credit_card"]
columnConfig.encryptionAlgorithm = .aes256

try databaseEncryption.encryptColumns(
    database: databaseURL,
    configuration: columnConfig
)
```

## Best Practices

### Security Recommendations

1. **Use strong encryption algorithms** (AES-256, RSA-4096)
2. **Implement proper key management** with secure storage
3. **Enable key rotation** for long-term security
4. **Use hardware acceleration** when available
5. **Implement proper key derivation** (PBKDF2, Argon2)
6. **Enable authentication** for encrypted data
7. **Secure key storage** in keychain or HSM
8. **Regular security audits** of encryption implementation

### Performance Considerations

- AES-256-GCM provides excellent performance
- Hardware acceleration improves encryption speed
- Key caching reduces key generation overhead
- Compression before encryption saves space
- Asymmetric encryption is slower than symmetric

### Compliance Requirements

- **GDPR**: Encrypt all personal data at rest and in transit
- **HIPAA**: Use approved encryption standards (AES-256)
- **SOX**: Encrypt financial data and audit logs
- **PCI DSS**: Encrypt cardholder data with strong algorithms

## Troubleshooting

### Common Issues

1. **Key generation failures**: Check hardware acceleration support
2. **Encryption performance**: Optimize algorithm selection
3. **Memory issues**: Use proper cleanup for sensitive data
4. **Key storage errors**: Verify keychain accessibility settings

### Debug Information

```swift
// Enable encryption debug logging
encryptionManager.enableDebugLogging()

// Get encryption status
let status = encryptionManager.getEncryptionStatus()
print("AES encryption: \(status.aesEnabled)")
print("RSA encryption: \(status.rsaEnabled)")
print("Hardware acceleration: \(status.hardwareAccelerationEnabled)")
print("Key management: \(status.keyManagementEnabled)")
```

## API Reference

For detailed API documentation, see [EncryptionAPI.md](EncryptionAPI.md).

## Examples

For practical examples, see the [EncryptionExamples](../Examples/EncryptionExamples/) directory.
