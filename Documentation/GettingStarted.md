# Getting Started Guide

## Introduction

Welcome to the iOS Enterprise Security Framework! This guide will help you get started with implementing enterprise-grade security features in your iOS applications.

## Prerequisites

- **Xcode 15.0+** with iOS 17.0+ SDK
- **Swift 5.9+**
- **iOS 17.0+** deployment target
- **Basic understanding** of iOS development and security concepts

## Installation

### Swift Package Manager

1. Open your Xcode project
2. Go to **File > Add Package Dependencies**
3. Enter the repository URL: `https://github.com/muhittincamdali/iOS-Enterprise-Security-Framework.git`
4. Select the latest version and click **Add Package**

### Manual Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/muhittincamdali/iOS-Enterprise-Security-Framework.git
   ```

2. Add the framework to your project:
   - Drag `Sources/` folder to your Xcode project
   - Ensure "Copy items if needed" is checked
   - Add to your target

## Quick Start

### 1. Import the Framework

```swift
import EnterpriseSecurity
```

### 2. Initialize the Security Manager

```swift
// Basic initialization
let securityManager = try EnterpriseSecurityManager()

// Configure with enterprise settings
try securityManager.configure(level: .enterprise)
```

### 3. Basic Encryption

```swift
// Encrypt sensitive data
let sensitiveData = "Confidential information"
let encryptedData = try securityManager.encrypt(
    data: sensitiveData.data(using: .utf8)!,
    algorithm: .aes256Gcm,
    keySize: .bits256
)

// Decrypt data
let decryptedData = try securityManager.decrypt(encryptedData)
```

### 4. Certificate Management

```swift
// Configure certificate pinning
try securityManager.configureCertificatePinning(
    certificates: [
        "api.enterprise.com": "sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=",
        "cdn.enterprise.com": "sha256/BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB="
    ],
    updateInterval: .daily
)
```

### 5. Compliance Reporting

```swift
// Generate compliance report
let complianceReport = try securityManager.generateComplianceReport(
    standards: [.gdpr, .hipaa, .sox],
    dateRange: DateInterval(start: Date().addingTimeInterval(-86400*30), duration: 86400*30)
)
```

## Configuration

### Security Levels

The framework supports different security levels:

- **Basic**: Essential security features
- **Standard**: Standard enterprise features
- **Enterprise**: Full enterprise capabilities
- **Military**: Military-grade security

```swift
// Configure security level
try securityManager.configure(level: .enterprise)
```

### Encryption Algorithms

Available encryption algorithms:

- **AES-256-GCM**: General encryption
- **ChaCha20-Poly1305**: High-performance encryption
- **RSA-4096**: Asymmetric encryption
- **ECDSA P-256/P-384/P-521**: Digital signatures

```swift
// Use specific encryption algorithm
let encryptedData = try securityManager.encrypt(
    data: data,
    algorithm: .aes256Gcm,
    keySize: .bits256
)
```

## Best Practices

### 1. Security Level Selection

Choose the appropriate security level for your application:

- **Basic**: Personal apps, simple data protection
- **Standard**: Business apps, moderate security requirements
- **Enterprise**: Financial, healthcare, government apps
- **Military**: Defense, intelligence, critical infrastructure

### 2. Key Management

- Never hardcode encryption keys
- Use secure key storage (Keychain)
- Implement key rotation
- Backup keys securely

### 3. Certificate Management

- Pin certificates for critical domains
- Implement certificate validation
- Monitor certificate expiration
- Handle certificate updates

### 4. Compliance

- Understand your compliance requirements
- Generate regular compliance reports
- Maintain audit trails
- Monitor security events

## Examples

### Basic Encryption Example

```swift
import EnterpriseSecurity

class SecurityExample {
    private let securityManager: EnterpriseSecurityManager
    
    init() throws {
        self.securityManager = try EnterpriseSecurityManager()
        try securityManager.configure(level: .enterprise)
    }
    
    func encryptUserData(_ data: Data) throws -> EncryptedData {
        return try securityManager.encrypt(
            data: data,
            algorithm: .aes256Gcm,
            keySize: .bits256
        )
    }
    
    func decryptUserData(_ encryptedData: EncryptedData) throws -> Data {
        return try securityManager.decrypt(encryptedData)
    }
}
```

### Certificate Pinning Example

```swift
class CertificateExample {
    private let securityManager: EnterpriseSecurityManager
    
    init() throws {
        self.securityManager = try EnterpriseSecurityManager()
        try configureCertificatePinning()
    }
    
    private func configureCertificatePinning() throws {
        let certificates = [
            "api.myapp.com": "sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=",
            "cdn.myapp.com": "sha256/BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB="
        ]
        
        try securityManager.configureCertificatePinning(
            certificates: certificates,
            updateInterval: .daily
        )
    }
}
```

### Compliance Example

```swift
class ComplianceExample {
    private let securityManager: EnterpriseSecurityManager
    
    init() throws {
        self.securityManager = try EnterpriseSecurityManager()
    }
    
    func generateMonthlyReport() throws -> ComplianceReport {
        let dateRange = DateInterval(
            start: Calendar.current.date(byAdding: .month, value: -1, to: Date())!,
            duration: 86400 * 30
        )
        
        return try securityManager.generateComplianceReport(
            standards: [.gdpr, .hipaa],
            dateRange: dateRange
        )
    }
}
```

## Troubleshooting

### Common Issues

1. **Initialization Failed**
   - Check iOS version compatibility
   - Verify framework is properly linked
   - Ensure sufficient permissions

2. **Encryption Errors**
   - Verify key size matches algorithm
   - Check data format
   - Ensure proper error handling

3. **Certificate Validation Failed**
   - Verify certificate format
   - Check hostname matching
   - Update pinned certificates

4. **Performance Issues**
   - Use appropriate security level
   - Optimize data size
   - Monitor memory usage

### Debug Mode

Enable debug logging for troubleshooting:

```swift
// Enable debug mode
try securityManager.configure(level: .basic)
```

## Next Steps

1. **Read the API Reference** for detailed documentation
2. **Check Security Best Practices** for guidelines
3. **Review Compliance Guide** for regulatory requirements
4. **Explore Examples** for implementation patterns
5. **Join the Community** for support and updates

## Support

- **GitHub Issues**: Report bugs and request features
- **Documentation**: Comprehensive guides and examples
- **Community**: Connect with other developers
- **Security**: Report security vulnerabilities privately

## License

This framework is licensed under the MIT License. See the [LICENSE](../LICENSE) file for details.

---

**Ready to secure your iOS application? Start with the examples above and explore the full documentation for advanced features!** 