// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOS-Enterprise-Security-Framework",
    platforms: [
        .iOS(.v15),
        .macOS(.v14),
        .watchOS(.v10),
        .tvOS(.v17)
    ],
    products: [
        // Main framework product
        .library(
            name: "EnterpriseSecurity",
            targets: ["EnterpriseSecurity"]
        ),
        
        // Core security components
        .library(
            name: "EnterpriseSecurityCore",
            targets: ["EnterpriseSecurityCore"]
        ),
        
        // Encryption components
        .library(
            name: "EnterpriseSecurityEncryption",
            targets: ["EnterpriseSecurityEncryption"]
        ),
        
        // Certificate management
        .library(
            name: "EnterpriseSecurityCertificate",
            targets: ["EnterpriseSecurityCertificate"]
        ),
        
        // Compliance components
        .library(
            name: "EnterpriseSecurityCompliance",
            targets: ["EnterpriseSecurityCompliance"]
        ),
        
        // Threat detection
        .library(
            name: "EnterpriseSecurityThreat",
            targets: ["EnterpriseSecurityThreat"]
        ),
        
        // Enterprise key management
        .library(
            name: "EnterpriseSecurityEnterprise",
            targets: ["EnterpriseSecurityEnterprise"]
        )
    ],
    dependencies: [
        // Apple's CryptoKit for cryptographic operations
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.0.0"),
        
        // Security framework for certificate handling
        .package(url: "https://github.com/apple/swift-security.git", from: "1.0.0"),
        
        // Network security for SSL/TLS
        .package(url: "https://github.com/apple/swift-nio-ssl.git", from: "2.0.0"),
        
        // JSON encoding/decoding for audit trails
        .package(url: "https://github.com/apple/swift-json.git", from: "1.0.0"),
        
        // Logging framework
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        
        // Performance monitoring
        .package(url: "https://github.com/apple/swift-metrics.git", from: "2.0.0"),
        
        // Testing dependencies
        .package(url: "https://github.com/apple/swift-testing.git", from: "1.0.0")
    ],
    targets: [
        // Main Enterprise Security Framework
        .target(
            name: "EnterpriseSecurity",
            dependencies: [
                "EnterpriseSecurityCore",
                "EnterpriseSecurityEncryption",
                "EnterpriseSecurityCertificate",
                "EnterpriseSecurityCompliance",
                "EnterpriseSecurityThreat",
                "EnterpriseSecurityEnterprise"
            ],
            path: "Sources/EnterpriseSecurity",
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release)),
                .define("ENTERPRISE_SECURITY", .when(configuration: .release))
            ]
        ),
        
        // Core security components
        .target(
            name: "EnterpriseSecurityCore",
            dependencies: [
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Metrics", package: "swift-metrics")
            ],
            path: "Sources/Core",
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release))
            ]
        ),
        
        // Encryption components
        .target(
            name: "EnterpriseSecurityEncryption",
            dependencies: [
                "EnterpriseSecurityCore",
                .product(name: "Crypto", package: "swift-crypto")
            ],
            path: "Sources/Encryption",
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release)),
                .define("ENCRYPTION_ENABLED", .when(configuration: .release))
            ]
        ),
        
        // Certificate management
        .target(
            name: "EnterpriseSecurityCertificate",
            dependencies: [
                "EnterpriseSecurityCore",
                .product(name: "NIOSSL", package: "swift-nio-ssl")
            ],
            path: "Sources/Certificate",
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release)),
                .define("CERTIFICATE_ENABLED", .when(configuration: .release))
            ]
        ),
        
        // Compliance components
        .target(
            name: "EnterpriseSecurityCompliance",
            dependencies: [
                "EnterpriseSecurityCore",
                .product(name: "JSON", package: "swift-json")
            ],
            path: "Sources/Compliance",
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release)),
                .define("COMPLIANCE_ENABLED", .when(configuration: .release))
            ]
        ),
        
        // Threat detection
        .target(
            name: "EnterpriseSecurityThreat",
            dependencies: [
                "EnterpriseSecurityCore"
            ],
            path: "Sources/Threat",
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release)),
                .define("THREAT_DETECTION_ENABLED", .when(configuration: .release))
            ]
        ),
        
        // Enterprise key management
        .target(
            name: "EnterpriseSecurityEnterprise",
            dependencies: [
                "EnterpriseSecurityCore",
                "EnterpriseSecurityEncryption"
            ],
            path: "Sources/Enterprise",
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release)),
                .define("ENTERPRISE_ENABLED", .when(configuration: .release))
            ]
        ),
        
        // Unit tests for main framework
        .testTarget(
            name: "EnterpriseSecurityTests",
            dependencies: [
                "EnterpriseSecurity",
                .product(name: "Testing", package: "swift-testing")
            ],
            path: "Tests/EnterpriseSecurityTests"
        ),
        
        // Unit tests for core components
        .testTarget(
            name: "EnterpriseSecurityCoreTests",
            dependencies: [
                "EnterpriseSecurityCore",
                .product(name: "Testing", package: "swift-testing")
            ],
            path: "Tests/CoreTests"
        ),
        
        // Unit tests for encryption
        .testTarget(
            name: "EnterpriseSecurityEncryptionTests",
            dependencies: [
                "EnterpriseSecurityEncryption",
                .product(name: "Testing", package: "swift-testing")
            ],
            path: "Tests/EncryptionTests"
        ),
        
        // Unit tests for certificate management
        .testTarget(
            name: "EnterpriseSecurityCertificateTests",
            dependencies: [
                "EnterpriseSecurityCertificate",
                .product(name: "Testing", package: "swift-testing")
            ],
            path: "Tests/CertificateTests"
        ),
        
        // Unit tests for compliance
        .testTarget(
            name: "EnterpriseSecurityComplianceTests",
            dependencies: [
                "EnterpriseSecurityCompliance",
                .product(name: "Testing", package: "swift-testing")
            ],
            path: "Tests/ComplianceTests"
        ),
        
        // Unit tests for threat detection
        .testTarget(
            name: "EnterpriseSecurityThreatTests",
            dependencies: [
                "EnterpriseSecurityThreat",
                .product(name: "Testing", package: "swift-testing")
            ],
            path: "Tests/ThreatTests"
        ),
        
        // Unit tests for enterprise features
        .testTarget(
            name: "EnterpriseSecurityEnterpriseTests",
            dependencies: [
                "EnterpriseSecurityEnterprise",
                .product(name: "Testing", package: "swift-testing")
            ],
            path: "Tests/EnterpriseTests"
        ),
        
        // Integration tests
        .testTarget(
            name: "EnterpriseSecurityIntegrationTests",
            dependencies: [
                "EnterpriseSecurity",
                .product(name: "Testing", package: "swift-testing")
            ],
            path: "Tests/IntegrationTests"
        ),
        
        // Performance tests
        .testTarget(
            name: "EnterpriseSecurityPerformanceTests",
            dependencies: [
                "EnterpriseSecurity",
                .product(name: "Testing", package: "swift-testing")
            ],
            path: "Tests/PerformanceTests"
        ),
        
        // Security tests
        .testTarget(
            name: "EnterpriseSecuritySecurityTests",
            dependencies: [
                "EnterpriseSecurity",
                .product(name: "Testing", package: "swift-testing")
            ],
            path: "Tests/SecurityTests"
        )
    ]
) 