# Compliance API

## Overview

The Compliance API provides comprehensive compliance management for enterprise iOS applications. It supports GDPR, HIPAA, SOX, and other regulatory compliance requirements with automated compliance checking and reporting.

## Core Components

### GDPRComplianceManager

Manages GDPR (General Data Protection Regulation) compliance requirements.

```swift
import EnterpriseSecurityFramework

// Initialize GDPR compliance manager
let gdprCompliance = GDPRComplianceManager()

// Configure GDPR compliance
let gdprConfig = GDPRConfiguration()
gdprConfig.enableDataProtection = true
gdprConfig.enableConsentManagement = true
gdprConfig.enableDataPortability = true
gdprConfig.enableRightToErasure = true

// Check GDPR compliance
let compliance = await gdprCompliance.checkCompliance(configuration: gdprConfig)
```

### HIPAAComplianceManager

Handles HIPAA (Health Insurance Portability and Accountability Act) compliance.

```swift
// Initialize HIPAA compliance manager
let hipaaCompliance = HIPAAComplianceManager()

// Configure HIPAA compliance
let hipaaConfig = HIPAAConfiguration()
hipaaConfig.enablePHIProtection = true
hipaaConfig.enableAccessControls = true
hipaaConfig.enableAuditLogging = true
hipaaConfig.enableEncryption = true

// Check HIPAA compliance
let compliance = await hipaaCompliance.checkCompliance(configuration: hipaaConfig)
```

### SOXComplianceManager

Manages SOX (Sarbanes-Oxley Act) compliance for financial data.

```swift
// Initialize SOX compliance manager
let soxCompliance = SOXComplianceManager()

// Configure SOX compliance
let soxConfig = SOXConfiguration()
soxConfig.enableFinancialDataProtection = true
soxConfig.enableAccessControls = true
soxConfig.enableAuditTrails = true
soxConfig.enableDataRetention = true

// Check SOX compliance
let compliance = await soxCompliance.checkCompliance(configuration: soxConfig)
```

## API Reference

### GDPR Compliance

```swift
// Check GDPR compliance status
let compliance = await gdprCompliance.checkCompliance(configuration: gdprConfig)
print("Data protection: \(compliance.dataProtection)")
print("Consent management: \(compliance.consentManagement)")
print("Data portability: \(compliance.dataPortability)")
print("Right to erasure: \(compliance.rightToErasure)")

// Handle data subject request
let response = await gdprCompliance.handleDataSubjectRequest(
    request: .rightToErasure,
    userId: userId
)
print("Request type: \(response.requestType)")
print("Status: \(response.status)")
print("Completion time: \(response.completionTime)")

// Manage consent
await gdprCompliance.manageConsent(
    userId: userId,
    consentType: .dataProcessing,
    granted: true,
    timestamp: Date()
)

// Export user data
let userData = await gdprCompliance.exportUserData(userId: userId)

// Anonymize user data
await gdprCompliance.anonymizeUserData(userId: userId)
```

### HIPAA Compliance

```swift
// Check HIPAA compliance status
let compliance = await hipaaCompliance.checkCompliance(configuration: hipaaConfig)
print("PHI protection: \(compliance.phiProtection)")
print("Access controls: \(compliance.accessControls)")
print("Audit logging: \(compliance.auditLogging)")
print("Encryption: \(compliance.encryption)")

// Protect PHI data
await hipaaCompliance.protectPHI(
    data: phiData,
    userId: userId,
    accessLevel: .authorized
)

// Log access to PHI
await hipaaCompliance.logPHIAccess(
    userId: userId,
    dataType: .medicalRecord,
    accessType: .read,
    timestamp: Date()
)

// Generate HIPAA report
let report = await hipaaCompliance.generateComplianceReport(period: .monthly)
```

### SOX Compliance

