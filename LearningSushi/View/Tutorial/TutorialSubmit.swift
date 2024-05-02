//
//  TutorialSubmit.swift
//  OnboardingSuhsi
//
//  Created by win win on 02/05/24.
//

import SwiftUI

struct TutorialSubmit: View {
    @State var objectScale:Double = 1
    @State var opacity:Double = 0
    @State var objectOffset = 0
    @State var submitObjectScale:Double = 0
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
                .frame(height: UIScreen.main.bounds.height/3*2)
            Image("sushi salmon")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 8)
                .scaleEffect(objectScale)
                .offset(CGSize(width: 0, height: objectOffset))
            Image("sushi salmon check")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 8)
                .scaleEffect(submitObjectScale)
                .offset(CGSize(width: 0, height: objectOffset))
            Image("point_finger")
                .resizable()
                .scaledToFit()
                .opacity(opacity)
                .frame(width: UIScreen.main.bounds.width / 8)
                .offset(CGSize(width: 50, height: objectOffset + 50))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.spring(duration: 1)) {
                opacity = 0.5
            }
            Task {
                try? await Task.sleep(for: .seconds(1))
                withAnimation(.spring(duration: 1)) {
                    objectOffset = Int(UIScreen.main.bounds.height / 3 * 1 - 50)
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
                objectScale = 0
                submitObjectScale = 1
            }
        })
    }
}

#Preview {
    TutorialSubmit()
}
