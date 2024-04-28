//
//  ContentView.swift
//  LearningSushi
//
//  Created by win win on 24/04/24.
//

import SwiftUI

struct Game: View {
    @EnvironmentObject var game: GameService
    let ingredients = ["salmon", "shrimp", "tamago", "tuna", "rice", "rice"]
    @State var isStart = false

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
                Text("Game Started!")
                    .transition(.slide)
                    .animation(.spring())
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                    .onAppear {
                        Task {
                            try? await Task.sleep(for: .seconds(3))
                            isStart = true
                        }
                    }
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
