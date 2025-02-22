//
//  ContentView.swift
//  NoteIt
//
//  Created by sachin kumar on 19/02/25.
//

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
    // New state variables for delete confirmation
    @State private var noteToDelete: NotesTable? = nil
    @State private var showDeleteConfirmation: Bool = false

    var body: some View {
        ZStack {
            NavigationView {
                List {
                    ForEach(Array(zip(notes.indices, notes)), id: \.1) { index, note in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(note.title ?? "Untitled")
                                    .font(.headline)
                                Text(note.noteDescription ?? "")
                                    .font(.subheadline)
                            }
                            .onTapGesture {
                                editingNote = note
                                showEditor = true
                            }
                            Spacer()
                            Button(
                                action: {
                                    confirmDelete(note: note)
                                },
                                label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                })
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                confirmDelete(note: note)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .listRowBackground(
                            index % 2 == 0 ? Color.green.opacity(0.2) : Color.blue.opacity(0.2)
                        )
                    }
                    .onDelete(perform: { _ in })  // Disable default deletion
                }
                // Disable default scroll background and set a light pink background
                .scrollContentBackground(.hidden)
                .background(Color.pink.opacity(0.2))
                .navigationTitle("Notes")
                .navigationBarItems(
                    trailing: Button(
                        action: {
                            editingNote = nil
                            showEditor = true
                        },
                        label: {
                            Image(systemName: "plus")
                        })
                )
                .sheet(isPresented: $showEditor) {
                    NoteEditorView(note: editingNote)
                        .environment(\.managedObjectContext, viewContext)
                }
            }
            // Custom delete confirmation overlay with light pink background
            if showDeleteConfirmation, let note = noteToDelete {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Are you sure you want to delete this note?")
                        .multilineTextAlignment(.center)
                        .padding()
                    HStack {
                        Button("Delete") {
                            delete(note: note)
                            noteToDelete = nil
                            showDeleteConfirmation = false
                        }
                        .foregroundColor(.red)
                        Spacer()
                        Button("Cancel") {
                            noteToDelete = nil
                            showDeleteConfirmation = false
                        }
                        .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color.pink.opacity(0.2))
                .cornerRadius(10)
                .padding()
            }
        }
    }

    // New helper to trigger delete confirmation
    private func confirmDelete(note: NotesTable) {
        noteToDelete = note
        showDeleteConfirmation = true
    }

    private func delete(note: NotesTable) {
        viewContext.delete(note)
        do {
            try viewContext.save()
        } catch {
            print("Error deleting note: \(error.localizedDescription)")
        }
    }

    private func deleteNotes(offsets: IndexSet) {
        // Not used now because delete actions use alert confirmation
    }
}

#Preview {
    ContentView()
}
