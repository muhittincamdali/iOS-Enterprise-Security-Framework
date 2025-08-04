import Foundation
import EnterpriseSecurityFramework

/// Data Encryption Example
/// This example demonstrates data encryption and decryption operations
/// using various encryption algorithms and key management techniques.
class DataEncryptionExample {
    
    // MARK: - Properties
    
    private let dataEncryption = DataEncryptionManager()
    private let keyManager = KeyManagementManager()
    private let fileEncryption = FileEncryptionManager()
    private let memoryEncryption = MemoryEncryptionManager()
    
    // MARK: - Initialization
    
    init() {
        setupEncryption()
    }
    
    // MARK: - Setup
    
    private func setupEncryption() {
        // Configure data encryption
        let encryptionConfig = EncryptionConfiguration()
        encryptionConfig.algorithm = .aes256
        encryptionConfig.mode = .gcm
        encryptionConfig.keySize = 256
        encryptionConfig.enableKeyRotation = true
        
        dataEncryption.configure(encryptionConfig)
        
        // Configure key management
        let keyConfig = KeyManagementConfiguration()
        keyConfig.enableKeyRotation = true
        keyConfig.rotationInterval = 30 // days
        keyConfig.secureStorage = .keychain
        
        keyManager.configure(keyConfig)
    }
    
    // MARK: - Data Encryption
    
    /// Demonstrates basic data encryption and decryption
    func demonstrateDataEncryption() async {
        print("🔒 Starting Data Encryption Example")
        
        let sensitiveData = "This is sensitive information that needs to be encrypted"
        
        do {
            // Generate encryption key
            let key = try await keyManager.generateKey(
                algorithm: .aes256,
                keySize: 256
            )
            
            print("✅ Encryption key generated")
            print("   Key ID: \(key.keyId)")
            print("   Algorithm: \(key.algorithm)")
            print("   Key size: \(key.keySize)")
            
            // Encrypt data
            let encryptedData = try await dataEncryption.encrypt(
                data: sensitiveData,
                key: key
            )
            
            print("✅ Data encryption successful")
            print("   Original size: \(sensitiveData.count) bytes")
            print("   Encrypted size: \(encryptedData.encrypted.count) bytes")
            print("   IV: \(encryptedData.iv)")
            print("   Tag: \(encryptedData.tag)")
            
            // Decrypt data
            let decryptedData = try await dataEncryption.decrypt(
                encryptedData: encryptedData,
                key: key
            )
            
            print("✅ Data decryption successful")
            print("   Decrypted data: \(decryptedData)")
            print("   Verification: \(decryptedData == sensitiveData)")
            
        } catch EncryptionError.invalidKey {
            print("❌ Invalid encryption key")
        } catch EncryptionError.algorithmNotSupported {
            print("❌ Unsupported encryption algorithm")
        } catch {
            print("❌ Data encryption failed: \(error)")
        }
    }
    
    /// Demonstrates encryption with custom configuration
    func demonstrateCustomEncryption() async {
        print("🔒 Starting Custom Encryption Example")
        
        let sensitiveData = "Custom encryption configuration example"
        
        do {
            // Create custom encryption configuration
            let config = EncryptionConfiguration()
            config.algorithm = .aes256
            config.mode = .gcm
            config.keySize = 256
            config.enableKeyRotation = true
            config.useSecureRandom = true
            
            // Generate key with custom configuration
            let key = try await keyManager.generateKey(
                algorithm: .aes256,
                keySize: 256
            )
            
            // Encrypt with custom configuration
            let encryptedData = try await dataEncryption.encrypt(
                data: sensitiveData,
                configuration: config,
                key: key
            )
            
            print("✅ Custom encryption successful")
            print("   Algorithm: \(config.algorithm)")
            print("   Mode: \(config.mode)")
            print("   Key size: \(config.keySize)")
            
            // Decrypt with same configuration
            let decryptedData = try await dataEncryption.decrypt(
                encryptedData: encryptedData,
                configuration: config,
                key: key
            )
            
            print("✅ Custom decryption successful")
            print("   Decrypted: \(decryptedData)")
            
        } catch {
            print("❌ Custom encryption failed: \(error)")
        }
    }
    
    // MARK: - Large Data Encryption
    
