# Key Management API

## Overview

The Key Management API provides comprehensive key management capabilities for the iOS Enterprise Security Framework. This API handles key generation, storage, rotation, and lifecycle management for enterprise security applications.

## Table of Contents

- [Key Management Overview](#key-management-overview)
- [Key Types](#key-types)
- [Key Generation](#key-generation)
- [Key Storage](#key-storage)
- [Key Rotation](#key-rotation)
- [Key Retrieval](#key-retrieval)
- [Key Destruction](#key-destruction)
- [HSM Integration](#hsm-integration)
- [API Reference](#api-reference)

## Key Management Overview

Key management is a critical component of enterprise security. The Key Management API provides:

- **Secure Key Generation**: Cryptographically secure key generation
- **Key Storage**: Secure storage in keychain or HSM
- **Key Rotation**: Automatic and manual key rotation
- **Key Lifecycle**: Complete key lifecycle management
- **HSM Integration**: Hardware Security Module support
- **Multi-tenant Support**: Isolated key contexts

## Key Types

The framework supports various key types for different security requirements:

### Symmetric Keys

```swift
enum SymmetricKeyType {
    case aes128
    case aes192
    case aes256
    case chacha20
    case custom(algorithm: String, keySize: Int)
}
```

### Asymmetric Keys

```swift
enum AsymmetricKeyType {
    case rsa1024
    case rsa2048
    case rsa4096
    case eccP256
    case eccP384
    case eccP521
    case custom(algorithm: String, keySize: Int)
}
```

### Key Usage

```swift
enum KeyUsage {
    case encryption
    case decryption
    case signing
    case verification
    case keyExchange
    case keyWrapping
}
```

## Key Generation

### Basic Key Generation

```swift
import EnterpriseSecurity

let keyManager = KeyManager()

// Generate AES-256 key
let aesKey = try keyManager.generateKey(
    type: .symmetric(.aes256),
    usage: .encryption
)

// Generate RSA-4096 key pair
let rsaKeyPair = try keyManager.generateKeyPair(
    type: .asymmetric(.rsa4096),
    usage: [.encryption, .decryption]
)
```

### Advanced Key Generation

```swift
// Configure key generation
let keyConfig = KeyGenerationConfiguration()
keyConfig.algorithm = .aes256
keyConfig.keySize = 256
keyConfig.useSecureRandom = true
keyConfig.enableHardwareAcceleration = true
keyConfig.keyDerivationFunction = .pbkdf2
keyConfig.iterations = 100000

let generatedKey = try keyManager.generateKey(configuration: keyConfig)
```

### Key Generation with Attributes

```swift
// Generate key with specific attributes
let keyAttributes = KeyAttributes()
keyAttributes.label = "Enterprise Encryption Key"
keyAttributes.applicationTag = "com.enterprise.security"
keyAttributes.isPermanent = true
keyAttributes.isExtractable = false
keyAttributes.canEncrypt = true
keyAttributes.canDecrypt = true

let keyWithAttributes = try keyManager.generateKey(
    type: .symmetric(.aes256),
    attributes: keyAttributes
)
```

## Key Storage

### Keychain Storage

```swift
// Store key in keychain
let storageConfig = KeyStorageConfiguration()
storageConfig.storageType = .keychain
storageConfig.accessibility = .whenUnlockedThisDeviceOnly
storageConfig.protectionLevel = .complete
storageConfig.label = "Enterprise Key"
storageConfig.applicationTag = "com.enterprise.security"

try keyManager.storeKey(
    generatedKey,
    configuration: storageConfig
)
```

### HSM Storage

```swift
// Store key in HSM
let hsmConfig = HSMStorageConfiguration()
hsmConfig.storageType = .hsm
hsmConfig.hsmProvider = .awsCloudHSM
hsmConfig.keyId = "hsm-key-12345"
hsmConfig.isPermanent = true
hsmConfig.isExtractable = false

try keyManager.storeKey(
    generatedKey,
    configuration: hsmConfig
)
```

### Secure Enclave Storage

```swift
// Store key in Secure Enclave
let enclaveConfig = SecureEnclaveConfiguration()
enclaveConfig.storageType = .secureEnclave
enclaveConfig.accessibility = .whenUnlockedThisDeviceOnly
enclaveConfig.protectionLevel = .complete
enclaveConfig.requiresBiometricAuthentication = true

try keyManager.storeKey(
    generatedKey,
    configuration: enclaveConfig
)
```

## Key Rotation

### Automatic Key Rotation

```swift
// Configure automatic key rotation
let rotationConfig = KeyRotationConfiguration()
rotationConfig.enableAutomaticRotation = true
rotationConfig.rotationInterval = 30 // days
rotationConfig.overlapPeriod = 7 // days
rotationConfig.rotationStrategy = .rolling
rotationConfig.notificationEnabled = true

try keyManager.configureKeyRotation(configuration: rotationConfig)
```

### Manual Key Rotation

```swift
// Manually rotate keys
let rotationResult = try keyManager.rotateKey(
    keyId: "old-key-id",
    newKeyType: .symmetric(.aes256)
)

print("✅ Key rotated successfully")
print("Old key ID: \(rotationResult.oldKeyId)")
print("New key ID: \(rotationResult.newKeyId)")
print("Rotation time: \(rotationResult.rotationTime)")
```

### Key Rotation with Migration

```swift
// Rotate key with data migration
let migrationConfig = KeyMigrationConfiguration()
migrationConfig.enableDataMigration = true
migrationConfig.migrationStrategy = .reEncrypt
migrationConfig.batchSize = 1000
migrationConfig.parallelProcessing = true

let migrationResult = try keyManager.rotateKeyWithMigration(
    keyId: "old-key-id",
    newKeyType: .symmetric(.aes256),
    configuration: migrationConfig
)
```

## Key Retrieval

### Basic Key Retrieval

```swift
// Retrieve key from storage
let retrievedKey = try keyManager.retrieveKey(
    keyId: "stored-key-id"
)

print("✅ Key retrieved successfully")
print("Key ID: \(retrievedKey.keyId)")
print("Algorithm: \(retrievedKey.algorithm)")
print("Key size: \(retrievedKey.keySize)")
```

### Key Retrieval with Authentication

```swift
// Retrieve key with biometric authentication
let authConfig = KeyRetrievalConfiguration()
authConfig.requireBiometricAuthentication = true
authConfig.biometricType = .faceID
authConfig.fallbackToPasscode = true

let authenticatedKey = try keyManager.retrieveKey(
    keyId: "secure-key-id",
    configuration: authConfig
)
```

### Key Retrieval by Attributes

```swift
// Retrieve key by attributes
let searchAttributes = KeySearchAttributes()
searchAttributes.label = "Enterprise Encryption Key"
searchAttributes.applicationTag = "com.enterprise.security"
searchAttributes.keyType = .symmetric(.aes256)

let foundKeys = try keyManager.retrieveKeys(matching: searchAttributes)
```

## Key Destruction

### Secure Key Destruction

```swift
// Securely destroy key
try keyManager.destroyKey(keyId: "key-to-destroy")

print("✅ Key destroyed securely")
```

### Key Destruction with Verification

```swift
// Destroy key with verification
let destructionConfig = KeyDestructionConfiguration()
destructionConfig.requireConfirmation = true
destructionConfig.verifyDestruction = true
destructionConfig.logDestruction = true

let destructionResult = try keyManager.destroyKey(
    keyId: "key-to-destroy",
    configuration: destructionConfig
)

if destructionResult.verified {
    print("✅ Key destroyed and verified")
} else {
    print("❌ Key destruction verification failed")
}
```

## HSM Integration

### HSM Configuration

```swift
// Configure HSM integration
let hsmConfig = HSMConfiguration()
hsmConfig.provider = .awsCloudHSM
hsmConfig.region = "us-east-1"
hsmConfig.clusterId = "cluster-12345"
hsmConfig.credentials = hsmCredentials

try keyManager.configureHSM(configuration: hsmConfig)
```

### HSM Key Operations

```swift
// Generate key in HSM
let hsmKey = try keyManager.generateKeyInHSM(
    type: .symmetric(.aes256),
    hsmKeyId: "hsm-key-12345"
)

// Use HSM key for encryption
let encryptedData = try keyManager.encryptWithHSMKey(
    data: sensitiveData,
    hsmKeyId: "hsm-key-12345"
)
```

## API Reference

### KeyManager Class

```swift
class KeyManager {
    // Initialization
    init()
    init(configuration: KeyManagerConfiguration)
    
    // Key Generation
    func generateKey(type: KeyType, usage: KeyUsage) throws -> Key
    func generateKeyPair(type: AsymmetricKeyType, usage: [KeyUsage]) throws -> KeyPair
    func generateKey(configuration: KeyGenerationConfiguration) throws -> Key
    
    // Key Storage
    func storeKey(_ key: Key, configuration: KeyStorageConfiguration) throws
    func storeKeyInHSM(_ key: Key, configuration: HSMStorageConfiguration) throws
    
    // Key Retrieval
    func retrieveKey(keyId: String) throws -> Key
    func retrieveKey(keyId: String, configuration: KeyRetrievalConfiguration) throws -> Key
    func retrieveKeys(matching: KeySearchAttributes) throws -> [Key]
    
    // Key Rotation
    func configureKeyRotation(configuration: KeyRotationConfiguration) throws
    func rotateKey(keyId: String, newKeyType: KeyType) throws -> KeyRotationResult
    func rotateKeyWithMigration(keyId: String, newKeyType: KeyType, configuration: KeyMigrationConfiguration) throws -> KeyMigrationResult
    
    // Key Destruction
    func destroyKey(keyId: String) throws
    func destroyKey(keyId: String, configuration: KeyDestructionConfiguration) throws -> KeyDestructionResult
    
    // HSM Operations
    func configureHSM(configuration: HSMConfiguration) throws
    func generateKeyInHSM(type: KeyType, hsmKeyId: String) throws -> Key
    func encryptWithHSMKey(data: Data, hsmKeyId: String) throws -> Data
    
    // Status and Information
    func getKeyStatus(keyId: String) throws -> KeyStatus
    func listKeys() throws -> [KeyInfo]
    func getKeyManagerStatus() -> KeyManagerStatus
}
```

### Key Types

```swift
struct Key {
    let keyId: String
    let algorithm: String
    let keySize: Int
    let keyType: KeyType
    let usage: [KeyUsage]
    let creationDate: Date
    let expirationDate: Date?
    let isPermanent: Bool
    let isExtractable: Bool
}

struct KeyPair {
    let publicKey: Key
    let privateKey: Key
    let keyPairId: String
}

struct KeyStatus {
    let keyId: String
    let isActive: Bool
    let isExpired: Bool
    let isCompromised: Bool
    let lastUsed: Date?
    let usageCount: Int
}
```

### Configuration Types

```swift
struct KeyGenerationConfiguration {
    var algorithm: String
    var keySize: Int
    var useSecureRandom: Bool
    var enableHardwareAcceleration: Bool
    var keyDerivationFunction: KeyDerivationFunction
    var iterations: Int
}

struct KeyStorageConfiguration {
    var storageType: StorageType
    var accessibility: KeychainAccessibility
    var protectionLevel: KeychainProtectionLevel
    var label: String?
    var applicationTag: String?
}

struct KeyRotationConfiguration {
    var enableAutomaticRotation: Bool
    var rotationInterval: Int
    var overlapPeriod: Int
    var rotationStrategy: RotationStrategy
    var notificationEnabled: Bool
}
```

## Examples

For practical examples, see the [KeyManagementExamples](../Examples/KeyManagementExamples/) directory.

## Best Practices

1. **Use strong key sizes** (AES-256, RSA-4096)
2. **Implement key rotation** regularly
3. **Store keys securely** in keychain or HSM
4. **Use hardware acceleration** when available
5. **Implement proper key lifecycle** management
6. **Log key operations** for audit purposes
7. **Test key management** thoroughly
8. **Follow compliance requirements** for key handling
