//
//  AESEngine.swift
//  iOS-Enterprise-Security-Framework
//
//  Created by Muhittin Camdali on 2024-01-15
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import Foundation
import CryptoKit
import Security

/// AES encryption engine for enterprise security framework
///
/// This class provides AES-256-GCM encryption capabilities with:
/// - Hardware-accelerated encryption
/// - Secure key management
/// - Performance optimization
/// - Memory safety
///
/// ## Usage
///
/// ```swift
/// let aesEngine = AESEngine()
/// let encryptedData = try aesEngine.encrypt(data: sensitiveData, key: key)
/// ```
///
/// - Since: 1.0.0
/// - Author: Enterprise Security Team
@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
public final class AESEngine {
    
    // MARK: - Public Properties
    
    /// Current encryption performance metrics
    @Published public private(set) var performanceMetrics: AESPerformanceMetrics
    
    /// Operation count for statistics
    public private(set) var operationCount: Int = 0
    
    // MARK: - Private Properties
    
    private let logger: Logger
    private let randomGenerator: SecureRandomGenerator
    private let performanceMonitor: PerformanceMonitor
    
    private let encryptionQueue = DispatchQueue(label: "com.enterprise.security.aes", qos: .userInitiated)
    
    // MARK: - Initialization
    
    /// Initialize the AES engine
    ///
    /// - Throws: `AESError` if initialization fails
    public init() throws {
        self.logger = Logger(subsystem: "com.enterprise.security", category: "AESEngine")
        self.randomGenerator = try SecureRandomGenerator()
        self.performanceMonitor = PerformanceMonitor()
        self.performanceMetrics = AESPerformanceMetrics()
        
        logger.info("AES engine initialized successfully")
    }
    
    // MARK: - Public Methods
    
    /// Encrypt data using AES-256-GCM
    ///
    /// - Parameters:
    ///   - data: The data to encrypt
    ///   - key: The encryption key
    /// - Returns: Encrypted data with nonce and tag
    /// - Throws: `AESError` if encryption fails
    public func encrypt(data: Data, key: Data) throws -> AESEncryptedData {
        return try encryptionQueue.sync {
            let startTime = CFAbsoluteTimeGetCurrent()
            
            logger.debug("Encrypting data of size: \(data.count) bytes with AES-256-GCM")
            
            // Validate input
            try validateEncryptionInput(data: data, key: key)
            
            // Generate nonce
            let nonce = try randomGenerator.generateNonce(size: 12)
            
            // Create symmetric key
            guard let symmetricKey = SymmetricKey(data: key) else {
                throw AESError.keyGenerationFailed("Failed to create symmetric key")
            }
            
            // Perform encryption
            let sealedBox = try AES.GCM.seal(data, using: symmetricKey, nonce: AES.GCM.Nonce(data: nonce))
            
            // Create encrypted data
            let encryptedData = AESEncryptedData(
                data: sealedBox.ciphertext,
                nonce: nonce,
                tag: sealedBox.tag,
                timestamp: Date()
            )
            
            // Update performance metrics
            let endTime = CFAbsoluteTimeGetCurrent()
            updatePerformanceMetrics(dataSize: data.count, duration: endTime - startTime)
            
            logger.info("AES encryption completed successfully")
            return encryptedData
        }
    }
    
    /// Decrypt data using AES-256-GCM
    ///
    /// - Parameters:
    ///   - encryptedData: The encrypted data to decrypt
    ///   - key: The decryption key
    /// - Returns: Decrypted data
    /// - Throws: `AESError` if decryption fails
    public func decrypt(_ encryptedData: AESEncryptedData, key: Data) throws -> Data {
        return try encryptionQueue.sync {
            let startTime = CFAbsoluteTimeGetCurrent()
            
            logger.debug("Decrypting data of size: \(encryptedData.data.count) bytes with AES-256-GCM")
            
            // Validate input
            try validateDecryptionInput(encryptedData: encryptedData, key: key)
            
            // Create symmetric key
            guard let symmetricKey = SymmetricKey(data: key) else {
                throw AESError.keyGenerationFailed("Failed to create symmetric key")
            }
            
            // Create sealed box
            let sealedBox = try AES.GCM.SealedBox(
                nonce: AES.GCM.Nonce(data: encryptedData.nonce),
                ciphertext: encryptedData.data,
                tag: encryptedData.tag
            )
            
            // Perform decryption
            let decryptedData = try AES.GCM.open(sealedBox, using: symmetricKey)
            
            // Update performance metrics
            let endTime = CFAbsoluteTimeGetCurrent()
            updatePerformanceMetrics(dataSize: decryptedData.count, duration: endTime - startTime)
            
            logger.info("AES decryption completed successfully")
            return decryptedData
        }
    }
    
