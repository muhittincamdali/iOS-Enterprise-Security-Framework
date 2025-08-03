//
//  SecurityManager.swift
//  iOS-Enterprise-Security-Framework
//
//  Created by Muhittin Camdali on 2024-01-15
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import Foundation
import CryptoKit
import Security
import os.log

/// Enterprise Security Manager for iOS applications
///
/// This class provides enterprise-grade security features including:
/// - Advanced encryption (AES-256-GCM, ChaCha20-Poly1305, RSA-4096)
/// - Certificate management and pinning
/// - Compliance reporting (GDPR, HIPAA, SOX)
/// - Threat detection and prevention
/// - Audit trail generation
/// - Enterprise key management with HSM integration
/// - Multi-tenant security contexts
///
/// ## Usage
///
/// ```swift
/// let securityManager = EnterpriseSecurityManager()
/// try securityManager.configure(level: .enterprise)
/// ```
///
/// ## Security Considerations
///
/// - All encryption operations use hardware acceleration when available
/// - Certificate pinning prevents man-in-the-middle attacks
/// - Audit trails are generated for compliance requirements
/// - Threat detection runs continuously in the background
/// - Enterprise features require proper licensing
///
/// - Since: 1.0.0
/// - Author: Enterprise Security Team
/// - SeeAlso: `SecurityLevel`, `EncryptionAlgorithm`, `ComplianceStandard`
@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
public final class EnterpriseSecurityManager: ObservableObject {
    
    // MARK: - Public Properties
    
    /// Current security level configuration
    @Published public private(set) var currentSecurityLevel: SecurityLevel = .basic
    
    /// Current compliance standards
    @Published public private(set) var activeComplianceStandards: Set<ComplianceStandard> = []
    
    /// Security status and health
    @Published public private(set) var securityStatus: SecurityStatus = .initializing
    
    /// Performance metrics
    @Published public private(set) var performanceMetrics: PerformanceMetrics = PerformanceMetrics()
    
    // MARK: - Private Properties
    
    private let encryptionEngine: EncryptionEngine
    private let certificateManager: CertificateManager
    private let complianceEngine: ComplianceEngine
    private let threatDetector: ThreatDetector
    private let keyManager: KeyManager
    private let auditTrail: AuditTrail
    private let logger: Logger
    
    private let configurationQueue = DispatchQueue(label: "com.enterprise.security.configuration", qos: .userInitiated)
    private let securityQueue = DispatchQueue(label: "com.enterprise.security.operations", qos: .userInitiated)
    
    // MARK: - Initialization
    
    /// Initialize the Enterprise Security Manager
    ///
    /// - Parameter configuration: Optional custom configuration
    /// - Throws: `SecurityInitializationError` if initialization fails
    public init(configuration: SecurityConfiguration = SecurityConfiguration()) throws {
        self.logger = Logger(subsystem: "com.enterprise.security", category: "SecurityManager")
        
        // Initialize core components
        self.encryptionEngine = try EncryptionEngine(configuration: configuration.encryption)
        self.certificateManager = try CertificateManager(configuration: configuration.certificate)
        self.complianceEngine = try ComplianceEngine(configuration: configuration.compliance)
        self.threatDetector = try ThreatDetector(configuration: configuration.threat)
        self.keyManager = try KeyManager(configuration: configuration.keyManagement)
        self.auditTrail = try AuditTrail(configuration: configuration.audit)
        
        logger.info("Enterprise Security Manager initialized successfully")
        
        // Start background monitoring
        startBackgroundMonitoring()
    }
    
    // MARK: - Public Methods
    
    /// Configure the security manager with the specified security level
    ///
    /// This method initializes all security components based on the provided
    /// security level. Higher security levels enable more features but may
    /// impact performance.
    ///
    /// - Parameter level: The security level to configure
    /// - Throws: `SecurityConfigurationError` if configuration fails
    /// - Note: This method should be called before using any security features
    /// - Warning: Changing security level at runtime may cause data loss
    ///
    /// ## Example
    ///
    /// ```swift
    /// do {
    ///     try securityManager.configure(level: .enterprise)
    /// } catch {
    ///     print("Configuration failed: \(error)")
    /// }
    /// ```
    public func configure(level: SecurityLevel) throws {
        try configurationQueue.sync {
            logger.info("Configuring security manager with level: \(level.rawValue)")
            
            // Validate security level
            guard SecurityLevel.allCases.contains(level) else {
                throw SecurityConfigurationError.invalidLevel(level)
            }
            
            // Configure components based on security level
            try configureEncryptionEngine(for: level)
            try configureCertificateManager(for: level)
            try configureComplianceEngine(for: level)
            try configureThreatDetector(for: level)
            try configureKeyManager(for: level)
            try configureAuditTrail(for: level)
            
            // Update current configuration
            currentSecurityLevel = level
            securityStatus = .configured
            
            // Log configuration completion
            logger.info("Security manager configured successfully with level: \(level.rawValue)")
            
            // Generate audit event
            try auditTrail.logEvent(.configurationChanged, details: ["level": level.rawValue])
        }
    }
    
