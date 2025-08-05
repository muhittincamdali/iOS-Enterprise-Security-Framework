import Foundation
import EnterpriseSecurityFramework

/// Compliance Examples
/// This example demonstrates various compliance features including
/// GDPR, HIPAA, SOX, and general compliance management.
class ComplianceExample {
    
    // MARK: - Properties
    
    private let gdprCompliance = GDPRComplianceManager()
    private let hipaaCompliance = HIPAAComplianceManager()
    private let soxCompliance = SOXComplianceManager()
    private let complianceManager = ComplianceManager()
    private let consentManager = ConsentManagementManager()
    private let retentionManager = DataRetentionManager()
    
    // MARK: - Initialization
    
    init() {
        setupCompliance()
    }
    
    // MARK: - Setup
    
    private func setupCompliance() {
        // Configure GDPR compliance
        let gdprConfig = GDPRConfiguration()
        gdprConfig.enableDataProtection = true
        gdprConfig.enableConsentManagement = true
        gdprConfig.enableDataPortability = true
        gdprConfig.enableRightToErasure = true
        
        gdprCompliance.configure(gdprConfig)
        
        // Configure HIPAA compliance
        let hipaaConfig = HIPAAConfiguration()
        hipaaConfig.enablePHIProtection = true
        hipaaConfig.enableAccessControls = true
        hipaaConfig.enableAuditLogging = true
        hipaaConfig.enableEncryption = true
        
        hipaaCompliance.configure(hipaaConfig)
        
        // Configure SOX compliance
        let soxConfig = SOXConfiguration()
        soxConfig.enableFinancialDataProtection = true
        soxConfig.enableAccessControls = true
        soxConfig.enableAuditTrails = true
        soxConfig.enableDataRetention = true
        
        soxCompliance.configure(soxConfig)
    }
    
    // MARK: - GDPR Compliance
    
    /// Demonstrates GDPR compliance features
    func demonstrateGDPRCompliance() async {
        print("📋 Starting GDPR Compliance Example")
        
        let userId = "user@company.com"
        
        do {
            // Check GDPR compliance status
            let compliance = try await gdprCompliance.checkCompliance()
            
            print("✅ GDPR compliance check successful")
            print("   Data protection: \(compliance.dataProtection)")
            print("   Consent management: \(compliance.consentManagement)")
            print("   Data portability: \(compliance.dataPortability)")
            print("   Right to erasure: \(compliance.rightToErasure)")
            
            // Handle data subject request
            let response = try await gdprCompliance.handleDataSubjectRequest(
                request: .rightToErasure,
                userId: userId
            )
            
            print("✅ Data subject request handled")
            print("   Request type: \(response.requestType)")
            print("   Status: \(response.status)")
            print("   Completion time: \(response.completionTime)")
            
            // Export user data
            let userData = try await gdprCompliance.exportUserData(userId: userId)
            
            print("✅ User data exported")
            print("   Data size: \(userData.size) bytes")
            print("   Data types: \(userData.dataTypes)")
            
            // Anonymize user data
            try await gdprCompliance.anonymizeUserData(userId: userId)
            
            print("✅ User data anonymized")
            
        } catch GDPRError.dataProtectionViolation {
            print("❌ Data protection violation")
        } catch GDPRError.consentRequired {
            print("❌ Consent required")
        } catch GDPRError.auditFailure {
            print("❌ Audit failure")
        } catch {
            print("❌ GDPR compliance failed: \(error)")
        }
    }
    
    // MARK: - HIPAA Compliance
    