    /// Generate AES key
    ///
    /// - Parameter keySize: The key size in bits
    /// - Returns: Generated key
    /// - Throws: `AESError` if key generation fails
    public func generateKey(keySize: Int = 256) throws -> Data {
        return try encryptionQueue.sync {
            logger.info("Generating AES key with size: \(keySize) bits")
            
            let key = try randomGenerator.generateKey(size: keySize / 8)
            
            logger.info("AES key generated successfully")
            return key
        }
    }
    
    /// Get performance statistics
    ///
    /// - Returns: Performance statistics
    public func getPerformanceStatistics() -> AESPerformanceStatistics {
        return encryptionQueue.sync {
            return AESPerformanceStatistics(
                totalOperations: operationCount,
                averageSpeed: performanceMetrics.averageSpeed,
                memoryUsage: performanceMetrics.memoryUsage,
                cpuUsage: performanceMetrics.cpuUsage,
                batteryImpact: performanceMetrics.batteryImpact
            )
        }
    }
    
    // MARK: - Private Methods
    
    private func validateEncryptionInput(data: Data, key: Data) throws {
        guard !data.isEmpty else {
            throw AESError.invalidInput("Data cannot be empty")
        }
        
        guard key.count == 32 else {
            throw AESError.invalidKey("AES-256 requires 32-byte key")
        }
    }
    
    private func validateDecryptionInput(encryptedData: AESEncryptedData, key: Data) throws {
        guard !encryptedData.data.isEmpty else {
            throw AESError.invalidInput("Encrypted data cannot be empty")
        }
        
        guard !encryptedData.nonce.isEmpty else {
            throw AESError.invalidInput("Nonce cannot be empty")
        }
        
        guard key.count == 32 else {
            throw AESError.invalidKey("AES-256 requires 32-byte key")
        }
    }
    
    private func updatePerformanceMetrics(dataSize: Int, duration: CFTimeInterval) {
        operationCount += 1
        
        let speed = Double(dataSize) / (duration * 1024 * 1024) // MB/s
        performanceMetrics.updateMetrics(dataSize: dataSize, duration: duration, speed: speed)
    }
}

// MARK: - Supporting Types

/// AES encrypted data structure
@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
public struct AESEncryptedData {
    public let data: Data
    public let nonce: Data
    public let tag: Data
    public let timestamp: Date
    
    public init(data: Data, nonce: Data, tag: Data, timestamp: Date) {
        self.data = data
        self.nonce = nonce
        self.tag = tag
        self.timestamp = timestamp
    }
}

/// AES performance metrics
@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
public struct AESPerformanceMetrics {
    public var averageSpeed: Double = 0.0
    public var memoryUsage: Double = 0.0
    public var cpuUsage: Double = 0.0
    public var batteryImpact: Double = 0.0
    
    public mutating func updateMetrics(dataSize: Int, duration: CFTimeInterval, speed: Double) {
        averageSpeed = speed
        // Update other metrics as needed
    }
}

/// AES performance statistics
@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
public struct AESPerformanceStatistics {
    public let totalOperations: Int
    public let averageSpeed: Double
    public let memoryUsage: Double
    public let cpuUsage: Double
    public let batteryImpact: Double
}

// MARK: - Error Types

/// AES encryption errors
@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
public enum AESError: Error, LocalizedError {
    case invalidInput(String)
    case invalidKey(String)
    case keyGenerationFailed(String)
    case encryptionFailed(String)
    case decryptionFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidInput(let message):
            return "Invalid input: \(message)"
        case .invalidKey(let message):
            return "Invalid key: \(message)"
        case .keyGenerationFailed(let message):
            return "Key generation failed: \(message)"
        case .encryptionFailed(let message):
            return "Encryption failed: \(message)"
        case .decryptionFailed(let message):
            return "Decryption failed: \(message)"
        }
    }
} 