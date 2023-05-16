//
//  NotesViewer.swift
//  ResearchAI
//
//  Created by Sam Santos on 5/2/23.
//

import SwiftUI

struct NotesViewer: View {
    
    @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.location, ascending: false)], animation: .default) private var notes: FetchedResults<Note>

    @State private var note: String = ""
    let citation: String
    let location: Int
    let paperid: String
    let paragraph: String
    @Binding var showNoteViewer: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Note:")
                .font(.title)
                .bold()
            
            Divider()
            Text("\(citation)")
                .font(.caption)
            Divider()
            Text(paragraph)
                .font(.headline)
            TextEditor(text: $note)
                .tint(.gray)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(style: .init(lineWidth: 2)))
            HStack {
                Button("Cancel") {
                    showNoteViewer.toggle()
                }
                .tint(.red)
                Spacer()
                Button("Save") {
                    addNote()
                    showNoteViewer.toggle()
                }
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .foregroundColor(.black)
            }
        }
        .padding()
    }
    
    private func addNote() {
        withAnimation {
            let newNote = Note(context: viewContext)
            newNote.paragraph = paragraph
            newNote.paperid = paperid
            newNote.citation = citation
            newNote.location = Int16(location)
            newNote.note = note

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct NotesViewer_Previews: PreviewProvider {
    static var previews: some View {
        NotesViewer(citation: "Smith, J., & Brown, L. (2021). The effects of exercise on mental health: A systematic review. Journal of Health and Well-being", location: 7, paperid: "asnas9sanasan8", paragraph: "The capacity of Deep Neural Networks (DNNs) to approximate arbitrary functions given sufficient training data in the supervised learning setting is well known [Cybenko, 1989, Hornik et al., 1989, Anthony and Bartlett, 1999]. Several different theoretical approaches have emerged that study the effectiveness and pitfalls of deep learning. These studies vary in their treatment of neural networks and the aspects they study range from convergence [Allen-Zhu et al., 2019, Goodfellow and Vinyals, 2015], generalization [Kawaguchi et al., 2017, Zhang et al., 2017, Jacot et al., 2018, Sagun et al., 2018], function complexity [Montu ́far et al., 2014, Mhaskar and Poggio, 2016], adversarial attacks [Szegedy et al., 2014, Goodfellow et al., 2015] to representation capacity [Arpit et al., 2017]. Some recent theories have also been shown to closely match empirical observations [Poole et al., 2016, Hanin and Rolnick, 2019b, Kunin et al., 2020].", showNoteViewer: .constant(true)).preferredColorScheme(.dark)
    }
    }
