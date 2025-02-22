import CoreData
import Foundation

extension NotesTable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotesTable> {
        return NSFetchRequest<NotesTable>(entityName: "NotesTable")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var noteDescription: String?
    @NSManaged public var title: String?
}

extension NotesTable: Identifiable {}
