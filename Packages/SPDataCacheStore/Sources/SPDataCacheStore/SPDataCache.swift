import CoreData

@objc(SPDataCache)
public final class SPDataCache: NSManagedObject, @unchecked Sendable {
    @NSManaged public var data: Data
    @NSManaged public var identity: String
}
