//
//  SecurityManagerTests.swift
//  iOS-Enterprise-Security-Framework
//
//  Created by Muhittin Camdali on 2024-01-15
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import XCTest
import Testing
@testable import EnterpriseSecurity

final class SecurityManagerTests: XCTestCase {
    
    var securityManager: EnterpriseSecurityManager!
    var mockEncryptionEngine: MockEncryptionEngine!
    var mockCertificateManager: MockCertificateManager!
    var mockComplianceEngine: MockComplianceEngine!
    var mockThreatDetector: MockThreatDetector!
    var mockKeyManager: MockKeyManager!
    var mockAuditTrail: MockAuditTrail!
    
    override func setUp() {
        super.setUp()
        mockEncryptionEngine = MockEncryptionEngine()
        mockCertificateManager = MockCertificateManager()
        mockComplianceEngine = MockComplianceEngine()
        mockThreatDetector = MockThreatDetector()
        mockKeyManager = MockKeyManager()
        mockAuditTrail = MockAuditTrail()
        
        securityManager = EnterpriseSecurityManager(
            encryptionEngine: mockEncryptionEngine,
            certificateManager: mockCertificateManager,
            complianceEngine: mockComplianceEngine,
            threatDetector: mockThreatDetector,
            keyManager: mockKeyManager,
            auditTrail: mockAuditTrail
        )
    }
    
    override func tearDown() {
        securityManager = nil
        mockEncryptionEngine = nil
        mockCertificateManager = nil
        mockComplianceEngine = nil
        mockThreatDetector = nil
        mockKeyManager = nil
        mockAuditTrail = nil
        super.tearDown()
    }
    
    // MARK: - Configuration Tests
    
    func testConfigureWithEnterpriseLevel() throws {
        // Given
        let expectedLevel = SecurityLevel.enterprise
        
        // When
        try securityManager.configure(level: expectedLevel)
        
        // Then
        XCTAssertEqual(securityManager.currentSecurityLevel, expectedLevel)
        XCTAssertEqual(securityManager.securityStatus, .configured)
        XCTAssertEqual(mockEncryptionEngine.configuredLevel, expectedLevel)
        XCTAssertEqual(mockCertificateManager.configuredLevel, expectedLevel)
        XCTAssertEqual(mockComplianceEngine.configuredLevel, expectedLevel)
        XCTAssertEqual(mockThreatDetector.configuredLevel, expectedLevel)
        XCTAssertEqual(mockKeyManager.configuredLevel, expectedLevel)
        XCTAssertEqual(mockAuditTrail.configuredLevel, expectedLevel)
    }
    
    func testConfigureWithMilitaryLevel() throws {
        // Given
        let expectedLevel = SecurityLevel.military
        
        // When
        try securityManager.configure(level: expectedLevel)
        
        // Then
        XCTAssertEqual(securityManager.currentSecurityLevel, expectedLevel)
        XCTAssertEqual(securityManager.securityStatus, .configured)
    }
    
    func testConfigureWithInvalidLevel() {
        // Given
        let invalidLevel = SecurityLevel.basic
        
        // When & Then
        XCTAssertThrowsError(try securityManager.configure(level: invalidLevel)) { error in
            XCTAssertEqual(error as? SecurityConfigurationError, .invalidLevel(invalidLevel))
        }
    }
    
    // MARK: - Encryption Tests
    
    func testEncryptDataSuccessfully() throws {
        // Given
        let testData = "Test sensitive data".data(using: .utf8)!
        let expectedEncryptedData = EncryptedData(
            data: Data(),
            algorithm: .aes256Gcm,
            keySize: .bits256,
            nonce: Data(),
            tag: nil,
            timestamp: Date()
        )
        mockEncryptionEngine.mockEncryptedData = expectedEncryptedData
        
        // When
        let result = try securityManager.encrypt(data: testData, algorithm: .aes256Gcm)
        
        // Then
        XCTAssertEqual(result.algorithm, .aes256Gcm)
        XCTAssertEqual(result.keySize, .bits256)
        XCTAssertNotNil(result.timestamp)
    }
    
