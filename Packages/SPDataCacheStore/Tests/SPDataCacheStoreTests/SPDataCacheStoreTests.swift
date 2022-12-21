import XCTest
@testable import SPDataCacheStore

final class SPDataCacheStoreTests: XCTestCase {
    let dataCacheStore: SPDataCacheStore = .shared
    
    override func setUp() async throws {
        try await dataCacheStore.deleteAll()
        try await super.setUp()
    }
    
    func test_newDataCache() async throws {
        let dataCache: SPDataCache = try await dataCacheStore.newDataCache()
        XCTAssertNotNil(dataCache.managedObjectContext)
    }
    
    func test_saveChanges_fetchDataCache() async throws {
        let identity: String = "Test"
        let data: Data = identity.data(using: .utf8, allowLossyConversion: true)!
        
        let dataCache: SPDataCache = try await dataCacheStore.newDataCache()
        dataCache.identity = identity
        dataCache.data = data
        
        try await dataCacheStore.saveChanges()
        
        let fetchedDataCache: SPDataCache = try await dataCacheStore.fetchDataCache(with: identity).last!
        
        XCTAssertEqual(dataCache.identity, identity)
        XCTAssertEqual(dataCache.data, data)
        XCTAssertEqual(fetchedDataCache.identity, identity)
        XCTAssertEqual(fetchedDataCache.data, data)
    }
    
    func test_deleteDataCachesWithIdentity() async throws {
        let identity: String = "Test"
        let data: Data = identity.data(using: .utf8, allowLossyConversion: true)!
        
        let dataCache: SPDataCache = try await dataCacheStore.newDataCache()
        dataCache.identity = identity
        dataCache.data = data
        
        try await dataCacheStore.saveChanges()
        try await dataCacheStore.deleteDataCaches(with: identity)
        try await dataCacheStore.saveChanges()
        
        let results: [SPDataCache] = try await dataCacheStore.fetchDataCache(with: identity)
        XCTAssertTrue(results.isEmpty)
    }
    
    func test_deleteDataCaches() async throws {
        let identity: String = "Test"
        let data: Data = identity.data(using: .utf8, allowLossyConversion: true)!
        
        let dataCache: SPDataCache = try await dataCacheStore.newDataCache()
        dataCache.identity = identity
        dataCache.data = data
        
        try await dataCacheStore.saveChanges()
        try await dataCacheStore.delete(dataCaches: [dataCache])
        try await dataCacheStore.saveChanges()
        
        let results: [SPDataCache] = try await dataCacheStore.fetchDataCache(with: identity)
        XCTAssertTrue(results.isEmpty)
    }
    
    func test_deleteAll() async throws {
        let identity: String = "Test"
        let data: Data = identity.data(using: .utf8, allowLossyConversion: true)!
        
        let dataCache: SPDataCache = try await dataCacheStore.newDataCache()
        dataCache.identity = identity
        dataCache.data = data
        
        try await dataCacheStore.saveChanges()
        try await dataCacheStore.deleteAll()
        
        let results: [SPDataCache] = try await dataCacheStore.fetchDataCache(with: identity)
        XCTAssertTrue(results.isEmpty)
    }
}
