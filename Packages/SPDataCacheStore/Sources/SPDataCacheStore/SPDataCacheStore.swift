import CoreData
import SPError
import SPLogger

@globalActor
public actor SPDataCacheStore {
    public static let shared: SPDataCacheStore = .init()
    
    private var _container: NSPersistentContainer?
    private var container: NSPersistentContainer {
        get async throws {
            if let _container: NSPersistentContainer {
                return _container
            }
            
            let description: NSEntityDescription = .init()
            let className: String = NSStringFromClass(SPDataCache.self)
            
            description.name = className
            description.managedObjectClassName = className
            
            let dataDescription: NSAttributeDescription = .init()
            dataDescription.name = #keyPath(SPDataCache.data)
            dataDescription.attributeType = .binaryDataAttributeType
            dataDescription.isOptional = false
            
            let identityDescription: NSAttributeDescription = .init()
            identityDescription.name = #keyPath(SPDataCache.identity)
            identityDescription.attributeType = .stringAttributeType
            identityDescription.isOptional = false
            
            description.properties = [
                dataDescription,
                identityDescription
            ]
            
            let model: NSManagedObjectModel = .init()
            model.entities = [description]
            
            let container: NSPersistentContainer = .init(name: className, managedObjectModel: model)
            
            let _: Void = try await withCheckedThrowingContinuation { continuation in
                container.loadPersistentStores { _, error in
                    if let error: Error {
                        continuation.resume(with: .failure(error))
                    } else {
                        continuation.resume(with: .success(()))
                    }
                }
            }
            
            _container = container
            
            return container
        }
    }
    
    private var _context: NSManagedObjectContext?
    private var context: NSManagedObjectContext {
        get async throws {
            if let _context: NSManagedObjectContext {
                return _context
            }
            
            let context: NSManagedObjectContext = try await container.newBackgroundContext()
            
            _context = context
            
            return context
        }
    }
    
    private init() {
        
    }
    
    public func newDataCache() async throws -> SPDataCache {
        let context: NSManagedObjectContext = try await context
        let dataCache: SPDataCache = .init(context: context)
        return dataCache
    }
    
    public func fetchDataCache(with identity: String) async throws -> [SPDataCache] {
        let fetchRequest: NSFetchRequest<any NSFetchRequestResult> = .init(entityName: NSStringFromClass(SPDataCache.self))
        let predicate: NSPredicate = .init(format: "%K = %@", argumentArray: [#keyPath(SPDataCache.identity), identity])
        fetchRequest.predicate = predicate
        
        let context: NSManagedObjectContext = try await context
        
        let result: [SPDataCache] = try await withCheckedThrowingContinuation { continuation in
            context.performAndWait {
                do {
                    guard let result: [SPDataCache] = try context.fetch(fetchRequest) as? [SPDataCache] else {
                        throw SPError.typeMismatch
                    }
                    
                    continuation.resume(with: .success(result))
                } catch {
                    continuation.resume(with: .failure(error))
                }
            }
        }
        
        return result
    }
    
    public func saveChanges() async throws {
        let context: NSManagedObjectContext = try await context
        
        guard context.hasChanges else {
            log.notice("Nothing to save!")
            return
        }
        
        let _: Void = try await withCheckedThrowingContinuation { continuation in
            context.performAndWait {
                do {
                    try context.save()
                    continuation.resume(with: .success(()))
                } catch {
                    continuation.resume(with: .failure(error))
                }
            }
        }
    }
    
    public func deleteDataCaches(with identity: String) async throws {
        let fetchRequest: NSFetchRequest<any NSFetchRequestResult> = .init(entityName: NSStringFromClass(SPDataCache.self))
        let predicate: NSPredicate = .init(format: "%K = %@", argumentArray: [#keyPath(SPDataCache.identity), identity])
        fetchRequest.predicate = predicate
        
        let container: NSPersistentContainer = try await container
        let context: NSManagedObjectContext = try await context
        
        let batchDeleteRequest: NSBatchDeleteRequest = .init(fetchRequest: fetchRequest)
        batchDeleteRequest.affectedStores = container.persistentStoreCoordinator.persistentStores
        
        try container.persistentStoreCoordinator.execute(batchDeleteRequest, with: context)
    }
    
    public func delete(dataCaches: Set<SPDataCache>) async throws {
        let context: NSManagedObjectContext = try await context
        
        let _: Void = await withCheckedContinuation { continuation in
            context.performAndWait {
                dataCaches
                    .forEach { dataCache in
                        context.delete(dataCache)
                    }
                continuation.resume(with: .success(()))
            }
        }
    }
    
    public func deleteAll() async throws {
        let container: NSPersistentContainer = try await container
        let context: NSManagedObjectContext = try await context
        let fetchRequest: NSFetchRequest<any NSFetchRequestResult> = .init(entityName: NSStringFromClass(SPDataCache.self))
        let batchDeleteRequest: NSBatchDeleteRequest = .init(fetchRequest: fetchRequest)
        batchDeleteRequest.affectedStores = container.persistentStoreCoordinator.persistentStores
        
        context.reset()
        try container.persistentStoreCoordinator.execute(batchDeleteRequest, with: context)
    }
}
