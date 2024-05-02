//
//  TutorialSend.swift
//  OnboardingSuhsi
//
//  Created by win win on 30/04/24.
//

import SwiftUI

struct TutorialSend: View {
    
    @State var ipadOffset = -500
    @State var objectOffset = 250
    @State var fingerOffset = 250
    @State var opacity:Double = 0
    
    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Image("ipad frame")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 3 * 2)
                .offset(CGSize(width: 0, height: UIScreen.main.bounds.height / 6 * 2))
            Image("ipad frame")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 3 * 2)
                .offset(CGSize(width: 0, height: ipadOffset))
            Image("wakame nori")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 8)
                .offset(CGSize(width: 0, height: objectOffset))
            Image("point_finger")
                .resizable()
                .scaledToFit()
                .opacity(opacity)
                .frame(width: UIScreen.main.bounds.width / 8)
                .offset(CGSize(width: 50, height: fingerOffset + 50))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation(.spring(duration: 0.5).delay(0.5)) {
                opacity = 0.5
                ipadOffset = Int(UIScreen.main.bounds.height / 5 * -2)
            }
            Task {
                try? await Task.sleep(for: .seconds(1))
                withAnimation(.spring(duration: 1)) {
                    objectOffset = 100
                    fingerOffset = 100
                }
            }
        }
        .onChange(of: objectOffset, {
            withAnimation(.spring(duration: 1).delay(1)) {
                objectOffset = -250
                opacity = 0
            }
        })
    }
}

#Preview {
    TutorialSend()
}
