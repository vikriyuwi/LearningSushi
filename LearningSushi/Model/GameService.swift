//
//  GameService.swift
//  Multipeer
//
//  Created by Kurnia Kharisma Agung Samiadjie on 28/04/24.
//

import Foundation

enum ScreenPhase {
    case menu, lobby, startGame, end
}

class GameService: ObservableObject {
    @Published var highestIdx: Double = 1.0
    @Published var ingredients: [MyIngredient] = []
    @Published var screenPhase: ScreenPhase = .menu

    func appendItem(ingredient: String) {
        ingredients.append(MyIngredient(name: ingredient))
    }
}
