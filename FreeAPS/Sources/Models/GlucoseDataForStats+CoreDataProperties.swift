import CoreData
import Foundation

public extension GlucoseDataForStats {
    @nonobjc class func fetchRequest() -> NSFetchRequest<GlucoseDataForStats> {
        NSFetchRequest<GlucoseDataForStats>(entityName: "GlucoseDataForStats")
    }

    @NSManaged var date: Date?
    @NSManaged var glucose: Int16
}
