import Foundation
import EnterpriseSecurityFramework

/// Network Security Examples
/// This example demonstrates various network security features including
/// VPN management, certificate pinning, TLS configuration, and threat detection.
class NetworkSecurityExample {
    
    // MARK: - Properties
    
    private let networkSecurity = NetworkSecurityManager()
    private let vpnManager = VPNManager()
    private let pinningManager = CertificatePinningManager()
    private let threatDetection = NetworkThreatDetectionManager()
    private let firewall = FirewallManager()
    
    // MARK: - Initialization
    
    init() {
        setupNetworkSecurity()
    }
    
    // MARK: - Setup
    
    private func setupNetworkSecurity() {
        // Configure network security
        let networkConfig = NetworkSecurityConfiguration()
        networkConfig.enableVPN = true
        networkConfig.enableCertificatePinning = true
        networkConfig.enableTLS = true
        networkConfig.allowedHosts = ["api.company.com", "cdn.company.com"]
        
        networkSecurity.configure(networkConfig)
        
        // Configure VPN
        let vpnConfig = VPNConfiguration()
        vpnConfig.serverAddress = "vpn.company.com"
        vpnConfig.username = "user@company.com"
        vpnConfig.password = "secure_password"
        
        vpnManager.configure(vpnConfig)
        
        // Configure certificate pinning
        let pinningConfig = CertificatePinningConfiguration()
        pinningConfig.enablePinning = true
        pinningConfig.pinnedCertificates = ["cert1", "cert2", "cert3"]
        
        pinningManager.configure(pinningConfig)
    }
    
    // MARK: - Network Security
    
    /// Demonstrates basic network security features
    func demonstrateNetworkSecurity() async {
        print("🌐 Starting Network Security Example")
        
        do {
            // Validate network security
            let validation = try await networkSecurity.validateNetworkSecurity()
            
            print("✅ Network security validation successful")
            print("   VPN active: \(validation.vpnActive)")
            print("   Certificate valid: \(validation.certificateValid)")
            print("   TLS version: \(validation.tlsVersion)")
            
            // Check network connectivity
            let connectivity = try await networkSecurity.checkNetworkConnectivity()
            
            print("✅ Network connectivity check successful")
            print("   Connected: \(connectivity.isConnected)")
            print("   Network type: \(connectivity.networkType)")
            print("   Security level: \(connectivity.securityLevel)")
            
            // Secure network request
            let response = try await networkSecurity.secureRequest(
                url: "https://api.company.com/data",
                configuration: NetworkSecurityConfiguration()
            )
            
            print("✅ Secure network request successful")
            print("   Response status: \(response.statusCode)")
            print("   Response size: \(response.data.count) bytes")
            
        } catch NetworkError.connectionFailed {
            print("❌ Network connection failed")
        } catch NetworkError.certificateInvalid {
            print("❌ Certificate validation failed")
        } catch {
            print("❌ Network security failed: \(error)")
        }
    }
    
    // MARK: - VPN Management
    
    /// Demonstrates VPN management features
    func demonstrateVPNManagement() async {
        print("🌐 Starting VPN Management Example")
        
        do {
            // Connect to VPN
            let connection = try await vpnManager.connect()
            
            print("✅ VPN connection successful")
            print("   Connected: \(connection.isConnected)")
            print("   Server: \(connection.server)")
            print("   IP address: \(connection.ipAddress)")
            
            // Get VPN status
            let status = try await vpnManager.getStatus()
            
            print("✅ VPN status retrieved")
            print("   Connected: \(status.isConnected)")
            print("   Connection time: \(status.connectionTime)")
            print("   Data transferred: \(status.dataTransferred)")
            
            // Configure VPN settings
            let settings = VPNSettings()
            settings.autoConnect = true
            settings.splitTunneling = true
            settings.allowedApps = ["com.company.app"]
            
            try await vpnManager.configureSettings(settings)
            print("✅ VPN settings configured")
            
            // Disconnect from VPN
            try await vpnManager.disconnect()
            print("✅ VPN disconnected")
            
        } catch VPNError.connectionFailed {
            print("❌ VPN connection failed")
        } catch VPNError.configurationFailed {
            print("❌ VPN configuration failed")
        } catch {
            print("❌ VPN management failed: \(error)")
        }
    }
    
