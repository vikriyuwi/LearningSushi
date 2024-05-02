//
//  TutorialRemove.swift
//  OnboardingSuhsi
//
//  Created by win win on 01/05/24.
//

import SwiftUI

struct TutorialRemove: View {
    @State var objectOpacity:Double = 1
    @State var opacity:Double = 0
    @State var objectOffset = 0
    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            Image("ipad frame")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 3 * 2)
            Image("sushi shrimp")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 8)
                .opacity(objectOpacity)
                .offset(CGSize(width: objectOffset, height: 0))
            Image("point_finger")
                .resizable()
                .scaledToFit()
                .opacity(opacity)
                .frame(width: UIScreen.main.bounds.width / 8)
                .offset(CGSize(width: objectOffset + 50, height: 50))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.spring(duration: 1)) {
                opacity = 0.5
            }
            Task {
                try? await Task.sleep(for: .seconds(1))
                withAnimation(.spring(duration: 1)) {
                    objectOffset = Int(UIScreen.main.bounds.width / 3 * 1 - 50)
                }
            }
        }
        .onChange(of: objectOffset, {
            withAnimation(.spring(duration: 0.5).delay(1)) {
                opacity = 0
            }
        })
        .onChange(of: objectOffset, {
            withAnimation(.spring(duration: 1).delay(1.5)) {
                objectOpacity = 0
            }
        })
    }
}

#Preview {
    TutorialRemove()
}
