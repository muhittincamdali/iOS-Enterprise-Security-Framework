# Network Security API

## Overview

The Network Security API provides comprehensive network security capabilities for iOS enterprise applications. It includes VPN management, certificate pinning, TLS configuration, and network threat detection.

## Core Components

### NetworkSecurityManager

Manages network security operations including VPN, certificate pinning, and secure connections.

```swift
import EnterpriseSecurityFramework

// Initialize network security manager
let networkSecurity = NetworkSecurityManager()

// Configure network security
let networkConfig = NetworkSecurityConfiguration()
networkConfig.enableVPN = true
networkConfig.enableCertificatePinning = true
networkConfig.enableTLS = true
networkConfig.allowedHosts = ["api.company.com", "cdn.company.com"]

// Secure network request
let response = await networkSecurity.secureRequest(
    url: "https://api.company.com/data",
    configuration: networkConfig
)
```

### VPNManager

Handles VPN connection and configuration management.

```swift
// Initialize VPN manager
let vpnManager = VPNManager()

// Configure VPN
let vpnConfig = VPNConfiguration()
vpnConfig.serverAddress = "vpn.company.com"
vpnConfig.username = "user@company.com"
vpnConfig.password = "secure_password"
vpnConfig.certificate = vpnCertificate

// Connect to VPN
await vpnManager.connect(configuration: vpnConfig)
```

### CertificatePinningManager

Manages certificate pinning for secure network communications.

```swift
// Initialize certificate pinning manager
let pinningManager = CertificatePinningManager()

// Configure certificate pinning
let pinningConfig = CertificatePinningConfiguration()
pinningConfig.enablePinning = true
pinningConfig.pinnedCertificates = ["cert1", "cert2", "cert3"]
pinningConfig.backupCertificates = ["backup1", "backup2"]

// Validate certificate
let isValid = await pinningManager.validateCertificate(certificate)
```

## API Reference

### Network Security

```swift
// Secure network request
let response = await networkSecurity.secureRequest(
    url: "https://api.company.com/data",
    configuration: networkConfig
)

// Validate network security
let validation = await networkSecurity.validateNetworkSecurity()
print("VPN active: \(validation.vpnActive)")
print("Certificate valid: \(validation.certificateValid)")
print("TLS version: \(validation.tlsVersion)")

// Check network connectivity
let connectivity = await networkSecurity.checkNetworkConnectivity()
print("Connected: \(connectivity.isConnected)")
print("Network type: \(connectivity.networkType)")
print("Security level: \(connectivity.securityLevel)")
```

### VPN Management

```swift
// Connect to VPN
let connection = await vpnManager.connect(configuration: vpnConfig)
print("VPN connected: \(connection.isConnected)")
print("Server: \(connection.server)")
print("IP address: \(connection.ipAddress)")

// Disconnect from VPN
await vpnManager.disconnect()

// Get VPN status
let status = await vpnManager.getStatus()
print("Connected: \(status.isConnected)")
print("Connection time: \(status.connectionTime)")
print("Data transferred: \(status.dataTransferred)")

// Configure VPN settings
let settings = VPNSettings()
settings.autoConnect = true
settings.splitTunneling = true
settings.allowedApps = ["com.company.app"]

await vpnManager.configureSettings(settings)
```

### Certificate Pinning

```swift
// Validate certificate
let isValid = await pinningManager.validateCertificate(certificate)
if isValid {
    print("✅ Certificate is valid and pinned")
} else {
    print("❌ Certificate validation failed")
}

// Add pinned certificate
await pinningManager.addPinnedCertificate(
    hostname: "api.company.com",
    certificate: certificateData
)

// Remove pinned certificate
await pinningManager.removePinnedCertificate(hostname: "api.company.com")

// Get pinned certificates
let certificates = await pinningManager.getPinnedCertificates()
print("Pinned certificates: \(certificates.count)")
```

### TLS Configuration

```swift
// Configure TLS settings
let tlsConfig = TLSConfiguration()
tlsConfig.minimumVersion = .tls12
tlsConfig.maximumVersion = .tls13
tlsConfig.cipherSuites = [.aes256, .chacha20]
tlsConfig.enableOCSP = true

// Apply TLS configuration
await networkSecurity.configureTLS(tlsConfig)

// Validate TLS connection
let tlsValidation = await networkSecurity.validateTLSConnection(url: "https://api.company.com")
print("TLS version: \(tlsValidation.version)")
print("Cipher suite: \(tlsValidation.cipherSuite)")
print("Certificate valid: \(tlsValidation.certificateValid)")
```

### Network Threat Detection

```swift
// Initialize threat detection
let threatDetection = NetworkThreatDetectionManager()

// Monitor network traffic
await threatDetection.startMonitoring { threat in
    print("🚨 Network threat detected: \(threat.type)")
    print("   Severity: \(threat.severity)")
    print("   Source: \(threat.source)")
    print("   Details: \(threat.details)")
}

// Configure threat detection
let threatConfig = ThreatDetectionConfiguration()
threatConfig.enableRealTimeMonitoring = true
threatConfig.enableAnomalyDetection = true
threatConfig.threshold = 0.8

await threatDetection.configure(threatConfig)

// Get threat statistics
let statistics = await threatDetection.getThreatStatistics()
print("Total threats: \(statistics.totalThreats)")
print("High severity: \(statistics.highSeverity)")
print("Blocked connections: \(statistics.blockedConnections)")
```

### Firewall Management

```swift
// Initialize firewall manager
let firewall = FirewallManager()

// Configure firewall rules
let rule = FirewallRule(
    action: .allow,
    protocol: .tcp,
    port: 443,
    source: "192.168.1.0/24",
    destination: "api.company.com"
)

await firewall.addRule(rule)

// Block specific connections
await firewall.blockConnection(
    source: "malicious.ip.address",
    reason: "Suspicious activity detected"
)

// Get firewall statistics
let stats = await firewall.getStatistics()
print("Allowed connections: \(stats.allowedConnections)")
print("Blocked connections: \(stats.blockedConnections)")
print("Active rules: \(stats.activeRules)")
```

## Error Handling

```swift
do {
    let response = try await networkSecurity.secureRequest(url: "https://api.company.com/data")
} catch NetworkError.connectionFailed {
    // Handle connection failure
} catch NetworkError.certificateInvalid {
    // Handle certificate validation failure
} catch NetworkError.vpnNotConnected {
    // Handle VPN connection issue
} catch NetworkError.threatDetected {
    // Handle security threat
} catch {
    // Handle other network errors
}
```

## Best Practices

1. **Always use HTTPS for sensitive data**
2. **Implement certificate pinning**
3. **Use VPN for enterprise connections**
4. **Monitor network threats**
5. **Configure proper TLS settings**
6. **Implement firewall rules**
7. **Log network security events**
8. **Use secure DNS**

## Security Considerations

- Implement certificate pinning for critical endpoints
- Use VPN for enterprise network access
- Monitor network traffic for threats
- Configure proper firewall rules
- Use secure DNS servers
- Implement network segmentation
- Monitor for data exfiltration
- Use secure protocols (TLS 1.3)

## Examples

See the [Network Security Examples](../Examples/NetworkSecurityExamples/) directory for complete implementation examples.

## Related Documentation

- [Security Manager API](SecurityManagerAPI.md)
- [Authentication API](AuthenticationAPI.md)
- [Encryption API](EncryptionAPI.md)
- [Network Security Guide](NetworkSecurityGuide.md)
- [Getting Started Guide](GettingStarted.md)
