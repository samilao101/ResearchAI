//
//  RAISummaryView.swift
//  ResearchAI
//
//  Created by Sam Santos on 2/7/23.
//

 import SwiftUI
 import PDFKit
 import Combine


 struct RAISummaryView: View {
     
     @EnvironmentObject var comprehensionLocalFileManager: LocalFileManager<Comprehension>
     @ObservedObject var appState : AppState = AppState.shared
     @ObservedObject var viewModel = OpenAIServicer()
     @State var simplified: String = ""
     @State var showPDF = false
     @State var pdf: PDFDocument? = nil
     @State var summarizing: Bool = false
     @StateObject var paperDownloadManager = PaperDownloadManager()
     
     @State var progress: Double = 0.0
     
     let summary: RAISummary
     
     var body: some View {
         ScrollView {
             VStack(alignment: .leading) {
                 Text(summary.raiTitle)
                     .font(.headline)
                 Group {
                     Text("Authors: ").underline()
                     Text(summary.raiAuthors.joined(separator: ", "))
                     Text("Published: ").underline()
                     Text(summary.raiPublished)
                     Text("Last Updated: ").underline()
                     Text(summary.raiUpdated)
                 }
                 .font(.caption)
                 Group {
                     Text("Summary:").bold()
                         .padding(.top)
                     Text(String(summary.raiSummary))
                 }
                 Button(action: {
                    requestSimplified()
                 }, label: {
                     SummarizingView(isSummarizing: summarizing, simplifiedSummary: simplified)
                 })
                 .onReceive(paperDownloadManager.progressPublisher, perform: { value in
                     self.progress = value
                 })
                 .task { await fetchPaper()}
                 .toolbar {
                     ToolbarItemGroup(placement: .navigationBarTrailing) {
                         PDFLoadingView(isPDFPresent: pdf == nil, progress: progress, showPDF: $showPDF)
                     }
                 }
                 .fullScreenCover(isPresented: $showPDF) {
                     ResearchPaperPDFView(paperName: summary.raiTitle, goBack: $showPDF, pdf: pdf!, displayedPDFURL: URL(string:summary.raiLink)!)
                         .environmentObject(comprehensionLocalFileManager)
                         .ignoresSafeArea()
                 }
                 .navigationTitle("Paper:")
             }
             .padding()
             
         }
     }
     
     func requestSimplified() {
         summarizing = true
         viewModel.setup()
         let prompt = "\(Constant.prompt.simplifyAndSummarize)\(summary.raiSummary). "
         viewModel.send(text: prompt) { response in
             DispatchQueue.main.async {
                 summarizing = false
                 simplified = response
             }
         }
     }
     
     fileprivate func fetchPaper() async {
         appState.comprehension = Comprehension(summary: summary, pdfData: nil, decodedPaper: nil)
         
         if case let (fetchedPDF?, data?) = await paperDownloadManager.fetchPaper(url: summary.raiLink.toHttps()) {
             await MainActor.run(body: {
                 pdf = fetchedPDF
                 appState.comprehension.pdfData = data
             })
         }
     }
 }



