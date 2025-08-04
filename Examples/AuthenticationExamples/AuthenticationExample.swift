import Foundation
import EnterpriseSecurityFramework

/// Authentication Examples
/// This example demonstrates various authentication methods including
/// biometric, certificate, token, and multi-factor authentication.
class AuthenticationExample {
    
    // MARK: - Properties
    
    private let biometricAuth = BiometricAuthenticationManager()
    private let certificateAuth = CertificateAuthenticationManager()
    private let mfaAuth = MultiFactorAuthenticationManager()
    private let tokenAuth = TokenAuthenticationManager()
    private let sessionManager = SessionManager()
    
    // MARK: - Initialization
    
    init() {
        setupAuthentication()
    }
    
    // MARK: - Setup
    
    private func setupAuthentication() {
        // Configure biometric authentication
        let biometricConfig = BiometricConfiguration()
        biometricConfig.enableFaceID = true
        biometricConfig.enableTouchID = true
        biometricConfig.enableCustomBiometric = true
        biometricConfig.fallbackToPasscode = true
        
        biometricAuth.configure(biometricConfig)
        
        // Configure certificate authentication
        let certificateConfig = CertificateConfiguration()
        certificateConfig.enablePKI = true
        certificateConfig.enableClientCertificates = true
        certificateConfig.enableCertificatePinning = true
        certificateConfig.trustedCAs = ["ca1", "ca2", "ca3"]
        
        certificateAuth.configure(certificateConfig)
        
        // Configure MFA
        let mfaConfig = MFAConfiguration()
        mfaConfig.enableSMS = true
        mfaConfig.enableEmail = true
        mfaConfig.enableHardwareToken = true
        mfaConfig.enableAppToken = true
        mfaConfig.requireMFA = true
        
        mfaAuth.configure(mfaConfig)
    }
    
    // MARK: - Biometric Authentication
    
    /// Demonstrates biometric authentication
    func demonstrateBiometricAuthentication() async {
        print("🔐 Starting Biometric Authentication Example")
        
        do {
            // Check biometric availability
            let availability = try await biometricAuth.checkBiometricAvailability()
            
            print("✅ Biometric authentication available")
            print("   Face ID: \(availability.faceIDAvailable)")
            print("   Touch ID: \(availability.touchIDAvailable)")
            print("   Biometric type: \(availability.biometricType)")
            
            // Authenticate with biometric
            try await biometricAuth.authenticate(reason: "Access secure data")
            print("✅ Biometric authentication successful")
            
            // Proceed with secure operations
            await performSecureOperations()
            
        } catch BiometricError.notAvailable {
            print("❌ Biometric authentication not available")
        } catch BiometricError.notEnrolled {
            print("❌ No biometric enrolled")
        } catch BiometricError.lockedOut {
            print("❌ Biometric locked out")
        } catch {
            print("❌ Biometric authentication failed: \(error)")
        }
    }
    
    // MARK: - Certificate Authentication
    
    /// Demonstrates certificate-based authentication
    func demonstrateCertificateAuthentication() async {
        print("🔐 Starting Certificate Authentication Example")
        
        // Simulate certificate data
        let certificateData = "-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----"
        
        do {
            // Validate certificate
            let validation = try await certificateAuth.validateCertificate(certificateData)
            
            print("✅ Certificate validation successful")
            print("   Issuer: \(validation.issuer)")
            print("   Subject: \(validation.subject)")
            print("   Expiry: \(validation.expiryDate)")
            print("   Valid: \(validation.isValid)")
            
            // Authenticate with certificate
            let authResult = try await certificateAuth.authenticateWithCertificate(certificateData)
            
            print("✅ Certificate authentication successful")
            print("   User: \(authResult.user)")
            print("   Permissions: \(authResult.permissions)")
            
        } catch CertificateError.invalidCertificate {
            print("❌ Invalid certificate")
        } catch CertificateError.expiredCertificate {
            print("❌ Certificate expired")
        } catch CertificateError.unauthorizedCertificate {
            print("❌ Unauthorized certificate")
        } catch {
            print("❌ Certificate authentication failed: \(error)")
        }
    }
    
    // MARK: - Multi-Factor Authentication
    
