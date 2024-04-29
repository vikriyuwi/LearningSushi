//
//  ContentView.swift
//  LearningSushi
//
//  Created by win win on 24/04/24.
//

import SwiftUI

struct Game: View {
    @EnvironmentObject var game: GameService
    let ingredients = ["salmon", "shrimp", "tamago", "tuna", "rice", "rice", "rice", "rice", "wakame", "tobiko", "nori", "nori"]
    @State var isStart = false
    
    @State var swing:Angle = Angle(degrees: -10)
    @State var floating:CGSize = CGSize(width: 0, height: -5)

    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            if isStart {
                Button {
                    let newIngredient = MyIngredient(name: ingredients.randomElement()!)
                    self.game.ingredients.append(newIngredient)
                    game.highestIdx += 1
                } label: {
                    Image(systemName: "plus")
                }
                if self.game.ingredients.count > 0 {
                    ForEach(self.$game.ingredients) { ingredient in
                        ItemView(zidx: game.highestIdx, ingredient: ingredient)
                    }
                }
            } else {
                Image("white_user")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .transition(.slide)
                    .offset(floating)
                    .rotationEffect(swing)
                    .onAppear {
                        let baseAnimation = Animation.easeInOut(duration: 2)
                        let repeated = baseAnimation.repeatForever(autoreverses: true)

                        withAnimation(repeated) {
                            swing = Angle(degrees: 10)
                        }
                    }
                    .onAppear {
                        let baseAnimation2 = Animation.easeInOut(duration: 1)
                        let repeated2 = baseAnimation2.repeatForever(autoreverses: true)
                        
                        withAnimation(repeated2) {
                            floating = CGSize(width: 0, height: 5)
                        }
                    }
                    .onAppear {
                        Task {
                            try? await Task.sleep(for: .seconds(3))
                            isStart = true
                        }
                    }
//                Text("Game Started!")
//                    .transition(.slide)
//                    .animation(.spring())
//                    .font(.largeTitle)
//                    .foregroundStyle(.black)
//                    .onAppear {
//                        Task {
//                            try? await Task.sleep(for: .seconds(3))
//                            isStart = true
//                        }
//                    }
            }
        }
        .ignoresSafeArea()
    }
}

// struct Game_Previews: PreviewProvider {
//    static var previews: some View {
//        Game()
//            .environmentObject(GameService())
//    }
// }
