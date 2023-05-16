//
//  NotesEditorViewer.swift
//  ResearchAI
//
//  Created by Sam Santos on 5/2/23.
//

import SwiftUI

struct NotesEditorViewer: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.location, ascending: false)], animation: .default) private var notes: FetchedResults<Note>
    
    var body: some View {
        NavigationView {
            VStack{
                List {
                    Section(header: Text("")) {
                        ForEach(notes) { note in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(note.paragraph ?? "")
                                    .font(.headline)
                                Text("Note: ")
                                    .bold()
                                Text(note.note ?? "")
                                    .font(.subheadline)
                            }
                        }
                        .onDelete(perform: deleteNotes)
                       
                    }
                }
                if let noteCite = notes.randomElement()?.citation {
                    Text("\(noteCite)")
                        .font(.caption)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Notes")
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    private func deleteNotes(offsets: IndexSet) {
        withAnimation {
            offsets.map { notes[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

}

struct NotesEditorViewer_Previews: PreviewProvider {
    static var previews: some View {
        NotesEditorViewer()
    }
}