    /// Demonstrates encryption of large data sets
    func demonstrateLargeDataEncryption() async {
        print("🔒 Starting Large Data Encryption Example")
        
        // Simulate large data
        let largeData = String(repeating: "Large data chunk ", count: 10000)
        
        do {
            let key = try await keyManager.generateKey(
                algorithm: .aes256,
                keySize: 256
            )
            
            // Encrypt large data in chunks
            let encryptedChunks = try await dataEncryption.encryptLargeData(
                data: largeData,
                chunkSize: 1024 * 1024, // 1MB chunks
                key: key
            )
            
            print("✅ Large data encryption successful")
            print("   Original size: \(largeData.count) bytes")
            print("   Number of chunks: \(encryptedChunks.count)")
            print("   Total encrypted size: \(encryptedChunks.reduce(0) { $0 + $1.encrypted.count }) bytes")
            
            // Decrypt large data
            let decryptedData = try await dataEncryption.decryptLargeData(
                encryptedChunks: encryptedChunks,
                key: key
            )
            
            print("✅ Large data decryption successful")
            print("   Decrypted size: \(decryptedData.count) bytes")
            print("   Verification: \(decryptedData == largeData)")
            
        } catch {
            print("❌ Large data encryption failed: \(error)")
        }
    }
    
    // MARK: - File Encryption
    
    /// Demonstrates file encryption and decryption
    func demonstrateFileEncryption() async {
        print("🔒 Starting File Encryption Example")
        
        let sourcePath = "/tmp/sensitive_file.txt"
        let encryptedPath = "/tmp/encrypted_file.enc"
        let decryptedPath = "/tmp/decrypted_file.txt"
        
        // Create test file
        let testContent = "This is sensitive file content that needs to be encrypted"
        try? testContent.write(toFile: sourcePath, atomically: true, encoding: .utf8)
        
        do {
            let key = try await keyManager.generateKey(
                algorithm: .aes256,
                keySize: 256
            )
            
            // Encrypt file
            try await fileEncryption.encryptFile(
                sourcePath: sourcePath,
                destinationPath: encryptedPath,
                key: key
            )
            
            print("✅ File encryption successful")
            print("   Source: \(sourcePath)")
            print("   Encrypted: \(encryptedPath)")
            
            // Verify file integrity
            let integrity = try await fileEncryption.verifyFileIntegrity(
                filePath: encryptedPath
            )
            
            print("✅ File integrity verified")
            print("   Checksum: \(integrity.checksum)")
            print("   Valid: \(integrity.isValid)")
            
            // Decrypt file
            try await fileEncryption.decryptFile(
                sourcePath: encryptedPath,
                destinationPath: decryptedPath,
                key: key
            )
            
            print("✅ File decryption successful")
            print("   Decrypted: \(decryptedPath)")
            
            // Verify decrypted content
            let decryptedContent = try String(contentsOfFile: decryptedPath, encoding: .utf8)
            print("✅ Content verification: \(decryptedContent == testContent)")
            
        } catch FileEncryptionError.fileNotFound {
            print("❌ File not found")
        } catch FileEncryptionError.insufficientSpace {
            print("❌ Insufficient disk space")
        } catch {
            print("❌ File encryption failed: \(error)")
        }
    }
    
    // MARK: - Memory Encryption
    
    /// Demonstrates in-memory encryption for sensitive data
    func demonstrateMemoryEncryption() async {
        print("🔒 Starting Memory Encryption Example")
        
        let sensitiveData = "Sensitive data in memory"
        
        do {
            // Encrypt data in memory
            let encryptedMemory = try await memoryEncryption.encryptInMemory(
                data: sensitiveData,
                algorithm: .aes256
            )
            
            print("✅ Memory encryption successful")
            print("   Original size: \(sensitiveData.count) bytes")
            print("   Encrypted size: \(encryptedMemory.size) bytes")
            
            // Allocate secure memory
            let secureMemory = try await memoryEncryption.allocateSecureMemory(
                size: 1024,
                algorithm: .aes256
            )
            
            print("✅ Secure memory allocated")
            print("   Size: \(secureMemory.size) bytes")
            print("   Algorithm: \(secureMemory.algorithm)")
            
            // Write encrypted data to secure memory
            try await memoryEncryption.writeToSecureMemory(
                secureMemory,
                data: encryptedMemory
            )
            
            print("✅ Data written to secure memory")
            
            // Read from secure memory
            let readData = try await memoryEncryption.readFromSecureMemory(secureMemory)
            
            print("✅ Data read from secure memory")
            print("   Read size: \(readData.count) bytes")
            
            // Clear secure memory
            try await memoryEncryption.clearSecureMemory(secureMemory)
            
            print("✅ Secure memory cleared")
            
        } catch MemoryEncryptionError.insufficientMemory {
            print("❌ Insufficient memory")
        } catch MemoryEncryptionError.invalidMemory {
            print("❌ Invalid memory access")
        } catch {
            print("❌ Memory encryption failed: \(error)")
        }
    }
    