    /// Demonstrates multi-factor authentication
    func demonstrateMultiFactorAuthentication() async {
        print("🔐 Starting Multi-Factor Authentication Example")
        
        let userId = "user@company.com"
        
        do {
            // Setup MFA for user
            let setup = try await mfaAuth.setupMFA(for: userId, configuration: MFAConfiguration())
            
            print("✅ MFA setup successful")
            print("   SMS enabled: \(setup.smsEnabled)")
            print("   Email enabled: \(setup.emailEnabled)")
            print("   Hardware token: \(setup.hardwareTokenEnabled)")
            
            // Send verification code
            try await mfaAuth.sendVerificationCode(
                userId: userId,
                method: .sms,
                phoneNumber: "+1234567890"
            )
            
            print("✅ Verification code sent")
            
            // Simulate code verification
            let verification = try await mfaAuth.verifyCode(
                userId: userId,
                code: "123456"
            )
            
            print("✅ Code verification successful")
            print("   Verification time: \(verification.verificationTime)")
            
            // Authenticate with MFA
            try await mfaAuth.authenticateWithMFA(
                userId: userId,
                primaryFactor: .password,
                secondaryFactor: .sms
            )
            
            print("✅ MFA authentication successful")
            
        } catch MFAError.setupFailed {
            print("❌ MFA setup failed")
        } catch MFAError.codeExpired {
            print("❌ Verification code expired")
        } catch MFAError.invalidCode {
            print("❌ Invalid verification code")
        } catch {
            print("❌ MFA authentication failed: \(error)")
        }
    }
    
    // MARK: - Token Authentication
    
    /// Demonstrates token-based authentication
    func demonstrateTokenAuthentication() async {
        print("🔐 Starting Token Authentication Example")
        
        // Simulate JWT token
        let jwtToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
        
        do {
            // Authenticate with JWT token
            let authResult = try await tokenAuth.authenticateWithJWT(jwtToken)
            
            print("✅ JWT authentication successful")
            print("   User: \(authResult.user)")
            print("   Expires: \(authResult.expiresAt)")
            print("   Permissions: \(authResult.permissions)")
            
            // Refresh token if needed
            if authResult.needsRefresh {
                let refreshResult = try await tokenAuth.refreshToken(authResult.refreshToken)
                print("✅ Token refreshed successfully")
            }
            
        } catch TokenError.invalidToken {
            print("❌ Invalid token")
        } catch TokenError.expiredToken {
            print("❌ Token expired")
        } catch {
            print("❌ Token authentication failed: \(error)")
        }
    }
    
    // MARK: - Session Management
    
    /// Demonstrates session management
    func demonstrateSessionManagement() async {
        print("🔐 Starting Session Management Example")
        
        let userId = "user@company.com"
        
        do {
            // Create session
            let session = try await sessionManager.createSession(userId: userId)
            
            print("✅ Session created")
            print("   Session ID: \(session.sessionId)")
            print("   User ID: \(session.userId)")
            print("   Created: \(session.createdAt)")
            print("   Expires: \(session.expiresAt)")
            
            // Validate session
            let isValid = try await sessionManager.validateSession(session.sessionId)
            print("✅ Session validation: \(isValid)")
            
            // Extend session
            try await sessionManager.extendSession(session.sessionId, duration: 3600)
            print("✅ Session extended")
            
            // Terminate session
            try await sessionManager.terminateSession(session.sessionId)
            print("✅ Session terminated")
            
        } catch {
            print("❌ Session management failed: \(error)")
        }
    }
    
    // MARK: - Helper Methods
    
    private func performSecureOperations() async {
        print("🔒 Performing secure operations...")
        // Simulate secure operations
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        print("✅ Secure operations completed")
    }
}

// MARK: - Supporting Types

enum BiometricError: Error {
    case notAvailable
    case notEnrolled
    case lockedOut
}

enum CertificateError: Error {
    case invalidCertificate
    case expiredCertificate
    case unauthorizedCertificate
}

enum MFAError: Error {
    case setupFailed
    case codeExpired
    case invalidCode
}

enum TokenError: Error {
    case invalidToken
    case expiredToken
}

// MARK: - Usage Example

@main
struct AuthenticationExampleApp {
    static func main() async {
        let example = AuthenticationExample()
        
        // Run authentication examples
        await example.demonstrateBiometricAuthentication()
        await example.demonstrateCertificateAuthentication()
        await example.demonstrateMultiFactorAuthentication()
        await example.demonstrateTokenAuthentication()
        await example.demonstrateSessionManagement()
        
        print("✅ Authentication Example Completed")
    }
} 