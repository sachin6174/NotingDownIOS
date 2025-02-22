import SwiftUI

struct NoteDetailView: View {
    let note: NotesTable

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {  // Updated spacing to 10
            Text(note.title ?? "Untitled")
                .font(.largeTitle)
                .bold()
            Divider()
            Text(note.noteDescription ?? "No description provided.")
                .font(.body)
            Spacer()
        }
        .padding(.bottom, 0)  // Added bottom padding of 10
        .background(Color.pink.opacity(0.2))
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Detail")
                    .font(.system(size: 30, weight: .bold))
                    .padding(.top, 0)
            }
        }
    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NoteDetailView(note: NotesTable())
        // Adjust preview as needed
    }
}