    // MARK: - Certificate Pinning
    
    /// Demonstrates certificate pinning features
    func demonstrateCertificatePinning() async {
        print("🌐 Starting Certificate Pinning Example")
        
        let certificateData = "-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----"
        
        do {
            // Add pinned certificate
            try await pinningManager.addPinnedCertificate(
                hostname: "api.company.com",
                certificate: certificateData
            )
            
            print("✅ Pinned certificate added")
            
            // Validate certificate
            let isValid = try await pinningManager.validateCertificate(certificateData)
            
            if isValid {
                print("✅ Certificate is valid and pinned")
            } else {
                print("❌ Certificate validation failed")
            }
            
            // Get pinned certificates
            let certificates = try await pinningManager.getPinnedCertificates()
            
            print("✅ Pinned certificates retrieved")
            print("   Total certificates: \(certificates.count)")
            
            // Remove pinned certificate
            try await pinningManager.removePinnedCertificate(hostname: "api.company.com")
            print("✅ Pinned certificate removed")
            
        } catch PinningError.certificateInvalid {
            print("❌ Invalid certificate")
        } catch PinningError.hostnameNotFound {
            print("❌ Hostname not found")
        } catch {
            print("❌ Certificate pinning failed: \(error)")
        }
    }
    
    // MARK: - TLS Configuration
    
    /// Demonstrates TLS configuration features
    func demonstrateTLSConfiguration() async {
        print("🌐 Starting TLS Configuration Example")
        
        do {
            // Configure TLS settings
            let tlsConfig = TLSConfiguration()
            tlsConfig.minimumVersion = .tls12
            tlsConfig.maximumVersion = .tls13
            tlsConfig.cipherSuites = [.aes256, .chacha20]
            tlsConfig.enableOCSP = true
            
            try await networkSecurity.configureTLS(tlsConfig)
            print("✅ TLS configuration applied")
            
            // Validate TLS connection
            let tlsValidation = try await networkSecurity.validateTLSConnection(url: "https://api.company.com")
            
            print("✅ TLS validation successful")
            print("   TLS version: \(tlsValidation.version)")
            print("   Cipher suite: \(tlsValidation.cipherSuite)")
            print("   Certificate valid: \(tlsValidation.certificateValid)")
            
        } catch TLSError.configurationFailed {
            print("❌ TLS configuration failed")
        } catch TLSError.validationFailed {
            print("❌ TLS validation failed")
        } catch {
            print("❌ TLS configuration failed: \(error)")
        }
    }
    
    // MARK: - Threat Detection
    
    /// Demonstrates network threat detection features
    func demonstrateThreatDetection() async {
        print("🌐 Starting Threat Detection Example")
        
        do {
            // Configure threat detection
            let threatConfig = ThreatDetectionConfiguration()
            threatConfig.enableRealTimeMonitoring = true
            threatConfig.enableAnomalyDetection = true
            threatConfig.threshold = 0.8
            
            try await threatDetection.configure(threatConfig)
            print("✅ Threat detection configured")
            
            // Start monitoring
            try await threatDetection.startMonitoring { threat in
                print("🚨 Network threat detected: \(threat.type)")
                print("   Severity: \(threat.severity)")
                print("   Source: \(threat.source)")
                print("   Details: \(threat.details)")
            }
            
            print("✅ Threat monitoring started")
            
            // Get threat statistics
            let statistics = try await threatDetection.getThreatStatistics()
            
            print("✅ Threat statistics retrieved")
            print("   Total threats: \(statistics.totalThreats)")
            print("   High severity: \(statistics.highSeverity)")
            print("   Blocked connections: \(statistics.blockedConnections)")
            
        } catch ThreatError.monitoringFailed {
            print("❌ Threat monitoring failed")
        } catch ThreatError.configurationFailed {
            print("❌ Threat detection configuration failed")
        } catch {
            print("❌ Threat detection failed: \(error)")
        }
    }
    