    // MARK: - Key Management
    
    /// Demonstrates key management operations
    func demonstrateKeyManagement() async {
        print("🔒 Starting Key Management Example")
        
        do {
            // Generate multiple keys
            let key1 = try await keyManager.generateKey(
                algorithm: .aes256,
                keySize: 256
            )
            
            let key2 = try await keyManager.generateKey(
                algorithm: .aes256,
                keySize: 256
            )
            
            print("✅ Keys generated")
            print("   Key 1 ID: \(key1.keyId)")
            print("   Key 2 ID: \(key2.keyId)")
            
            // Store keys securely
            try await keyManager.storeKey(key1, in: .keychain)
            try await keyManager.storeKey(key2, in: .keychain)
            
            print("✅ Keys stored securely")
            
            // List all keys
            let keys = try await keyManager.listKeys(algorithm: .aes256)
            
            print("✅ Key listing successful")
            print("   Total keys: \(keys.count)")
            for key in keys {
                print("   - Key ID: \(key.keyId), Algorithm: \(key.algorithm)")
            }
            
            // Rotate keys
            let rotation = try await keyManager.rotateKeys(algorithm: .aes256)
            
            print("✅ Key rotation successful")
            print("   Old key ID: \(rotation.oldKeyId)")
            print("   New key ID: \(rotation.newKeyId)")
            print("   Rotation time: \(rotation.rotationTime)")
            
            // Delete old key
            try await keyManager.deleteKey(keyId: key1.keyId)
            
            print("✅ Old key deleted")
            
        } catch KeyManagementError.keyNotFound {
            print("❌ Key not found")
        } catch KeyManagementError.storageFailed {
            print("❌ Key storage failed")
        } catch {
            print("❌ Key management failed: \(error)")
        }
    }
    
    // MARK: - Database Encryption
    
    /// Demonstrates database encryption
    func demonstrateDatabaseEncryption() async {
        print("🔒 Starting Database Encryption Example")
        
        do {
            let dbEncryption = DatabaseEncryptionManager()
            
            // Encrypt database
            try await dbEncryption.encryptDatabase(
                databasePath: "/tmp/test_database.sqlite",
                algorithm: .aes256
            )
            
            print("✅ Database encryption successful")
            
            // Encrypt specific columns
            try await dbEncryption.encryptColumn(
                tableName: "users",
                columnName: "ssn",
                algorithm: .aes256
            )
            
            print("✅ Column encryption successful")
            
            // Encrypt query results
            let encryptedResults = try await dbEncryption.encryptQueryResults(
                query: "SELECT * FROM users WHERE id = ?",
                parameters: ["user123"],
                algorithm: .aes256
            )
            
            print("✅ Query results encryption successful")
            print("   Encrypted results count: \(encryptedResults.count)")
            
        } catch DatabaseEncryptionError.databaseNotFound {
            print("❌ Database not found")
        } catch DatabaseEncryptionError.columnNotFound {
            print("❌ Column not found")
        } catch {
            print("❌ Database encryption failed: \(error)")
        }
    }
}

// MARK: - Supporting Types

enum EncryptionError: Error {
    case invalidKey
    case algorithmNotSupported
    case insufficientMemory
    case fileNotFound
}

enum FileEncryptionError: Error {
    case fileNotFound
    case insufficientSpace
    case invalidFile
}

enum MemoryEncryptionError: Error {
    case insufficientMemory
    case invalidMemory
    case accessDenied
}

enum KeyManagementError: Error {
    case keyNotFound
    case storageFailed
    case rotationFailed
}

enum DatabaseEncryptionError: Error {
    case databaseNotFound
    case columnNotFound
    case queryFailed
}

// MARK: - Usage Example

@main
struct DataEncryptionExampleApp {
    static func main() async {
        let example = DataEncryptionExample()
        
        // Run encryption examples
        await example.demonstrateDataEncryption()
        await example.demonstrateCustomEncryption()
        await example.demonstrateLargeDataEncryption()
        await example.demonstrateFileEncryption()
        await example.demonstrateMemoryEncryption()
        await example.demonstrateKeyManagement()
        await example.demonstrateDatabaseEncryption()
        
        print("✅ Data Encryption Example Completed")
    }
} 