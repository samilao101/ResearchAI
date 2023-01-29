//
//  ResearchPaper.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/28/22.
//

import Foundation


struct ArxivResearchPaperMetaData: Decodable, Identifiable {
    var id = UUID()
    let title: String
    let authors: [Author]
    let published: String
    let updated: String
    let summary: String
    let link: [Link]

    enum CodingKeys: String, CodingKey {
        case title, authors, published, updated, summary, link
    }

    struct Author: Decodable {
        let name: String
    }

    struct Link: Decodable, Hashable {
        let title: String?
        let href: String
        let rel: String
        let type: String?

        private enum CodingKeys: String, CodingKey {
            case title, href, rel, type
        }
    }
}