    /// Demonstrates HIPAA compliance features
    func demonstrateHIPAACompliance() async {
        print("📋 Starting HIPAA Compliance Example")
        
        let userId = "doctor@hospital.com"
        let phiData = "Patient medical record data"
        
        do {
            // Check HIPAA compliance status
            let compliance = try await hipaaCompliance.checkCompliance()
            
            print("✅ HIPAA compliance check successful")
            print("   PHI protection: \(compliance.phiProtection)")
            print("   Access controls: \(compliance.accessControls)")
            print("   Audit logging: \(compliance.auditLogging)")
            print("   Encryption: \(compliance.encryption)")
            
            // Protect PHI data
            try await hipaaCompliance.protectPHI(
                data: phiData,
                userId: userId,
                accessLevel: .authorized
            )
            
            print("✅ PHI data protected")
            
            // Log access to PHI
            try await hipaaCompliance.logPHIAccess(
                userId: userId,
                dataType: .medicalRecord,
                accessType: .read,
                timestamp: Date()
            )
            
            print("✅ PHI access logged")
            
            // Generate HIPAA report
            let report = try await hipaaCompliance.generateComplianceReport(period: .monthly)
            
            print("✅ HIPAA report generated")
            print("   Period: \(report.period)")
            print("   Total events: \(report.totalEvents)")
            print("   PHI accesses: \(report.phiAccesses)")
            
        } catch HIPAAError.phiViolation {
            print("❌ PHI violation detected")
        } catch HIPAAError.unauthorizedAccess {
            print("❌ Unauthorized access")
        } catch HIPAAError.auditFailure {
            print("❌ Audit failure")
        } catch {
            print("❌ HIPAA compliance failed: \(error)")
        }
    }
    
    // MARK: - SOX Compliance
    
    /// Demonstrates SOX compliance features
    func demonstrateSOXCompliance() async {
        print("📋 Starting SOX Compliance Example")
        
        let userId = "accountant@company.com"
        let financialData = "Financial transaction data"
        
        do {
            // Check SOX compliance status
            let compliance = try await soxCompliance.checkCompliance()
            
            print("✅ SOX compliance check successful")
            print("   Financial data protection: \(compliance.financialDataProtection)")
            print("   Access controls: \(compliance.accessControls)")
            print("   Audit trails: \(compliance.auditTrails)")
            print("   Data retention: \(compliance.dataRetention)")
            
            // Protect financial data
            try await soxCompliance.protectFinancialData(
                data: financialData,
                userId: userId,
                accessLevel: .authorized
            )
            
            print("✅ Financial data protected")
            
            // Create audit trail
            try await soxCompliance.createAuditTrail(
                action: .financialDataAccess,
                userId: userId,
                timestamp: Date(),
                details: ["amount": "1000", "account": "12345"]
            )
            
            print("✅ Audit trail created")
            
            // Generate SOX report
            let report = try await soxCompliance.generateComplianceReport(period: .quarterly)
            
            print("✅ SOX report generated")
            print("   Period: \(report.period)")
            print("   Total events: \(report.totalEvents)")
            print("   Financial accesses: \(report.financialAccesses)")
            
        } catch SOXError.financialDataViolation {
            print("❌ Financial data violation")
        } catch SOXError.unauthorizedAccess {
            print("❌ Unauthorized access")
        } catch SOXError.auditFailure {
            print("❌ Audit failure")
        } catch {
            print("❌ SOX compliance failed: \(error)")
        }
    }
    
    // MARK: - Consent Management
    
    /// Demonstrates consent management features
    func demonstrateConsentManagement() async {
        print("📋 Starting Consent Management Example")
        
        let userId = "user@company.com"
        
        do {
            // Record user consent
            try await consentManager.recordConsent(
                userId: userId,
                consentType: .dataProcessing,
                granted: true,
                timestamp: Date(),
                version: "1.0"
            )
            
            print("✅ User consent recorded")
            
            // Check consent status
            let consentStatus = try await consentManager.checkConsentStatus(
                userId: userId,
                consentType: .dataProcessing
            )
            
            print("✅ Consent status checked")
            print("   Granted: \(consentStatus.granted)")
            print("   Timestamp: \(consentStatus.timestamp)")
            print("   Version: \(consentStatus.version)")
            
            // Withdraw consent
            try await consentManager.withdrawConsent(
                userId: userId,
                consentType: .dataProcessing,
                timestamp: Date()
            )
            
            print("✅ Consent withdrawn")
            
            // Get consent history
            let consentHistory = try await consentManager.getConsentHistory(userId: userId)
            
            print("✅ Consent history retrieved")
            print("   Total consents: \(consentHistory.count)")
            
        } catch ConsentError.consentNotFound {
            print("❌ Consent not found")
        } catch ConsentError.invalidConsent {
            print("❌ Invalid consent")
        } catch {
            print("❌ Consent management failed: \(error)")
        }
    }
    
