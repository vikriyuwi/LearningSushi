//
//  TutorialNoriTobiko.swift
//  OnboardingSuhsi
//
//  Created by win win on 30/04/24.
//

import SwiftUI

struct TutorialNoriTobiko: View {
    @State var dragOffset = UIScreen.main.bounds.width / 8 + 20
    @State var draggedObjectScale:Double = 0
    @State var combinedObjectScale:Double = 0
    
    let column = Array(repeating: GridItem(.fixed(UIScreen.main.bounds.width / 8 + 20)), count: 4)
    var body: some View {
        VStack {
            ZStack {
                Image("nori")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width / 8)
                    .scaleEffect(draggedObjectScale)
                Image("tobiko")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width / 8)
                    .offset(x: dragOffset)
                    .scaleEffect(draggedObjectScale)
                Image("tobiko nori")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width / 8)
                    .scaleEffect(combinedObjectScale)
                Image("point_finger")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.5)
                    .frame(width: UIScreen.main.bounds.width / 8)
                    .offset(x: dragOffset + 50, y: 50)
                    .opacity(draggedObjectScale == 1 ? 1 : 0 )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                withAnimation(.spring(duration: 1)) {
                    draggedObjectScale = 1
                }
                Task {
                    try? await Task.sleep(for: .seconds(2))
                    withAnimation(.spring(duration: 1)) {
                        dragOffset = 0
                    }
                }
            }
            .onChange(of: dragOffset, {
                withAnimation(.spring(duration: 1).delay(1)) {
                    draggedObjectScale = 0
                    combinedObjectScale = 1
                }
            })
        }
        .padding()
    }
}

#Preview {
    TutorialNoriTobiko()
}