    /// Encrypt data using the configured encryption algorithm
    ///
    /// - Parameters:
    ///   - data: The data to encrypt
    ///   - algorithm: The encryption algorithm to use (optional, uses default if nil)
    ///   - keySize: The key size to use (optional, uses default if nil)
    /// - Returns: Encrypted data
    /// - Throws: `EncryptionError` if encryption fails
    public func encrypt(data: Data, algorithm: EncryptionAlgorithm? = nil, keySize: KeySize? = nil) throws -> EncryptedData {
        return try securityQueue.sync {
            logger.debug("Encrypting data of size: \(data.count) bytes")
            
            let encryptedData = try encryptionEngine.encrypt(
                data: data,
                algorithm: algorithm ?? .aes256Gcm,
                keySize: keySize ?? .bits256
            )
            
            // Log encryption event
            try auditTrail.logEvent(.dataEncrypted, details: [
                "dataSize": data.count,
                "algorithm": algorithm?.rawValue ?? "default",
                "keySize": keySize?.rawValue ?? "default"
            ])
            
            return encryptedData
        }
    }
    
    /// Decrypt data using the configured encryption algorithm
    ///
    /// - Parameter encryptedData: The encrypted data to decrypt
    /// - Returns: Decrypted data
    /// - Throws: `EncryptionError` if decryption fails
    public func decrypt(_ encryptedData: EncryptedData) throws -> Data {
        return try securityQueue.sync {
            logger.debug("Decrypting data of size: \(encryptedData.data.count) bytes")
            
            let decryptedData = try encryptionEngine.decrypt(encryptedData)
            
            // Log decryption event
            try auditTrail.logEvent(.dataDecrypted, details: [
                "dataSize": decryptedData.count,
                "algorithm": encryptedData.algorithm.rawValue
            ])
            
            return decryptedData
        }
    }
    
    /// Configure certificate pinning for secure network communication
    ///
    /// - Parameters:
    ///   - certificates: Dictionary of hostname to certificate hash mappings
    ///   - updateInterval: How often to check for certificate updates
    /// - Throws: `CertificateError` if configuration fails
    public func configureCertificatePinning(
        certificates: [String: String],
        updateInterval: CertificateUpdateInterval = .daily
    ) throws {
        try configurationQueue.sync {
            logger.info("Configuring certificate pinning for \(certificates.count) certificates")
            
            try certificateManager.configurePinning(
                certificates: certificates,
                updateInterval: updateInterval
            )
            
            // Log certificate pinning configuration
            try auditTrail.logEvent(.certificatePinningConfigured, details: [
                "certificateCount": certificates.count,
                "updateInterval": updateInterval.rawValue
            ])
        }
    }
    
    /// Validate a certificate for a specific hostname
    ///
    /// - Parameters:
    ///   - hostname: The hostname to validate the certificate for
    ///   - certificate: The certificate to validate
    /// - Returns: True if certificate is valid, false otherwise
    /// - Throws: `CertificateError` if validation fails
    public func validateCertificate(for hostname: String, certificate: SecCertificate) throws -> Bool {
        return try securityQueue.sync {
            logger.debug("Validating certificate for hostname: \(hostname)")
            
            let isValid = try certificateManager.validateCertificate(
                for: hostname,
                certificate: certificate
            )
            
            // Log certificate validation
            try auditTrail.logEvent(.certificateValidated, details: [
                "hostname": hostname,
                "isValid": isValid
            ])
            
            return isValid
        }
    }
    
    /// Generate a compliance report for the specified standards
    ///
    /// - Parameters:
    ///   - standards: Array of compliance standards to include in the report
    ///   - dateRange: Date range for the report (optional)
    /// - Returns: Compliance report
    /// - Throws: `ComplianceError` if report generation fails
    public func generateComplianceReport(
        standards: [ComplianceStandard],
        dateRange: DateInterval? = nil
    ) throws -> ComplianceReport {
        return try securityQueue.sync {
            logger.info("Generating compliance report for standards: \(standards.map { $0.rawValue })")
            
            let report = try complianceEngine.generateReport(
                standards: standards,
                dateRange: dateRange ?? DateInterval(start: Date().addingTimeInterval(-86400*30), duration: 86400*30)
            )
            
            // Log compliance report generation
            try auditTrail.logEvent(.complianceReportGenerated, details: [
                "standards": standards.map { $0.rawValue },
                "dateRange": dateRange?.description ?? "default"
            ])
            
            return report
        }
    }
    