    // MARK: - Data Retention
    
    /// Demonstrates data retention features
    func demonstrateDataRetention() async {
        print("📋 Starting Data Retention Example")
        
        do {
            // Set retention policy
            try await retentionManager.setRetentionPolicy(
                dataType: .userData,
                retentionPeriod: 365, // days
                policy: .deleteAfterPeriod
            )
            
            print("✅ Retention policy set")
            
            // Check data retention status
            let retentionStatus = try await retentionManager.checkRetentionStatus(dataType: .userData)
            
            print("✅ Retention status checked")
            print("   Policy: \(retentionStatus.policy)")
            print("   Period: \(retentionStatus.period) days")
            print("   Expired: \(retentionStatus.expired)")
            
            // Clean up expired data
            let cleanedData = try await retentionManager.cleanupExpiredData()
            
            print("✅ Expired data cleaned up")
            print("   Cleaned records: \(cleanedData.count)")
            
            // Archive data
            try await retentionManager.archiveData(
                dataType: .userData,
                archiveLocation: "/secure/archive"
            )
            
            print("✅ Data archived")
            
        } catch RetentionError.policyNotFound {
            print("❌ Retention policy not found")
        } catch RetentionError.archiveFailed {
            print("❌ Archive failed")
        } catch {
            print("❌ Data retention failed: \(error)")
        }
    }
    
    // MARK: - General Compliance
    
    /// Demonstrates general compliance features
    func demonstrateGeneralCompliance() async {
        print("📋 Starting General Compliance Example")
        
        do {
            // Check overall compliance
            let overallCompliance = try await complianceManager.checkOverallCompliance()
            
            print("✅ Overall compliance check successful")
            print("   GDPR compliant: \(overallCompliance.gdprCompliant)")
            print("   HIPAA compliant: \(overallCompliance.hipaaCompliant)")
            print("   SOX compliant: \(overallCompliance.soxCompliant)")
            
            // Generate compliance report
            let report = try await complianceManager.generateComplianceReport(
                period: .monthly,
                includeDetails: true
            )
            
            print("✅ Compliance report generated")
            print("   Period: \(report.period)")
            print("   Total violations: \(report.totalViolations)")
            print("   Compliance score: \(report.complianceScore)%")
            
            // Handle compliance violation
            try await complianceManager.handleComplianceViolation(
                violation: .dataBreach,
                severity: .high,
                description: "Unauthorized access detected"
            )
            
            print("✅ Compliance violation handled")
            
        } catch ComplianceError.violationDetected {
            print("❌ Compliance violation detected")
        } catch ComplianceError.reportFailed {
            print("❌ Report generation failed")
        } catch {
            print("❌ General compliance failed: \(error)")
        }
    }
}

// MARK: - Supporting Types

enum GDPRError: Error {
    case dataProtectionViolation
    case consentRequired
    case auditFailure
}

enum HIPAAError: Error {
    case phiViolation
    case unauthorizedAccess
    case auditFailure
}

enum SOXError: Error {
    case financialDataViolation
    case unauthorizedAccess
    case auditFailure
}

enum ConsentError: Error {
    case consentNotFound
    case invalidConsent
}

enum RetentionError: Error {
    case policyNotFound
    case archiveFailed
}

enum ComplianceError: Error {
    case violationDetected
    case reportFailed
}

// MARK: - Usage Example

@main
struct ComplianceExampleApp {
    static func main() async {
        let example = ComplianceExample()
        
        // Run compliance examples
        await example.demonstrateGDPRCompliance()
        await example.demonstrateHIPAACompliance()
        await example.demonstrateSOXCompliance()
        await example.demonstrateConsentManagement()
        await example.demonstrateDataRetention()
        await example.demonstrateGeneralCompliance()
        
        print("✅ Compliance Example Completed")
    }
} 