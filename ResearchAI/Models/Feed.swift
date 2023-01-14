import XMLParsing
import SwiftUI

struct Feed: Decodable {
    let entry: [Entry]

    struct Entry: Decodable {
        let title: String
        let author: [Author]
        let published: String
        let updated: String
        let summary: String
        let link: [Link]

        struct Link: Decodable {
            let title: String?
            let href: String
            let rel: String
            let type: String?

            private enum CodingKeys: String, CodingKey {
                case title, href, rel, type
            }
        }
        struct Author: Decodable {
            let name: String
        }

       

   
    }
}

