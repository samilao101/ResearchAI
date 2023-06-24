//
//  DocumentPicker.swift
//  ResearchAI
//
//  Created by Sam Santos on 5/31/23.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIDocumentPickerViewController
    
    var onPickedDocument: ((URL?) -> Void)
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onPickedDocument: onPickedDocument)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onPickedDocument: ((URL?) -> Void)
        
        init(onPickedDocument: @escaping ((URL?) -> Void)) {
            self.onPickedDocument = onPickedDocument
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            let selectedURL = urls.first
            onPickedDocument(selectedURL)
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            onPickedDocument(nil)
        }
    }
}

struct DocumentPicker_Previews: PreviewProvider {
    static var previews: some View {
        DocumentPicker(onPickedDocument: { url in
            
        })
    }
}
