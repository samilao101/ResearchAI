//
//  SavedPaperCellView.swift
//  ResearchAI
//
//  Created by Sam Santos on 4/29/23.
//

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
}

import SwiftUI

struct SavedPaperCellView: View {
    let title: String
    let icon: UIImage?
    let authors: [String]
    let publishedDate: String
    let id: String
    
    @State var showNotesEditor: Bool = false
    @State var savedLocation: Int = 0
    
    var body: some View {
        ZStack{
            VStack {
                Text(title)
                    .font(.subheadline).bold().underline()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                    
                HStack{
                    VStack(alignment: .leading){
                        Text("**Authors:** \(authors.map { $0 }.joined(separator: ", "))")
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 2)
                            .multilineTextAlignment(.leading)
                        Text("**Published:** \(publishedDate)")
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 10)
                            .multilineTextAlignment(.leading)
                        HStack {
                            Label("\(savedLocation)", systemImage: "bookmark.fill")
                                .font(.subheadline)
                            Button {
                                showNotesEditor.toggle()
                            } label: {
                                Label("Notes", systemImage: "note.text")
                                    .font(.subheadline)
                            }
                        }.padding()
                        Spacer()
                    }
                    VStack{
                        if let icon = icon {
                            Image(uiImage: icon)
                            
                                .resizable()
                                .scaledToFill()
                                .scaleEffect()
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 10)
                                .frame(width: 120, height: 160)
                                
                                .padding(.trailing, 40)
                                .background(Color.offWhite)


                                
                        }
                        Spacer()
                    }
                }
                Spacer()

            }
            .sheet(isPresented: $showNotesEditor, content: {
                NotesEditorViewer()
            })
            .foregroundColor(.black)
            .padding(3)
            .padding(.leading, 2)
            .padding(.top)
            .background(Color.offWhite.opacity(0.5).cornerRadius(6))

            .onAppear {
                savedLocation = UserDefaults.standard.integer(forKey: id)
            }

           
            
        
           
        }
        
       
        
            .frame(maxWidth: .infinity)
            .frame(height: 250)
           
        
            
            

        
    }
}

//struct SavedPaperCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        SavedPaperCellView(title: "Neural Manifolds in the AI age", icon: thumbnail, authors: ["Samil Cruz", "Paveli Cruz", "Pamela Cruz"], publishedDate: "12/31/1988", id: "san0haonasans8")
//        
//            .previewLayout(.sizeThatFits)
//    }
//}


struct BackgroundColor: ViewModifier {
    var opacity: Double = 0.6
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Color("Background")
                    .opacity(colorScheme == .dark ? opacity : 0)
                    .blendMode(.overlay)
                    .allowsHitTesting(false)
            )
    }
}

extension View {
    func backgroundColor(opacity: Double = 0.6) -> some View {
        self.modifier(BackgroundColor(opacity: opacity))
    }
}