    /// Export audit trail in the specified format
    ///
    /// - Parameters:
    ///   - format: The export format (JSON, CSV, XML)
    ///   - includeSensitiveData: Whether to include sensitive data in export
    /// - Returns: Audit trail data
    /// - Throws: `AuditTrailError` if export fails
    public func exportAuditTrail(
        format: AuditTrailFormat = .json,
        includeSensitiveData: Bool = false
    ) throws -> Data {
        return try securityQueue.sync {
            logger.info("Exporting audit trail in format: \(format.rawValue)")
            
            let auditData = try auditTrail.export(
                format: format,
                includeSensitiveData: includeSensitiveData
            )
            
            // Log audit trail export
            try auditTrail.logEvent(.auditTrailExported, details: [
                "format": format.rawValue,
                "includeSensitiveData": includeSensitiveData
            ])
            
            return auditData
        }
    }
    
    /// Perform threat detection scan
    ///
    /// - Returns: Threat detection results
    /// - Throws: `ThreatDetectionError` if scan fails
    public func performThreatDetection() throws -> ThreatDetectionResult {
        return try securityQueue.sync {
            logger.info("Performing threat detection scan")
            
            let result = try threatDetector.performScan()
            
            // Update security status based on threat detection
            if result.threats.isEmpty {
                securityStatus = .secure
            } else {
                securityStatus = .threatDetected
            }
            
            // Log threat detection
            try auditTrail.logEvent(.threatDetectionPerformed, details: [
                "threatCount": result.threats.count,
                "status": securityStatus.rawValue
            ])
            
            return result
        }
    }
    
    /// Rotate encryption keys
    ///
    /// - Throws: `KeyManagementError` if key rotation fails
    public func rotateKeys() throws {
        try securityQueue.sync {
            logger.info("Rotating encryption keys")
            
            try keyManager.rotateKeys()
            
            // Log key rotation
            try auditTrail.logEvent(.keysRotated, details: [:])
        }
    }
    
    /// Get current security statistics
    ///
    /// - Returns: Security statistics
    public func getSecurityStatistics() -> SecurityStatistics {
        return securityQueue.sync {
            return SecurityStatistics(
                encryptionOperations: encryptionEngine.operationCount,
                certificateValidations: certificateManager.validationCount,
                complianceReports: complianceEngine.reportCount,
                threatDetections: threatDetector.scanCount,
                auditEvents: auditTrail.eventCount,
                securityLevel: currentSecurityLevel,
                securityStatus: securityStatus,
                performanceMetrics: performanceMetrics
            )
        }
    }
    
    // MARK: - Private Methods
    
    private func configureEncryptionEngine(for level: SecurityLevel) throws {
        let config = EncryptionConfiguration(level: level)
        try encryptionEngine.configure(config)
    }
    
    private func configureCertificateManager(for level: SecurityLevel) throws {
        let config = CertificateConfiguration(level: level)
        try certificateManager.configure(config)
    }
    
    private func configureComplianceEngine(for level: SecurityLevel) throws {
        let config = ComplianceConfiguration(level: level)
        try complianceEngine.configure(config)
    }
    
    private func configureThreatDetector(for level: SecurityLevel) throws {
        let config = ThreatDetectionConfiguration(level: level)
        try threatDetector.configure(config)
    }
    
    private func configureKeyManager(for level: SecurityLevel) throws {
        let config = KeyManagementConfiguration(level: level)
        try keyManager.configure(config)
    }
    
    private func configureAuditTrail(for level: SecurityLevel) throws {
        let config = AuditTrailConfiguration(level: level)
        try auditTrail.configure(config)
    }
    
    private func startBackgroundMonitoring() {
        // Start periodic threat detection
        Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] _ in
            Task {
                try? await self?.performBackgroundThreatDetection()
            }
        }
        
        // Start performance monitoring
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            Task {
                await self?.updatePerformanceMetrics()
            }
        }
    }
    
    private func performBackgroundThreatDetection() async throws {
        let result = try threatDetector.performBackgroundScan()
        
        if !result.threats.isEmpty {
            logger.warning("Background threat detection found \(result.threats.count) threats")
            securityStatus = .threatDetected
        }
    }
    
    private func updatePerformanceMetrics() async {
        performanceMetrics = PerformanceMetrics(
            memoryUsage: getCurrentMemoryUsage(),
            cpuUsage: getCurrentCPUUsage(),
            batteryImpact: getCurrentBatteryImpact(),
            encryptionSpeed: encryptionEngine.currentSpeed,
            certificateValidationSpeed: certificateManager.currentSpeed
        )
    }
    
    private func getCurrentMemoryUsage() -> Double {
        // Implementation for getting current memory usage
        return 0.0
    }
    
    private func getCurrentCPUUsage() -> Double {
        // Implementation for getting current CPU usage
        return 0.0
    }
    
    private func getCurrentBatteryImpact() -> Double {
        // Implementation for getting current battery impact
        return 0.0
    }
}

