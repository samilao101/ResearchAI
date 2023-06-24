//
//  WebView.swift
//  ResearchAI
//
//  Created by Sam Santos on 5/18/23.
//

import SwiftUI
import PDFKit
import WebKit
import Combine


struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    

    let webView = WKWebView()
    var action: (URL?) -> ()
    
    func loadUrl(_ urlString: String) {
           if let url = URL(string: urlString) {
               let request = URLRequest(url: url)
               webView.load(request)
           }
    }

    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(self) { dest in
            print("got destination")
            action(dest)
        }
    }

    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: "https://www.google.com") {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

class WebViewCoordinator: NSObject, WKNavigationDelegate {
    var parent: WebView
    var action: (URL?) -> ()
    var loaded = false
    
    init(_ parent: WebView, _ action: @escaping (URL?) -> ()) {
        self.parent = parent
        self.action = action
    }

    // This function is called when the WebView starts to load a new request.
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.pathExtension.lowercased() == "pdf" {
            // If the URL points to a PDF, download it.
            downloadPDF(url: url)
            // Cancel the navigation to prevent the WebView from loading the PDF.
            decisionHandler(.allow)
        } else {
            // Allow the WebView to load other content.
            decisionHandler(.allow)
        }
    }

    // Download the PDF and save it locally.
    private func downloadPDF(url: URL) {
        let downloadTask = URLSession.shared.downloadTask(with: url) { (localURL, urlResponse, error) in
            if let localURL = localURL {
                // Save the downloaded PDF to the user's Documents directory.
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                
                let destinationURL = documentsDirectory.appendingPathComponent("pdfFile.pdf")

                if FileManager.default.fileExists(atPath: destinationURL.path) {
                    do {
                        try FileManager.default.removeItem(atPath: destinationURL.path)
                        do {
                            try FileManager.default.moveItem(at: localURL, to: destinationURL)
                            print("PDF downloaded and saved at: \(destinationURL)")
                            self.action(destinationURL)
                        } catch {
                            print("Error saving PDF: \(error)")
                            self.action(nil)
                        }
                    } catch {
                        print("unable to remove item")
                        self.action(nil)
                    }
                } else {
                    do {
                        try FileManager.default.moveItem(at: localURL, to: destinationURL)
                        print("PDF downloaded and saved at: \(destinationURL)")
                        self.action(destinationURL)
                    } catch {
                        print("Error saving PDF: \(error)")
                        self.action(nil)
                    }
                }
                
               
            }
        }
        downloadTask.resume()
    }
}