// struct RAISummaryView_Previews: PreviewProvider {
//
//    static let summary = RAISummary(source: ResearchAI.ArxivResearchPaperEntry.Entry(title: "How Close is ChatGPT to Human Experts? Comparison Corpus, Evaluation,\n  and Detection", author: [ResearchAI.ArxivResearchPaperEntry.Entry.Author(name: "Biyang Guo"), ResearchAI.ArxivResearchPaperEntry.Entry.Author(name: "Xin Zhang"), ResearchAI.ArxivResearchPaperEntry.Entry.Author(name: "Ziyuan Wang"), ResearchAI.ArxivResearchPaperEntry.Entry.Author(name: "Minqi Jiang"), ResearchAI.ArxivResearchPaperEntry.Entry.Author(name: "Jinran Nie"), ResearchAI.ArxivResearchPaperEntry.Entry.Author(name: "Yuxuan Ding"), ResearchAI.ArxivResearchPaperEntry.Entry.Author(name: "Jianwei Yue"), ResearchAI.ArxivResearchPaperEntry.Entry.Author(name: "Yupeng Wu")], published: "2023-01-18T15:23:25Z", updated: "2023-01-18T15:23:25Z", summary: "The introduction of ChatGPT has garnered widespread attention in both\nacademic and industrial communities. ChatGPT is able to respond effectively to\na wide range of human questions, providing fluent and comprehensive answers\nthat significantly surpass previous public chatbots in terms of security and\nusefulness. On one hand, people are curious about how ChatGPT is able to\nachieve such strength and how far it is from human experts. On the other hand,\npeople are starting to worry about the potential negative impacts that large\nlanguage models (LLMs) like ChatGPT could have on society, such as fake news,\nplagiarism, and social security issues. In this work, we collected tens of\nthousands of comparison responses from both human experts and ChatGPT, with\nquestions ranging from open-domain, financial, medical, legal, and\npsychological areas. We call the collected dataset the Human ChatGPT Comparison\nCorpus (HC3). Based on the HC3 dataset, we study the characteristics of\nChatGPT\'s responses, the differences and gaps from human experts, and future\ndirections for LLMs. We conducted comprehensive human evaluations and\nlinguistic analyses of ChatGPT-generated content compared with that of humans,\nwhere many interesting results are revealed. After that, we conduct extensive\nexperiments on how to effectively detect whether a certain text is generated by\nChatGPT or humans. We build three different detection systems, explore several\nkey factors that influence their effectiveness, and evaluate them in different\nscenarios. The dataset, code, and models are all publicly available at\nhttps://github.com/Hello-SimpleAI/chatgpt-comparison-detection.", link: [ResearchAI.ArxivResearchPaperEntry.Entry.Link(title: nil, href: "http://arxiv.org/abs/2301.07597v1", rel: "alternate", type: Optional("text/html")), ResearchAI.ArxivResearchPaperEntry.Entry.Link(title: Optional("pdf"), href: "http://arxiv.org/pdf/2301.07597v1", rel: "related", type: Optional("application/pdf"))]))
//
//     static var storage = StorageManager()
//
//     static var previews: some View {
//         NavigationView{
//             RAISummaryView(summary: summary).environmentObject(storage)
//         }
//     }
// }