// MARK: - Supporting Types

/// Security levels for the Enterprise Security Manager
@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
public enum SecurityLevel: String, CaseIterable {
    case basic = "basic"
    case standard = "standard"
    case enterprise = "enterprise"
    case military = "military"
}

/// Security status of the framework
@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
public enum SecurityStatus: String {
    case initializing = "initializing"
    case configured = "configured"
    case secure = "secure"
    case threatDetected = "threat_detected"
    case compromised = "compromised"
    case error = "error"
}

/// Performance metrics for the security framework
@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
public struct PerformanceMetrics {
    public let memoryUsage: Double
    public let cpuUsage: Double
    public let batteryImpact: Double
    public let encryptionSpeed: Double
    public let certificateValidationSpeed: Double
    
    public init(
        memoryUsage: Double = 0.0,
        cpuUsage: Double = 0.0,
        batteryImpact: Double = 0.0,
        encryptionSpeed: Double = 0.0,
        certificateValidationSpeed: Double = 0.0
    ) {
        self.memoryUsage = memoryUsage
        self.cpuUsage = cpuUsage
        self.batteryImpact = batteryImpact
        self.encryptionSpeed = encryptionSpeed
        self.certificateValidationSpeed = certificateValidationSpeed
    }
}

/// Security statistics for monitoring
@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
public struct SecurityStatistics {
    public let encryptionOperations: Int
    public let certificateValidations: Int
    public let complianceReports: Int
    public let threatDetections: Int
    public let auditEvents: Int
    public let securityLevel: SecurityLevel
    public let securityStatus: SecurityStatus
    public let performanceMetrics: PerformanceMetrics
}

/// Security configuration for initialization
@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
public struct SecurityConfiguration {
    public let encryption: EncryptionConfiguration
    public let certificate: CertificateConfiguration
    public let compliance: ComplianceConfiguration
    public let threat: ThreatDetectionConfiguration
    public let keyManagement: KeyManagementConfiguration
    public let audit: AuditTrailConfiguration
    
    public init(
        encryption: EncryptionConfiguration = EncryptionConfiguration(),
        certificate: CertificateConfiguration = CertificateConfiguration(),
        compliance: ComplianceConfiguration = ComplianceConfiguration(),
        threat: ThreatDetectionConfiguration = ThreatDetectionConfiguration(),
        keyManagement: KeyManagementConfiguration = KeyManagementConfiguration(),
        audit: AuditTrailConfiguration = AuditTrailConfiguration()
    ) {
        self.encryption = encryption
        self.certificate = certificate
        self.compliance = compliance
        self.threat = threat
        self.keyManagement = keyManagement
        self.audit = audit
    }
}

// MARK: - Error Types

/// Errors that can occur during security operations
@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
public enum SecurityError: Error, LocalizedError {
    case initializationFailed(String)
    case configurationFailed(String)
    case encryptionFailed(String)
    case decryptionFailed(String)
    case certificateValidationFailed(String)
    case complianceReportFailed(String)
    case threatDetectionFailed(String)
    case keyManagementFailed(String)
    case auditTrailFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .initializationFailed(let message):
            return "Security initialization failed: \(message)"
        case .configurationFailed(let message):
            return "Security configuration failed: \(message)"
        case .encryptionFailed(let message):
            return "Encryption failed: \(message)"
        case .decryptionFailed(let message):
            return "Decryption failed: \(message)"
        case .certificateValidationFailed(let message):
            return "Certificate validation failed: \(message)"
        case .complianceReportFailed(let message):
            return "Compliance report failed: \(message)"
        case .threatDetectionFailed(let message):
            return "Threat detection failed: \(message)"
        case .keyManagementFailed(let message):
            return "Key management failed: \(message)"
        case .auditTrailFailed(let message):
            return "Audit trail failed: \(message)"
        }
    }
}

/// Configuration errors
@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
public enum SecurityConfigurationError: Error, LocalizedError {
    case invalidLevel(SecurityLevel)
    case invalidConfiguration(String)
    case componentInitializationFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidLevel(let level):
            return "Invalid security level: \(level.rawValue)"
        case .invalidConfiguration(let message):
            return "Invalid configuration: \(message)"
        case .componentInitializationFailed(let message):
            return "Component initialization failed: \(message)"
        }
    }
} 