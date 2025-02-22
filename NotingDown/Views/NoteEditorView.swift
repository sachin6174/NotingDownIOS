import CoreData
import SwiftUI

struct NoteEditorView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext

    // Local states to hold user input
    @State var title: String = ""
    @State var description: String = ""

    // If editing an existing note, otherwise nil for a new note
    var note: NotesTable?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $title)
                }
                Section(header: Text("Description")) {
                    TextField("Enter description", text: $description)
                }
            }
            .scrollContentBackground(.hidden)  // Disable default form background
            .background(Color.pink.opacity(0.2))  // Apply light pink background
            .navigationTitle(note == nil ? "Add Note" : "Edit Note")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    // Either update the existing note or create a new one
                    if let note = note {
                        // Update existing
                        note.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        note.noteDescription = description.trimmingCharacters(
                            in: .whitespacesAndNewlines)
                    } else {
                        // Create new
                        let newNote = NotesTable(context: viewContext)
                        newNote.id = UUID()
                        newNote.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        newNote.noteDescription = description.trimmingCharacters(
                            in: .whitespacesAndNewlines)
                    }

                    // Save to Core Data
                    do {
                        try viewContext.save()
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        // Handle errors (e.g. show an alert)
                        print("Error saving note: \(error.localizedDescription)")
                    }
                }
                .disabled(
                    title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        || description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                )
            )
            .onAppear {
                // If editing an existing note, load its data
                if let note = note {
                    title = note.title ?? ""
                    description = note.noteDescription ?? ""
                }
            }
        }
    }
}

struct NoteEditorView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataStack.shared.context
        return NoteEditorView(note: nil)
            .environment(\.managedObjectContext, context)
    }
}
