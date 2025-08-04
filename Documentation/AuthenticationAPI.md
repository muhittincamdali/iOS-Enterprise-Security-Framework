# Authentication API

## Overview

The Authentication API provides comprehensive authentication capabilities for enterprise iOS applications. It supports multiple authentication methods including biometric, certificate, token-based, and multi-factor authentication.

## Core Components

### BiometricAuthenticationManager

Manages biometric authentication using Face ID, Touch ID, and custom biometric methods.

```swift
import EnterpriseSecurityFramework

// Initialize biometric authentication
let biometricAuth = BiometricAuthenticationManager()

// Configure biometric settings
let biometricConfig = BiometricConfiguration()
biometricConfig.enableFaceID = true
biometricConfig.enableTouchID = true
biometricConfig.enableCustomBiometric = true
biometricConfig.fallbackToPasscode = true

// Check biometric availability
let availability = await biometricAuth.checkBiometricAvailability()
```

### CertificateAuthenticationManager

Handles certificate-based authentication using PKI and client certificates.

```swift
// Initialize certificate authentication
let certificateAuth = CertificateAuthenticationManager()

// Configure certificate settings
let certificateConfig = CertificateConfiguration()
certificateConfig.enablePKI = true
certificateConfig.enableClientCertificates = true
certificateConfig.enableCertificatePinning = true
certificateConfig.trustedCAs = ["ca1", "ca2", "ca3"]

// Validate certificate
let validation = await certificateAuth.validateCertificate(certificate)
```

### MultiFactorAuthenticationManager

Manages multi-factor authentication with SMS, email, and hardware tokens.

```swift
// Initialize MFA manager
let mfaAuth = MultiFactorAuthenticationManager()

// Configure MFA settings
let mfaConfig = MFAConfiguration()
mfaConfig.enableSMS = true
mfaConfig.enableEmail = true
mfaConfig.enableHardwareToken = true
mfaConfig.enableAppToken = true
mfaConfig.requireMFA = true

// Setup MFA for user
let setup = await mfaAuth.setupMFA(for: userId, configuration: mfaConfig)
```

## API Reference

### Biometric Authentication

```swift
// Check biometric availability
let availability = await biometricAuth.checkBiometricAvailability()
if availability.faceIDAvailable {
    print("Face ID is available")
}

// Authenticate with biometric
let result = await biometricAuth.authenticate(reason: "Access secure data")
switch result {
case .success:
    print("Biometric authentication successful")
case .failure(let error):
    print("Biometric authentication failed: \(error)")
}

// Register biometric
let registration = await biometricAuth.registerBiometric(
    userId: userId,
    biometricType: .faceID
)

// Deregister biometric
await biometricAuth.deregisterBiometric(userId: userId)
```

### Certificate Authentication

```swift
// Validate certificate
let validation = await certificateAuth.validateCertificate(certificate)
if validation.isValid {
    print("Certificate is valid")
    print("Issuer: \(validation.issuer)")
    print("Subject: \(validation.subject)")
    print("Expiry: \(validation.expiryDate)")
}

// Authenticate with certificate
let authResult = await certificateAuth.authenticateWithCertificate(certificate)
if case .success(let user) = authResult {
    print("Certificate authentication successful")
    print("User: \(user.username)")
    print("Permissions: \(user.permissions)")
}

// Install certificate
await certificateAuth.installCertificate(certificateData)

// Remove certificate
await certificateAuth.removeCertificate(certificateId)
```

### Multi-Factor Authentication

```swift
// Setup MFA for user
let setup = await mfaAuth.setupMFA(for: userId, configuration: mfaConfig)
print("SMS enabled: \(setup.smsEnabled)")
print("Email enabled: \(setup.emailEnabled)")
print("Hardware token: \(setup.hardwareTokenEnabled)")

// Authenticate with MFA
let authResult = await mfaAuth.authenticateWithMFA(
    userId: userId,
    primaryFactor: .password,
    secondaryFactor: .sms
)

// Send verification code
await mfaAuth.sendVerificationCode(
    userId: userId,
    method: .sms,
    phoneNumber: "+1234567890"
)

// Verify code
let verification = await mfaAuth.verifyCode(
    userId: userId,
    code: "123456"
)
```

### Token Authentication

```swift
// Initialize token authentication
let tokenAuth = TokenAuthenticationManager()

// Authenticate with JWT token
let jwtResult = await tokenAuth.authenticateWithJWT(jwtToken)

// Authenticate with OAuth token
let oauthResult = await tokenAuth.authenticateWithOAuth(oauthToken)

// Refresh token
let refreshResult = await tokenAuth.refreshToken(refreshToken)

// Validate token
let validation = await tokenAuth.validateToken(token)
```

### Session Management

```swift
// Create session
let session = await authManager.createSession(userId: userId)

// Validate session
let isValid = await authManager.validateSession(sessionId)

// Extend session
await authManager.extendSession(sessionId, duration: 3600)

// Terminate session
await authManager.terminateSession(sessionId)

// Get active sessions
let activeSessions = await authManager.getActiveSessions(userId: userId)
```

## Error Handling

```swift
do {
    let result = try await authManager.authenticate(credentials: credentials)
} catch AuthenticationError.biometricNotAvailable {
    // Handle biometric not available
} catch AuthenticationError.certificateInvalid {
    // Handle invalid certificate
} catch AuthenticationError.mfaRequired {
    // Handle MFA requirement
} catch AuthenticationError.sessionExpired {
    // Handle session expiration
} catch {
    // Handle other authentication errors
}
```

## Best Practices

1. **Always check biometric availability before use**
2. **Implement proper fallback mechanisms**
3. **Use secure token storage**
4. **Implement session timeout**
5. **Log authentication events**
6. **Handle MFA gracefully**
7. **Validate certificates properly**
8. **Use secure communication channels**

## Security Considerations

- Store sensitive data in Keychain
- Use certificate pinning for network requests
- Implement proper session management
- Log security events for audit
- Handle authentication failures securely
- Use secure random generation for tokens
- Implement rate limiting for authentication attempts

## Examples

See the [Authentication Examples](../Examples/AuthenticationExamples/) directory for complete implementation examples.

## Related Documentation

- [Security Manager API](SecurityManagerAPI.md)
- [Encryption API](EncryptionAPI.md)
- [Compliance API](ComplianceAPI.md)
- [Authentication Guide](AuthenticationGuide.md)
- [Getting Started Guide](GettingStarted.md)