    func testDecryptDataSuccessfully() throws {
        // Given
        let testEncryptedData = EncryptedData(
            data: Data(),
            algorithm: .aes256Gcm,
            keySize: .bits256,
            nonce: Data(),
            tag: nil,
            timestamp: Date()
        )
        let expectedDecryptedData = "Decrypted test data".data(using: .utf8)!
        mockEncryptionEngine.mockDecryptedData = expectedDecryptedData
        
        // When
        let result = try securityManager.decrypt(testEncryptedData)
        
        // Then
        XCTAssertEqual(result, expectedDecryptedData)
    }
    
    func testEncryptDataWithInvalidInput() {
        // Given
        let emptyData = Data()
        
        // When & Then
        XCTAssertThrowsError(try securityManager.encrypt(data: emptyData)) { error in
            XCTAssertEqual(error as? EncryptionError, .invalidInput("Data cannot be empty"))
        }
    }
    
    // MARK: - Certificate Management Tests
    
    func testConfigureCertificatePinningSuccessfully() throws {
        // Given
        let certificates = [
            "api.enterprise.com": "sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=",
            "cdn.enterprise.com": "sha256/BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB="
        ]
        let updateInterval = CertificateUpdateInterval.daily
        
        // When
        try securityManager.configureCertificatePinning(
            certificates: certificates,
            updateInterval: updateInterval
        )
        
        // Then
        XCTAssertTrue(mockCertificateManager.pinningConfigured)
        XCTAssertEqual(mockCertificateManager.configuredCertificates, certificates)
        XCTAssertEqual(mockCertificateManager.configuredUpdateInterval, updateInterval)
    }
    
    func testValidateCertificateSuccessfully() throws {
        // Given
        let hostname = "api.enterprise.com"
        let certificate = SecCertificate()
        mockCertificateManager.mockValidationResult = true
        
        // When
        let result = try securityManager.validateCertificate(for: hostname, certificate: certificate)
        
        // Then
        XCTAssertTrue(result)
        XCTAssertEqual(mockCertificateManager.validatedHostname, hostname)
    }
    
    func testValidateCertificateWithInvalidHostname() {
        // Given
        let invalidHostname = ""
        let certificate = SecCertificate()
        
        // When & Then
        XCTAssertThrowsError(try securityManager.validateCertificate(for: invalidHostname, certificate: certificate)) { error in
            XCTAssertEqual(error as? CertificateError, .invalidInput("Hostname cannot be empty"))
        }
    }
    
    // MARK: - Compliance Tests
    
    func testGenerateComplianceReportSuccessfully() throws {
        // Given
        let standards = [ComplianceStandard.gdpr, ComplianceStandard.hipaa]
        let dateRange = DateInterval(start: Date().addingTimeInterval(-86400*30), duration: 86400*30)
        let expectedReport = ComplianceReport(
            standards: standards,
            dateRange: dateRange,
            data: [:],
            timestamp: Date(),
            signature: Data()
        )
        mockComplianceEngine.mockReport = expectedReport
        
        // When
        let result = try securityManager.generateComplianceReport(
            standards: standards,
            dateRange: dateRange
        )
        
        // Then
        XCTAssertEqual(result.standards, standards)
        XCTAssertEqual(result.dateRange, dateRange)
        XCTAssertEqual(mockComplianceEngine.requestedStandards, standards)
    }
    
    func testExportAuditTrailSuccessfully() throws {
        // Given
        let format = AuditTrailFormat.json
        let includeSensitiveData = false
        let expectedData = "Audit trail data".data(using: .utf8)!
        mockAuditTrail.mockExportData = expectedData
        
        // When
        let result = try securityManager.exportAuditTrail(
            format: format,
            includeSensitiveData: includeSensitiveData
        )
        
        // Then
        XCTAssertEqual(result, expectedData)
        XCTAssertEqual(mockAuditTrail.exportedFormat, format)
        XCTAssertEqual(mockAuditTrail.exportedIncludeSensitiveData, includeSensitiveData)
    }
    
    // MARK: - Threat Detection Tests
    
    func testPerformThreatDetectionSuccessfully() throws {
        // Given
        let expectedResult = ThreatDetectionResult(
            threats: [],
            status: .secure,
            timestamp: Date()
        )
        mockThreatDetector.mockResult = expectedResult
        
        // When
        let result = try securityManager.performThreatDetection()
        
        // Then
        XCTAssertEqual(result.threats.count, 0)
        XCTAssertEqual(result.status, .secure)
        XCTAssertEqual(securityManager.securityStatus, .secure)
    }
    
