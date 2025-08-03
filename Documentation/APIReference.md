# API Reference

## Overview

This document provides comprehensive API reference for the iOS Enterprise Security Framework. All classes, methods, and properties are documented with examples and usage guidelines.

## Table of Contents

- [SecurityManager](#securitymanager)
- [EncryptionEngine](#encryptionengine)
- [CertificateManager](#certificatemanager)
- [ComplianceEngine](#complianceengine)
- [ThreatDetector](#threatdetector)
- [KeyManager](#keymanager)
- [AESEngine](#aesengine)
- [Supporting Types](#supporting-types)

## SecurityManager

The main orchestrator for all security operations.

### Initialization

```swift
// Basic initialization
let securityManager = try EnterpriseSecurityManager()

// With custom configuration
let configuration = SecurityConfiguration(
    level: .enterprise,
    activeStandards: [.gdpr, .hipaa],
    enableAuditTrail: true
)
let securityManager = try EnterpriseSecurityManager(configuration: configuration)
```

### Configuration

```swift
// Configure security level
try securityManager.configure(level: .enterprise)

// Check current configuration
let currentLevel = securityManager.currentSecurityLevel
let securityStatus = securityManager.securityStatus
```

### Encryption

```swift
// Encrypt data
let encryptedData = try securityManager.encrypt(
    data: sensitiveData,
    algorithm: .aes256Gcm,
    keySize: .bits256
)

// Decrypt data
let decryptedData = try securityManager.decrypt(encryptedData)
```

### Certificate Management

```swift
// Configure certificate pinning
try securityManager.configureCertificatePinning(
    certificates: [
        "api.enterprise.com": "sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
    ],
    updateInterval: .daily
)

// Validate certificate
let isValid = try securityManager.validateCertificate(
    for: "api.enterprise.com",
    certificate: serverCertificate
)
```

### Compliance

```swift
// Generate compliance report
let report = try securityManager.generateComplianceReport(
    standards: [.gdpr, .hipaa, .sox],
    dateRange: DateInterval(start: Date().addingTimeInterval(-86400*30), duration: 86400*30)
)

// Export audit trail
let auditData = try securityManager.exportAuditTrail(
    format: .json,
    includeSensitiveData: false
)
```

### Threat Detection

```swift
// Perform threat detection
let result = try securityManager.performThreatDetection()

// Check for threats
if !result.threats.isEmpty {
    print("Threats detected: \(result.threats.count)")
}
```

### Key Management

```swift
// Rotate encryption keys
try securityManager.rotateKeys()

// Get security statistics
let statistics = securityManager.getSecurityStatistics()
```

## EncryptionEngine

Advanced encryption engine with multiple algorithms.

### Initialization

```swift
let encryptionEngine = try EncryptionEngine()
```

### Configuration

```swift
let config = EncryptionConfiguration(
    level: .enterprise,
    supportedAlgorithms: [.aes256Gcm, .chacha20Poly1305],
    maxDataSize: 100 * 1024 * 1024, // 100MB
    hardwareAcceleration: true
)
try encryptionEngine.configure(config)
```

### Encryption

```swift
// Encrypt with specific algorithm
let encryptedData = try encryptionEngine.encrypt(
    data: data,
    algorithm: .aes256Gcm,
    keySize: .bits256
)

// Decrypt data
let decryptedData = try encryptionEngine.decrypt(encryptedData)
```

### Key Generation

```swift
// Generate encryption key
let key = try encryptionEngine.generateKey(for: .aes256Gcm, keySize: .bits256)

// Get performance statistics
let stats = encryptionEngine.getPerformanceStatistics()
```

## CertificateManager

Enterprise certificate management with validation and pinning.

### Initialization

```swift
let certificateManager = try CertificateManager()
```

### Configuration

```swift
let config = CertificateConfiguration(
    level: .enterprise,
    enablePinning: true,
    enableRevocationChecking: true,
    enableOCSPChecking: true,
    enableCRLChecking: true,
    updateInterval: .daily
)
try certificateManager.configure(config)
```

### Certificate Pinning

```swift
// Configure certificate pinning
try certificateManager.configurePinning(
    certificates: [
        "api.enterprise.com": "sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=",
        "cdn.enterprise.com": "sha256/BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB="
    ],
    updateInterval: .daily
)

// Update pinned certificates
try certificateManager.updatePinnedCertificates(newCertificates)
```

### Certificate Validation

```swift
// Validate certificate
let isValid = try certificateManager.validateCertificate(
    for: "api.enterprise.com",
    certificate: serverCertificate
)

// Validate certificate authority
let isCAValid = try certificateManager.validateCertificateAuthority(certificate)

// Check certificate revocation
let isNotRevoked = try certificateManager.checkCertificateRevocation(certificate)

// Validate certificate chain
let isChainValid = try certificateManager.validateCertificateChain(certificate)
```

### Statistics

```swift
// Get certificate statistics
let stats = certificateManager.getCertificateStatistics()
print("Total validations: \(stats.totalValidations)")
print("Average speed: \(stats.averageSpeed) validations/sec")
```

## ComplianceEngine

Enterprise compliance reporting and audit trails.

### Initialization

```swift
let complianceEngine = try ComplianceEngine()
```

### Configuration

```swift
let config = ComplianceConfiguration(
    level: .enterprise,
    activeStandards: [.gdpr, .hipaa, .sox],
    enableAuditTrail: true,
    enableDigitalSignatures: true,
    enableEncryption: true
)
try complianceEngine.configure(config)
```

### Compliance Reports

```swift
// Generate compliance report
let report = try complianceEngine.generateReport(
    standards: [.gdpr, .hipaa],
    dateRange: DateInterval(start: Date().addingTimeInterval(-86400*30), duration: 86400*30)
)

// Export report
let exportedData = try complianceEngine.exportReport(
    report,
    format: .json,
    includeSensitiveData: false
)
```

### Specific Compliance Checks

```swift
// GDPR compliance
let gdprStatus = try complianceEngine.checkGDPRCompliance()

// HIPAA compliance
let hipaaStatus = try complianceEngine.checkHIPAACompliance()

// SOX compliance
let soxStatus = try complianceEngine.checkSOXCompliance()

// PCI DSS compliance
let pciStatus = try complianceEngine.checkPCIDSSCompliance()
```

### Statistics

```swift
// Get compliance statistics
let stats = complianceEngine.getComplianceStatistics()
print("Total reports: \(stats.totalReports)")
print("Active standards: \(stats.activeStandards.count)")
```

## ThreatDetector

Advanced threat detection and prevention.

### Initialization

```swift
let threatDetector = try ThreatDetector()
```

### Configuration

```swift
let config = ThreatDetectionConfiguration(
    level: .enterprise,
    enableJailbreakDetection: true,
    enableDebuggerDetection: true,
    enableCertificateTamperingDetection: true,
    enableManInTheMiddleDetection: true,
    enableRuntimeManipulationDetection: true
)
try threatDetector.configure(config)
```

### Threat Detection

```swift
// Perform threat scan
let result = try threatDetector.performScan()

// Check for specific threats
for threat in result.threats {
    switch threat.type {
    case .jailbreak:
        print("Jailbreak detected: \(threat.description)")
    case .debugger:
        print("Debugger detected: \(threat.description)")
    case .certificateTampering:
        print("Certificate tampering detected: \(threat.description)")
    case .manInTheMiddle:
        print("Man-in-the-middle attack detected: \(threat.description)")
    }
}
```

## KeyManager

Enterprise key management with HSM integration.

### Initialization

```swift
let keyManager = try KeyManager()
```

### Configuration

```swift
let config = KeyManagementConfiguration(
    level: .enterprise,
    enableHSM: true,
    enableKeyRotation: true,
    enableMultiTenant: true,
    enableKeyBackup: true,
    enableKeyEscrow: true
)
try keyManager.configure(config)
```

### Key Operations

```swift
// Rotate keys
try keyManager.rotateKeys()

// Generate new key
let key = try keyManager.generateKey(for: .aes256Gcm, keySize: .bits256)

// Backup keys
try keyManager.backupKeys()

// Restore keys
try keyManager.restoreKeys()
```

## AESEngine

AES-256-GCM encryption engine.

### Initialization

```swift
let aesEngine = try AESEngine()
```

### Encryption

```swift
// Generate key
let key = try aesEngine.generateKey(keySize: 256)

// Encrypt data
let encryptedData = try aesEngine.encrypt(data: data, key: key)

// Decrypt data
let decryptedData = try aesEngine.decrypt(encryptedData, key: key)
```

### Performance

```swift
// Get performance statistics
let stats = aesEngine.getPerformanceStatistics()
print("Total operations: \(stats.totalOperations)")
print("Average speed: \(stats.averageSpeed) MB/s")
```

## Supporting Types

### SecurityLevel

```swift
enum SecurityLevel: String, CaseIterable {
    case basic = "basic"
    case standard = "standard"
    case enterprise = "enterprise"
    case military = "military"
}
```

### EncryptionAlgorithm

```swift
enum EncryptionAlgorithm: String, CaseIterable {
    case aes256Gcm = "AES-256-GCM"
    case chacha20Poly1305 = "ChaCha20-Poly1305"
    case rsa4096 = "RSA-4096"
    case ecdsaP256 = "ECDSA-P-256"
    case ecdsaP384 = "ECDSA-P-384"
    case ecdsaP521 = "ECDSA-P-521"
}
```

### ComplianceStandard

```swift
enum ComplianceStandard: String, CaseIterable {
    case gdpr = "GDPR"
    case hipaa = "HIPAA"
    case sox = "SOX"
    case pciDss = "PCI DSS"
    case iso27001 = "ISO 27001"
}
```

### CertificateUpdateInterval

```swift
enum CertificateUpdateInterval: String, CaseIterable {
    case hourly = "hourly"
    case daily = "daily"
    case weekly = "weekly"
    case monthly = "monthly"
}
```

### AuditTrailFormat

```swift
enum AuditTrailFormat: String, CaseIterable {
    case json = "JSON"
    case csv = "CSV"
    case xml = "XML"
    case pdf = "PDF"
}
```

## Error Types

### SecurityError

```swift
enum SecurityError: Error, LocalizedError {
    case initializationFailed(String)
    case configurationFailed(String)
    case encryptionFailed(String)
    case decryptionFailed(String)
    case certificateValidationFailed(String)
    case complianceReportFailed(String)
    case threatDetectionFailed(String)
    case keyManagementFailed(String)
    case auditTrailFailed(String)
}
```

### EncryptionError

```swift
enum EncryptionError: Error, LocalizedError {
    case invalidInput(String)
    case invalidKey(String)
    case keyGenerationFailed(String)
    case encryptionFailed(String)
    case decryptionFailed(String)
}
```

### CertificateError

```swift
enum CertificateError: Error, LocalizedError {
    case invalidConfiguration(String)
    case invalidInput(String)
    case validationFailed(String)
    case pinningFailed(String)
    case revocationCheckFailed(String)
    case chainValidationFailed(String)
    case caValidationFailed(String)
    case ocspCheckFailed(String)
    case crlCheckFailed(String)
}
```

### ComplianceError

```swift
enum ComplianceError: Error, LocalizedError {
    case invalidStandard(ComplianceStandard)
    case reportGenerationFailed(String)
    case exportFailed(String)
    case validationFailed(String)
    case encryptionFailed(String)
    case signatureFailed(String)
}
```

## Performance Considerations

### Memory Usage

- **Base Framework**: 15MB
- **Full Enterprise**: 25MB
- **HSM Integration**: +10MB
- **Audit Trail**: +5MB

### Battery Impact

- **Idle Mode**: <1% battery/hour
- **Active Encryption**: <5% battery/hour
- **Full Compliance**: <3% battery/hour

### Encryption Performance

| Algorithm | Speed (MB/s) | Security Level | Use Case |
|-----------|--------------|----------------|----------|
| AES-256-GCM | 150 | High | General encryption |
| ChaCha20-Poly1305 | 200 | High | High-performance |
| RSA-4096 | 0.5 | Very High | Key exchange |
| ECDSA P-256 | 2.0 | High | Digital signatures |

## Best Practices

### Security

1. **Choose appropriate security level** for your application
2. **Use hardware acceleration** when available
3. **Implement proper key management**
4. **Validate all certificates**
5. **Monitor for threats** continuously
6. **Maintain audit trails** for compliance

### Performance

1. **Use appropriate algorithms** for your use case
2. **Optimize data size** before encryption
3. **Implement lazy loading** for enterprise features
4. **Monitor memory usage** during operations
5. **Cache frequently used** security operations

### Compliance

1. **Understand your requirements** before implementation
2. **Generate regular reports** for compliance
3. **Maintain detailed audit trails**
4. **Monitor security events** continuously
5. **Update security measures** as needed

---

**For more detailed examples and advanced usage patterns, see the [Examples](../Examples) directory.** 