    // MARK: - Firewall Management
    
    /// Demonstrates firewall management features
    func demonstrateFirewallManagement() async {
        print("🌐 Starting Firewall Management Example")
        
        do {
            // Configure firewall rules
            let rule = FirewallRule(
                action: .allow,
                protocol: .tcp,
                port: 443,
                source: "192.168.1.0/24",
                destination: "api.company.com"
            )
            
            try await firewall.addRule(rule)
            print("✅ Firewall rule added")
            
            // Block specific connections
            try await firewall.blockConnection(
                source: "malicious.ip.address",
                reason: "Suspicious activity detected"
            )
            print("✅ Connection blocked")
            
            // Get firewall statistics
            let stats = try await firewall.getStatistics()
            
            print("✅ Firewall statistics retrieved")
            print("   Allowed connections: \(stats.allowedConnections)")
            print("   Blocked connections: \(stats.blockedConnections)")
            print("   Active rules: \(stats.activeRules)")
            
        } catch FirewallError.ruleFailed {
            print("❌ Firewall rule failed")
        } catch FirewallError.blockFailed {
            print("❌ Connection blocking failed")
        } catch {
            print("❌ Firewall management failed: \(error)")
        }
    }
    
    // MARK: - Secure Communication
    
    /// Demonstrates secure communication features
    func demonstrateSecureCommunication() async {
        print("🌐 Starting Secure Communication Example")
        
        do {
            // Establish secure connection
            let connection = try await networkSecurity.establishSecureConnection(
                host: "api.company.com",
                port: 443
            )
            
            print("✅ Secure connection established")
            print("   Protocol: \(connection.protocol)")
            print("   Cipher: \(connection.cipher)")
            print("   Certificate: \(connection.certificate)")
            
            // Send secure data
            let data = "Sensitive data to transmit"
            let response = try await networkSecurity.sendSecureData(
                data: data,
                connection: connection
            )
            
            print("✅ Secure data sent")
            print("   Response: \(response)")
            
            // Close secure connection
            try await networkSecurity.closeSecureConnection(connection)
            print("✅ Secure connection closed")
            
        } catch SecureCommunicationError.connectionFailed {
            print("❌ Secure connection failed")
        } catch SecureCommunicationError.transmissionFailed {
            print("❌ Secure transmission failed")
        } catch {
            print("❌ Secure communication failed: \(error)")
        }
    }
}

// MARK: - Supporting Types

enum NetworkError: Error {
    case connectionFailed
    case certificateInvalid
    case timeout
}

enum VPNError: Error {
    case connectionFailed
    case configurationFailed
    case authenticationFailed
}

enum PinningError: Error {
    case certificateInvalid
    case hostnameNotFound
}

enum TLSError: Error {
    case configurationFailed
    case validationFailed
}

enum ThreatError: Error {
    case monitoringFailed
    case configurationFailed
}

enum FirewallError: Error {
    case ruleFailed
    case blockFailed
}

enum SecureCommunicationError: Error {
    case connectionFailed
    case transmissionFailed
}

// MARK: - Usage Example

@main
struct NetworkSecurityExampleApp {
    static func main() async {
        let example = NetworkSecurityExample()
        
        // Run network security examples
        await example.demonstrateNetworkSecurity()
        await example.demonstrateVPNManagement()
        await example.demonstrateCertificatePinning()
        await example.demonstrateTLSConfiguration()
        await example.demonstrateThreatDetection()
        await example.demonstrateFirewallManagement()
        await example.demonstrateSecureCommunication()
        
        print("✅ Network Security Example Completed")
    }
} 