    func testPerformThreatDetectionWithThreats() throws {
        // Given
        let threats = [
            Threat(type: .jailbreak, severity: .high, description: "Jailbreak detected")
        ]
        let expectedResult = ThreatDetectionResult(
            threats: threats,
            status: .threatDetected,
            timestamp: Date()
        )
        mockThreatDetector.mockResult = expectedResult
        
        // When
        let result = try securityManager.performThreatDetection()
        
        // Then
        XCTAssertEqual(result.threats.count, 1)
        XCTAssertEqual(result.status, .threatDetected)
        XCTAssertEqual(securityManager.securityStatus, .threatDetected)
    }
    
    // MARK: - Key Management Tests
    
    func testRotateKeysSuccessfully() throws {
        // When
        try securityManager.rotateKeys()
        
        // Then
        XCTAssertTrue(mockKeyManager.keysRotated)
    }
    
    // MARK: - Statistics Tests
    
    func testGetSecurityStatistics() {
        // Given
        mockEncryptionEngine.operationCount = 100
        mockCertificateManager.validationCount = 50
        mockComplianceEngine.reportCount = 10
        mockThreatDetector.scanCount = 25
        mockAuditTrail.eventCount = 200
        
        // When
        let statistics = securityManager.getSecurityStatistics()
        
        // Then
        XCTAssertEqual(statistics.encryptionOperations, 100)
        XCTAssertEqual(statistics.certificateValidations, 50)
        XCTAssertEqual(statistics.complianceReports, 10)
        XCTAssertEqual(statistics.threatDetections, 25)
        XCTAssertEqual(statistics.auditEvents, 200)
        XCTAssertEqual(statistics.securityLevel, securityManager.currentSecurityLevel)
        XCTAssertEqual(statistics.securityStatus, securityManager.securityStatus)
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceEncryption() {
        measure {
            let testData = "Performance test data".data(using: .utf8)!
            try? securityManager.encrypt(data: testData, algorithm: .aes256Gcm)
        }
    }
    
    func testPerformanceDecryption() {
        measure {
            let testEncryptedData = EncryptedData(
                data: Data(),
                algorithm: .aes256Gcm,
                keySize: .bits256,
                nonce: Data(),
                tag: nil,
                timestamp: Date()
            )
            try? securityManager.decrypt(testEncryptedData)
        }
    }
    
    func testPerformanceCertificateValidation() {
        measure {
            let hostname = "api.enterprise.com"
            let certificate = SecCertificate()
            try? securityManager.validateCertificate(for: hostname, certificate: certificate)
        }
    }
}

// MARK: - Mock Classes

class MockEncryptionEngine: EncryptionEngineProtocol {
    var configuredLevel: SecurityLevel?
    var mockEncryptedData: EncryptedData?
    var mockDecryptedData: Data?
    var operationCount: Int = 0
    
    func configure(_ configuration: EncryptionConfiguration) throws {
        configuredLevel = configuration.level
    }
    
    func encrypt(data: Data, algorithm: EncryptionAlgorithm, keySize: KeySize) throws -> EncryptedData {
        operationCount += 1
        return mockEncryptedData ?? EncryptedData(
            data: Data(),
            algorithm: algorithm,
            keySize: keySize,
            nonce: Data(),
            tag: nil,
            timestamp: Date()
        )
    }
    
    func decrypt(_ encryptedData: EncryptedData) throws -> Data {
        operationCount += 1
        return mockDecryptedData ?? Data()
    }
}

class MockCertificateManager: CertificateManagerProtocol {
    var configuredLevel: SecurityLevel?
    var pinningConfigured = false
    var configuredCertificates: [String: String] = [:]
    var configuredUpdateInterval: CertificateUpdateInterval?
    var validatedHostname: String?
    var validationCount: Int = 0
    var currentSpeed: Double = 0.0
    
    func configure(_ configuration: CertificateConfiguration) throws {
        configuredLevel = configuration.level
    }
    
    func configurePinning(certificates: [String: String], updateInterval: CertificateUpdateInterval) throws {
        pinningConfigured = true
        configuredCertificates = certificates
        configuredUpdateInterval = updateInterval
    }
    
