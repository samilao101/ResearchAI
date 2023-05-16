//
//  ArticleRowView.swift
//  ResearchAI
//
//  Created by Sam Santos on 3/3/23.
//

import SwiftUI

struct ArticleRowView: View {
    
    let title: String
    let authors: [String]
    let tags: [String]
    let columns = [GridItem(.adaptive(minimum: 80), spacing: 0), GridItem(.adaptive(minimum: 80), spacing: 0), GridItem(.adaptive(minimum: 80), spacing: 0)]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            Text(authors.map { $0 }.joined(separator: ", "))
                .font(.subheadline)
            if tags.isEmpty {
                EmptyView()
            } else {
                FlowLayout {
                    ForEach(tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(Color.gray)
                            .cornerRadius(10)
                    }
                }
                
            }
        }
    }
}

struct ArticleRowView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleRowView(title: "Machine Learning Maniforlds", authors: ["Samil Cruz", "Paveli Cruz", "Pamela Cruz"], tags: ["Computer Science", "Machine Learning", "Mathematics", "Neurosciences"])
            .previewLayout(.sizeThatFits)
    }
}

struct FlowLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let containerWidth = proposal.replacingUnspecifiedDimensions().width
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        return layout(sizes: sizes, containerWidth: containerWidth).size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let offsets = layout(sizes: sizes, containerWidth: bounds.width).offsets
        for (offset, subview) in zip(offsets, subviews) {
            subview.place(at: CGPoint(x: offset.x  + bounds.minX, y: offset.y + bounds.minY), proposal: .unspecified)
        }
    }
}

func layout(sizes: [CGSize], spacing: CGFloat = 2, containerWidth: CGFloat) -> (offsets: [CGPoint], size: CGSize) {
    var result: [CGPoint] = []
    var currentPosition: CGPoint = .zero
    var lineHeight: CGFloat = 0
    var maxX: CGFloat = 0
    for size in sizes {
        if currentPosition.x + size.width > containerWidth {
            currentPosition.x = 0
            currentPosition.y += lineHeight + spacing
            lineHeight = 0
        }
        
        result.append(currentPosition)
        currentPosition.x += size.width
        maxX = max(maxX, currentPosition.x)
        currentPosition.x += spacing
        lineHeight = max(lineHeight, size.height)
    }
    
    return (result, CGSize(width: maxX, height: currentPosition.y + lineHeight))
}
