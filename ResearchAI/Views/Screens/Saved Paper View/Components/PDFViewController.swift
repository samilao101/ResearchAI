//
//  PDFViewController.swift
//  ResearchAI
//
//  Created by Sam Santos on 3/8/23.
//

import Foundation
import UIKit
import PDFKit

class PDFViewController: UIViewController, PDFViewDelegate {
    
    
    var pdfDocument: PDFDocument
    
    init(pdfDocument: PDFDocument, saveHighlightedPDF: @escaping (Data) -> ()) {
        self.pdfDocument = pdfDocument
        self.saveHighlightedPDF = saveHighlightedPDF
        super.init(nibName: nil, bundle: nil)
    }
    
    var saveHighlightedPDF: (Data) -> ()
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    var pdfView = CustomPDFView()
    var documentView : UIView? = nil {
        didSet {
            swizzleDocumentView()
        }
    }
    var doc : PDFDocument? = nil {
        didSet {
            let docview = pdfView.documentView
            if let view = docview {
                documentView = view
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(pdfView)
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        pdfView.document = pdfDocument
        doc = pdfView.document
        
        pdfView.backgroundColor = .lightGray
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.usePageViewController(true)

    }
    
    private func swizzleDocumentView() {
        guard let d = documentView, let documentViewClass = object_getClass(d) else { return }
        print("got ehre")
        
        let sel = #selector(swizzled_canPerformAction(_:withSender:))
        let meth = class_getInstanceMethod(object_getClass(self), sel)!
        let imp = method_getImplementation(meth)
        
        let selOriginal = #selector(canPerformAction(_:withSender:))
        let methOriginal = class_getInstanceMethod(documentViewClass, selOriginal)!
        
        method_setImplementation(methOriginal, imp)
    }
    
    @objc func swizzled_canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    
    @objc  func highlight() {
        
        print("THEY ARE HERE")
        guard let currentSelection = pdfView.currentSelection else { return }
        let selections = currentSelection.selectionsByLine()
        guard let page = selections.first?.pages.first else { return }
        
        selections.forEach { selection in
            
            let highlight = PDFAnnotation(bounds: selection.bounds(for: page), forType: .highlight, withProperties: nil)
            highlight.color = .green
            highlight.endLineStyle = .square
            
            page.addAnnotation(highlight)
        }
        
//        let annotation = PDFAnnotation(bounds: CGRect(x: selections[0].bounds(for: page).minX, y: selections[0].bounds(for: page).minY, width: 20, height: 20), forType: .text, withProperties: nil)
//        annotation.color = .yellow
//        annotation.contents = text
//        page.addAnnotation(annotation)
        
        saveHighlightedPDF(pdfDocument.dataRepresentation()!)
        pdfView.clearSelection()
    }
    
    @objc  func highlightAndAnnotate(text: String, selection: PDFSelection) {
        
        print("annotating")
        let selections = selection.selectionsByLine()
        guard let page = selections.first?.pages.first else { return }
        selections.forEach { selection in
            
            let highlight = PDFAnnotation(bounds: selection.bounds(for: page), forType: .highlight, withProperties: nil)
            highlight.color = .orange
            highlight.endLineStyle = .square
            
            page.addAnnotation(highlight)
        }
        
        let annotation = PDFAnnotation(bounds: CGRect(x: selections[0].bounds(for: page).minX, y: selections[0].bounds(for: page).minY, width: 20, height: 20), forType: .text, withProperties: nil)
        annotation.color = .orange
        annotation.contents = text
        page.addAnnotation(annotation)
        
        saveHighlightedPDF(pdfDocument.dataRepresentation()!)
        pdfView.clearSelection()
    }
    
    
    @objc  func simplificationAnnotation(text: String, selection: PDFSelection) {
        
        print("annotating")
        let selections = selection.selectionsByLine()
        guard let page = selections.first?.pages.first else { return }
        selections.forEach { selection in
            
            let highlight = PDFAnnotation(bounds: selection.bounds(for: page), forType: .highlight, withProperties: nil)
            highlight.color = .yellow
            highlight.endLineStyle = .square
            
            page.addAnnotation(highlight)
        }
        
        let annotation = PDFAnnotation(bounds: CGRect(x: selections[0].bounds(for: page).minX, y: selections[0].bounds(for: page).minY, width: 20, height: 20), forType: .text, withProperties: nil)
        annotation.color = .yellow
        annotation.contents = text
        page.addAnnotation(annotation)
        
        saveHighlightedPDF(pdfDocument.dataRepresentation()!)
        pdfView.clearSelection()
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    
}


class CustomPDFView: PDFView {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        // Disable all menu items
        return false
    }
}