    func validateCertificate(for hostname: String, certificate: SecCertificate) throws -> Bool {
        validationCount += 1
        validatedHostname = hostname
        return true
    }
}

class MockComplianceEngine: ComplianceEngineProtocol {
    var configuredLevel: SecurityLevel?
    var mockReport: ComplianceReport?
    var requestedStandards: [ComplianceStandard] = []
    var reportCount: Int = 0
    
    func configure(_ configuration: ComplianceConfiguration) throws {
        configuredLevel = configuration.level
    }
    
    func generateReport(standards: [ComplianceStandard], dateRange: DateInterval) throws -> ComplianceReport {
        reportCount += 1
        requestedStandards = standards
        return mockReport ?? ComplianceReport(
            standards: standards,
            dateRange: dateRange,
            data: [:],
            timestamp: Date(),
            signature: Data()
        )
    }
}

class MockThreatDetector: ThreatDetectorProtocol {
    var configuredLevel: SecurityLevel?
    var mockResult: ThreatDetectionResult?
    var scanCount: Int = 0
    
    func configure(_ configuration: ThreatDetectionConfiguration) throws {
        configuredLevel = configuration.level
    }
    
    func performScan() throws -> ThreatDetectionResult {
        scanCount += 1
        return mockResult ?? ThreatDetectionResult(
            threats: [],
            status: .secure,
            timestamp: Date()
        )
    }
}

class MockKeyManager: KeyManagerProtocol {
    var configuredLevel: SecurityLevel?
    var keysRotated = false
    
    func configure(_ configuration: KeyManagementConfiguration) throws {
        configuredLevel = configuration.level
    }
    
    func rotateKeys() throws {
        keysRotated = true
    }
}

class MockAuditTrail: AuditTrailProtocol {
    var configuredLevel: SecurityLevel?
    var mockExportData: Data?
    var exportedFormat: AuditTrailFormat?
    var exportedIncludeSensitiveData: Bool?
    var eventCount: Int = 0
    
    func configure(_ configuration: AuditTrailConfiguration) throws {
        configuredLevel = configuration.level
    }
    
    func export(format: AuditTrailFormat, includeSensitiveData: Bool) throws -> Data {
        exportedFormat = format
        exportedIncludeSensitiveData = includeSensitiveData
        return mockExportData ?? Data()
    }
    
    func logEvent(_ event: AuditEvent, details: [String: Any]) throws {
        eventCount += 1
    }
}

// MARK: - Supporting Types

struct ThreatDetectionResult {
    let threats: [Threat]
    let status: SecurityStatus
    let timestamp: Date
}

struct Threat {
    let type: ThreatType
    let severity: ThreatSeverity
    let description: String
}

enum ThreatType {
    case jailbreak
    case debugger
    case certificateTampering
    case manInTheMiddle
}

enum ThreatSeverity {
    case low
    case medium
    case high
    case critical
}

// MARK: - Protocols

protocol EncryptionEngineProtocol {
    func configure(_ configuration: EncryptionConfiguration) throws
    func encrypt(data: Data, algorithm: EncryptionAlgorithm, keySize: KeySize) throws -> EncryptedData
    func decrypt(_ encryptedData: EncryptedData) throws -> Data
}

protocol CertificateManagerProtocol {
    func configure(_ configuration: CertificateConfiguration) throws
    func configurePinning(certificates: [String: String], updateInterval: CertificateUpdateInterval) throws
    func validateCertificate(for hostname: String, certificate: SecCertificate) throws -> Bool
}

protocol ComplianceEngineProtocol {
    func configure(_ configuration: ComplianceConfiguration) throws
    func generateReport(standards: [ComplianceStandard], dateRange: DateInterval) throws -> ComplianceReport
}

protocol ThreatDetectorProtocol {
    func configure(_ configuration: ThreatDetectionConfiguration) throws
    func performScan() throws -> ThreatDetectionResult
}

protocol KeyManagerProtocol {
    func configure(_ configuration: KeyManagementConfiguration) throws
    func rotateKeys() throws
}

protocol AuditTrailProtocol {
    func configure(_ configuration: AuditTrailConfiguration) throws
    func export(format: AuditTrailFormat, includeSensitiveData: Bool) throws -> Data
    func logEvent(_ event: AuditEvent, details: [String: Any]) throws
} 