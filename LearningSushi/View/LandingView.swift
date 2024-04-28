//
//  LandingView.swift
//  LearningSushi
//
//  Created by win win on 27/04/24.
//

import SwiftUI

struct LandingView: View {
    @State var avaUser = UserDefaults.standard.string(forKey: "SUSHI_AVA")
    @State var changeAvaSheet:Bool = false
    @State private var action: Int? = 0
    @State var scale:Double = 0.9
    
    var body: some View {
        VStack {
            Button {
                changeAvaSheet = true
            } label: {
                Image(avaUser ?? "AvaDefault")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .scaledToFit()
                    .padding(10)
                    .scaleEffect(scale)
                    .onAppear {
                        let baseAnimation = Animation.spring(duration: 2)
                        let repeated = baseAnimation.repeatForever(autoreverses: true)

                        withAnimation(repeated) {
                            scale = 1
                        }
                    }
            }
            .padding(2)
            .sensoryFeedback(.start, trigger: changeAvaSheet)
            NavigationLink(destination: ConnectFriend()) {
                Image("ButtonPlay")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("Background").resizable().scaledToFill()
        )
        .sheet(isPresented: $changeAvaSheet, content: {
            ChangeAvaView(currentAva: $avaUser)
                .presentationDetents([.medium, .large])
                .presentationCornerRadius(40)
        })
    }
}

#Preview {
    LandingView()
}
