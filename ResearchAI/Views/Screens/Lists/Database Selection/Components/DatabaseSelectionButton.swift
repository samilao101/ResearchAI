//
//  DatabaseSelectionButton.swift
//  ResearchAI
//
//  Created by Sam Santos on 3/3/23.
//

import SwiftUI

struct DatabaseSelectionButton: View {
    
    @Binding var selectingDatabase: Bool
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Button {
                    selectingDatabase.toggle()
                } label: {
                    Image(systemName: "server.rack")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    
                }
                .frame(width: 70, height: 70)
                .background(Color.white)
                .foregroundColor(.black)
                .clipShape(Circle())
                .shadow(radius: 10)
                .padding()
                Spacer()
                
            }
        }
    }
}

struct DatabaseSelectionButton_Previews: PreviewProvider {
    static var previews: some View {
        DatabaseSelectionButton(selectingDatabase: .constant(true))
    }
}
