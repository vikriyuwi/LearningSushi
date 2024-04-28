//
//  GamePlayHostView.swift
//  LearningSushi
//
//  Created by win win on 27/04/24.
//

import SwiftUI

struct GamePlayHostView: View {
    @EnvironmentObject var model: DeviceFinderViewModel
//    @StateObject var model = DeviceFinderViewModel()
    @State var highestIdx = 1.0
    let defaults = UserDefaults.standard
    let ingredients = ["salmon","shrimp","tamago", "tuna", "rice", "rice"]
    @State var myIngredients:[MyIngredient] = []
    var peerToConnect:PeerDevice
    
    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Button {
                let newIngredient = MyIngredient(name: ingredients.randomElement()!)
                self.model.ingredients.append(newIngredient)
                highestIdx+=1
            } label: {
                Image(systemName: "plus")
            }
            if self.model.ingredients.count > 0 {
                ForEach(self.$model.ingredients) { ingredient in
                    ItemView(zidx: Double(highestIdx), ingredient: ingredient, highestIdx: $highestIdx)
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            model.joinedPeer.append(peerToConnect)
        }
    }
}
//
//#Preview {
//    GamePlayHostView()
//}