//struct RAISummaryView: View {
//
//    @EnvironmentObject var comprehensionLocalFileManager: LocalFileManager<Comprehension>
//    @ObservedObject var appState : AppState = AppState.shared
//    @ObservedObject var viewModel = OpenAIServicer()
//    @State var simplified: String = ""
//    @State var showPDF = false
//    @State var pdf: PDFDocument? = nil
//    @State var summarizing: Bool = false
//
//
//    let summary: RAISummary
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading) {
//                Text(summary.raiTitle)
//                    .font(.headline)
//
//                Text("Authors: ")
//                    .underline()
//                    .font(.caption)
//
//                Text(summary.raiAuthors.joined(separator: ", "))
//                    .font(.caption)
//
//
//                Text("Published: ")
//                    .underline()
//                    .font(.caption)
//
//                Text(summary.raiPublished)
//                    .font(.caption)
//
//
//                Text("Last Updated: ")
//                    .underline()
//                    .font(.caption)
//
//                Text(summary.raiUpdated)
//                    .font(.caption)
//
//
//
//                Text("Summary:")
//                    .bold()
//                    .padding(.top)
//                Text(String(summary.raiSummary))
//
//
//
//                Button(action: {
//
//                    summarizing = true
//                    viewModel.setup()
//                    let prompt = "\(Constant.prompt.simplifyAndSummarize)\(summary.raiSummary). "
//                    viewModel.send(text: prompt) { response in
//                        DispatchQueue.main.async {
//                            summarizing = false
//                            simplified = response
//                        }
//                    }
//
//                }, label: {
//                    VStack(alignment: .leading) {
//                        Text("Simplified Summary:")
//                            .bold()
//                        if summarizing {
//                            ProgressView()
//                        } else {
//                            Text(simplified)
//                        }
//                    }
//                    .padding()
//                    .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
//                        .stroke(.gray, lineWidth: 1.0))
//                    .padding()
//                    .foregroundColor(simplified.isEmpty ? .blue : .black)
//
//                })
//
//
//                .task {
//
//                    appState.comprehension = Comprehension(summary: summary, pdfData: nil, decodedPaper: nil)
//
//                    if let fetchedPDF = await fetchPaper() {
//                        await MainActor.run(body: {
//                            pdf = fetchedPDF
//                        })
//                    }
//
//                }
//                .fullScreenCover(isPresented: $showPDF) {
//                    ResearchPaperPDFView(paperName: summary.raiTitle, goBack: $showPDF, pdf: pdf!, displayedPDFURL: URL(string:summary.raiLink)!)
//                        .environmentObject(comprehensionLocalFileManager)
//                        .ignoresSafeArea()
//                }
//                .navigationTitle("Paper:")
//                .toolbar {
//                    ToolbarItemGroup(placement: .navigationBarTrailing) {
//                        if pdf == nil {
//                            VStack{
//                                ProgressView()
//                                Text("Downloading")
//                            }
//                        } else {
//                            Button {
//                                showPDF.toggle()
//                            } label: {
//                                HStack {
//                                    Image(systemName: "newspaper")
//                                    Text("PDF")
//                                }
//                            }
//                        }
//                    }
//
//
//
//                }
//            }
//            .padding()
//
//        }
//    }
//
//    func fetchPaper() async -> PDFDocument? {
//
//        do {
//            let url = URL(string:summary.raiLink.toHttps())!
//            let (data, _) = try await URLSession.shared.data(from: url)
//            appState.comprehension.pdfData = data
//            return PDFDocument(data: data)!
//        } catch {
//            print(error.localizedDescription)
//        }
//        return nil
//    }
//}

//struct RAISummaryView_Previews: PreviewProvider {
//
//   static let summary = RAISummary(source: ResearchAI.ArxivResearchPaperEntry.Entry(title: "How Close is ChatGPT to Human Experts? Comparison Corpus, Evaluation,\n  and Detection", author: [ResearchAI.ArxivResearchPaperEntry.Entry.Author(name: "Biyang Guo"), ResearchAI.ArxivResearchPaperEntry.Entry.Author(name: "Xin Zhang"), ResearchAI.ArxivResearchPaperEntry.Entry.Author(name: "Ziyuan Wang"), ResearchAI.ArxivResearchPaperEntry.Entry.Author(name: "Minqi Jiang"), ResearchAI.ArxivResearchPaperEntry.Entry.Author(name: "Jinran Nie"), ResearchAI.ArxivResearchPaperEntry.Entry.Author(name: "Yuxuan Ding"), ResearchAI.ArxivResearchPaperEntry.Entry.Author(name: "Jianwei Yue"), ResearchAI.ArxivResearchPaperEntry.Entry.Author(name: "Yupeng Wu")], published: "2023-01-18T15:23:25Z", updated: "2023-01-18T15:23:25Z", summary: "The introduction of ChatGPT has garnered widespread attention in both\nacademic and industrial communities. ChatGPT is able to respond effectively to\na wide range of human questions, providing fluent and comprehensive answers\nthat significantly surpass previous public chatbots in terms of security and\nusefulness. On one hand, people are curious about how ChatGPT is able to\nachieve such strength and how far it is from human experts. On the other hand,\npeople are starting to worry about the potential negative impacts that large\nlanguage models (LLMs) like ChatGPT could have on society, such as fake news,\nplagiarism, and social security issues. In this work, we collected tens of\nthousands of comparison responses from both human experts and ChatGPT, with\nquestions ranging from open-domain, financial, medical, legal, and\npsychological areas. We call the collected dataset the Human ChatGPT Comparison\nCorpus (HC3). Based on the HC3 dataset, we study the characteristics of\nChatGPT\'s responses, the differences and gaps from human experts, and future\ndirections for LLMs. We conducted comprehensive human evaluations and\nlinguistic analyses of ChatGPT-generated content compared with that of humans,\nwhere many interesting results are revealed. After that, we conduct extensive\nexperiments on how to effectively detect whether a certain text is generated by\nChatGPT or humans. We build three different detection systems, explore several\nkey factors that influence their effectiveness, and evaluate them in different\nscenarios. The dataset, code, and models are all publicly available at\nhttps://github.com/Hello-SimpleAI/chatgpt-comparison-detection.", link: [ResearchAI.ArxivResearchPaperEntry.Entry.Link(title: nil, href: "http://arxiv.org/abs/2301.07597v1", rel: "alternate", type: Optional("text/html")), ResearchAI.ArxivResearchPaperEntry.Entry.Link(title: Optional("pdf"), href: "http://arxiv.org/pdf/2301.07597v1", rel: "related", type: Optional("application/pdf"))]))
//
//    static var storage = StorageManager()
//
//    static var previews: some View {
//        NavigationView{
//            RAISummaryView(summary: summary).environmentObject(storage)
//        }
//    }
//}

 


