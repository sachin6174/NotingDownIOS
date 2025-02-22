import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \NotesTable.title, ascending: true)],
        animation: .default)
    private var notes: FetchedResults<NotesTable>

    @State private var showEditor = false
    @State private var editingNote: NotesTable? = nil
    @State private var noteToDelete: NotesTable? = nil
    @State private var showDeleteConfirmation: Bool = false

    var body: some View {
        NavigationView {
            List {
                ForEach(Array(zip(notes.indices, notes)), id: \.1.objectID) { index, note in
                    HStack {
                        Text("\(index + 1).")  // Serial number
                            .foregroundColor(.secondary)
                        NavigationLink(destination: NoteDetailView(note: note)) {
                            VStack(alignment: .leading) {
                                Text(note.title ?? "Untitled")
                                    .font(.headline)
                            }
                        }
                        Spacer()
                        Button(action: { confirmDelete(note: note) }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.top, 10)  // Top padding between rows
                    .padding(.bottom, 10)  // Added bottom padding of 10 between rows
                    .swipeActions {
                        Button(role: .destructive) {
                            confirmDelete(note: note)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                .onDelete(perform: { _ in })
            }
            .padding(.vertical, 0)  // Added vertical padding of 10 for note list
            .scrollContentBackground(.hidden)
            .background(Color(red: 78 / 255, green: 187 / 255, blue: 120 / 255).opacity(0.2))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Notes")
                        .font(.system(size: 30, weight: .bold))
                        .padding(.top, 10)  // Top padding of 10 for heading
                        .padding(.bottom, 10)  // Bottom padding of 10 for heading
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        editingNote = nil
                        showEditor = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .padding(.top, 0)
        .navigationBarTitleDisplayMode(.inline)  // Added inline display to reduce spacing
        .navigationViewStyle(StackNavigationViewStyle())  // iPhone style on iPad
        .sheet(isPresented: $showEditor) {
            NoteEditorView(note: editingNote)
                .environment(\.managedObjectContext, viewContext)
        }
        .alert("Are you sure you want to delete this note?", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                if let note = noteToDelete {
                    delete(note: note)
                }
                noteToDelete = nil
            }
            Button("Cancel", role: .cancel) {
                noteToDelete = nil
            }
        }
    }

    private func confirmDelete(note: NotesTable) {
        noteToDelete = note
        showDeleteConfirmation = true
    }

    private func delete(note: NotesTable) {
        withAnimation {
            viewContext.delete(note)
            do {
                try viewContext.save()
            } catch {
                print("Error deleting note: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ContentView()
}
