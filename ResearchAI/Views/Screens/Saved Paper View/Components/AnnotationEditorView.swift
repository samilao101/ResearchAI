//
//  AnnotationEditorView.swift
//  ResearchAI
//
//  Created by Sam Santos on 3/14/23.
//

import SwiftUI

struct AnnotationEditorView: View {
    @State var text: String = ""
    @Binding var annotation: String
    @Binding var show: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Annotate:")
                .font(.largeTitle)
                .bold()
                .padding(.horizontal)
                .padding(.top)
            TextEditor(text: $text)
                .cornerRadius(8)
                .textViewModifier()
            HStack {
                Spacer()
                Button("Save Annotation") {
                    annotation = text
                    show.toggle()
                    
                }
                .buttonModifierNoPadding(color: .orange)
                .padding(.horizontal)
            }
        }
        .background(Color.blue)
    }
}

struct AnnotationEditorView_Previews: PreviewProvider {
    static var previews: some View {
        AnnotationEditorView(annotation: .constant("This is the annotation"), show: .constant(false))
    }
}