```swift
// Check SOX compliance status
let compliance = await soxCompliance.checkCompliance(configuration: soxConfig)
print("Financial data protection: \(compliance.financialDataProtection)")
print("Access controls: \(compliance.accessControls)")
print("Audit trails: \(compliance.auditTrails)")
print("Data retention: \(compliance.dataRetention)")

// Protect financial data
await soxCompliance.protectFinancialData(
    data: financialData,
    userId: userId,
    accessLevel: .authorized
)

// Create audit trail
await soxCompliance.createAuditTrail(
    action: .financialDataAccess,
    userId: userId,
    timestamp: Date(),
    details: ["amount": "1000", "account": "12345"]
)

// Generate SOX report
let report = await soxCompliance.generateComplianceReport(period: .quarterly)
```

### General Compliance

```swift
// Initialize general compliance manager
let complianceManager = ComplianceManager()

// Check overall compliance
let overallCompliance = await complianceManager.checkOverallCompliance()
print("GDPR compliance: \(overallCompliance.gdprCompliant)")
print("HIPAA compliance: \(overallCompliance.hipaaCompliant)")
print("SOX compliance: \(overallCompliance.soxCompliant)")

// Generate compliance report
let report = await complianceManager.generateComplianceReport(
    period: .monthly,
    includeDetails: true
)

// Handle compliance violations
await complianceManager.handleComplianceViolation(
    violation: .dataBreach,
    severity: .high,
    description: "Unauthorized access detected"
)
```

### Consent Management

```swift
// Initialize consent manager
let consentManager = ConsentManagementManager()

// Record user consent
await consentManager.recordConsent(
    userId: userId,
    consentType: .dataProcessing,
    granted: true,
    timestamp: Date(),
    version: "1.0"
)

// Check consent status
let consentStatus = await consentManager.checkConsentStatus(
    userId: userId,
    consentType: .dataProcessing
)

// Withdraw consent
await consentManager.withdrawConsent(
    userId: userId,
    consentType: .dataProcessing,
    timestamp: Date()
)

// Get consent history
let consentHistory = await consentManager.getConsentHistory(userId: userId)
```

### Data Retention

```swift
// Initialize data retention manager
let retentionManager = DataRetentionManager()

// Set retention policy
await retentionManager.setRetentionPolicy(
    dataType: .userData,
    retentionPeriod: 365, // days
    policy: .deleteAfterPeriod
)

// Check data retention status
let retentionStatus = await retentionManager.checkRetentionStatus(dataType: .userData)

// Clean up expired data
let cleanedData = await retentionManager.cleanupExpiredData()

// Archive data
await retentionManager.archiveData(
    dataType: .userData,
    archiveLocation: "/secure/archive"
)
```

## Error Handling

```swift
do {
    let compliance = try await gdprCompliance.checkCompliance(configuration: gdprConfig)
} catch ComplianceError.dataProtectionViolation {
    // Handle data protection violation
} catch ComplianceError.consentRequired {
    // Handle missing consent
} catch ComplianceError.auditFailure {
    // Handle audit failure
} catch ComplianceError.retentionViolation {
    // Handle retention policy violation
} catch {
    // Handle other compliance errors
}
```

## Best Practices

1. **Regularly check compliance status**
2. **Implement proper consent management**
3. **Log all data access events**
4. **Use secure data storage**
5. **Implement data retention policies**
6. **Generate regular compliance reports**
7. **Handle data subject requests promptly**
8. **Monitor compliance violations**

## Security Considerations

- Implement proper access controls
- Use encryption for sensitive data
- Log all compliance-related events
- Implement data retention policies
- Handle data subject requests securely
- Monitor compliance violations
- Use secure communication channels
- Implement proper audit trails

## Examples

See the [Compliance Examples](../Examples/ComplianceExamples/) directory for complete implementation examples.

## Related Documentation

- [Security Manager API](SecurityManagerAPI.md)
- [Authentication API](AuthenticationAPI.md)
- [Encryption API](EncryptionAPI.md)
- [Audit API](AuditAPI.md)
- [Compliance Guide](ComplianceGuide.md)
- [Getting Started Guide](GettingStarted.md)
